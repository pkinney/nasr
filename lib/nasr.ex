defmodule NASR do
  @moduledoc false

  require Logger

  @doc """
  Creates a stream of raw maps for each entity in the NASR file. The NASR file can be sourced from a local file or url.
  If no options are provided, it defaults to the latest NASR zip file available at the FAA's website.

  ## Options
  - `:file` - Path to a local NASR zip file.
  - `:url` - URL to a NASR zip file.
  - `:stream` - An already opened Unzip stream (for internal use cases).

  ## Examples
      iex> NASR.stream_raw(file: "path/to/nasr.zip")
      #Stream<...>

      iex> NASR.stream_raw(url: "https://example.com/nasr.zip")
      #Stream<...>

      iex> NASR.stream_raw()
      #Stream<...>
  """
  def stream_raw(opts \\ []) do
    {:ok, root_zip, _file} = open_stream(opts)
    {:ok, csv_zip} = open_csv_stream(root_zip)

    csv_zip
    |> list_files()
    |> Stream.filter(fn file ->
      case Keyword.get(opts, :include) do
        files when is_list(files) -> Enum.member?(files, String.replace(file, ".csv", ""))
        nil -> true
      end
    end)
    |> Enum.to_list()
    |> Enum.map(fn file ->
      stream =
        csv_zip
        |> Unzip.file_stream!(file)
        |> Stream.map(fn c -> IO.iodata_to_binary(c) end)
        |> NimbleCSV.RFC4180.to_line_stream()
        |> NimbleCSV.RFC4180.parse_stream(skip_headers: false)

      [headers] = Enum.take(stream, 1)
      # remove any non-ASCII characters from the headers

      headers =
        headers
        |> Enum.map(&String.replace(&1, ~r/[^\x20-\x7E]/, ""))
        |> Enum.map(&String.trim/1)

      lines = Stream.drop(stream, 1)

      Stream.map(lines, fn line ->
        headers
        |> Enum.zip(line)
        |> Map.new()
        |> Map.put("__FILE__", file)
        |> Map.put("__TYPE__", String.replace(file, ".csv", ""))
      end)
    end)
    |> Enum.reduce(nil, fn
      a, nil -> a
      a, b -> Stream.concat(a, b)
    end)
  end

  def stream_entities(opts \\ []) do
    opts =
      if Keyword.has_key?(opts, :include) do
        include =
          opts
          |> Keyword.get(:include)
          |> Enum.map(fn
            module when is_atom(module) -> module.type()
            type when is_binary(type) -> type
          end)

        Keyword.put(opts, :include, include)
      else
        opts
      end

    opts
    |> stream_raw()
    |> Stream.map(&from_raw/1)
  end

  def from_raw(%{"__TYPE__" => type} = raw) do
    case module_for_type(type) do
      nil -> nil
      module -> module.new(raw)
    end
  end

  def list_types(opts \\ []) do
    {:ok, root_zip, _file} = open_stream(opts)
    {:ok, csv_zip} = open_csv_stream(root_zip)

    csv_zip
    |> list_files()
    |> Enum.map(&String.replace(&1, ".csv", ""))
  end

  defp list_files(csv_zip) do
    csv_zip
    |> Unzip.list_entries()
    |> Enum.map(& &1.file_name)
    |> Stream.filter(&String.ends_with?(&1, ".csv"))
    |> Stream.reject(&String.ends_with?(&1, "DATA_STRUCTURE.csv"))
  end

  @doc """
  Returns the module responsible for handling the given NASR entity type.
  """
  @spec module_for_type(String.t()) :: module() | nil
  def module_for_type(type) do
    types =
      :nasr
      |> Application.get_env(:modules_for_type)
      |> case do
        nil ->
          t =
            Map.new(entity_modules(), fn module -> {module.type(), module} end)

          Application.put_env(:nasr, :modules_for_type, t)
          t

        types ->
          types
      end

    Map.get(types, type)
  end

  @doc """
  Returns a list of all NASR entity modules.
  """
  @spec entity_modules() :: [module()]
  def entity_modules do
    {:ok, modules} = :application.get_key(:nasr, :modules)

    Enum.filter(modules, fn module ->
      module
      |> Module.split()
      |> case do
        ["NASR", "Entities", _ | _] -> true
        _ -> false
      end
    end)
  end

  defp open_stream(opts) do
    cond do
      Keyword.has_key?(opts, :stream) ->
        {:ok, Keyword.get(opts, :stream), nil}

      Keyword.has_key?(opts, :file) ->
        {:ok, stream} = opts |> Keyword.get(:file) |> Unzip.LocalFile.open() |> Unzip.new()
        {:ok, stream, Keyword.get(opts, :file)}

      Keyword.has_key?(opts, :url) ->
        url = Keyword.get(opts, :url)
        {:ok, file} = NASR.Utils.download(url)
        {:ok, stream} = file |> Unzip.LocalFile.open() |> Unzip.new()
        {:ok, stream, file}

      true ->
        url = NASR.Utils.get_current_nasr_url()
        open_stream(url: url)
    end
  end

  @doc """
  Downloads the latest NASR zip file from the FAA's website to a temporary file and returns the local file path.
  """
  @spec download_latest_nasr_file() :: {:ok, String.t()}
  def download_latest_nasr_file do
    url = NASR.Utils.get_current_nasr_url()
    NASR.Utils.download(url)
  end

  defp open_csv_stream(stream) do
    csv_file_in_zip =
      stream
      |> Unzip.list_entries()
      |> Enum.find(&(String.starts_with?(&1.file_name, "CSV_Data") && String.ends_with?(&1.file_name, ".zip")))
      |> then(fn
        nil ->
          raise "No CSV_Data zip file found in the NASR zip file"

        file ->
          file.file_name
      end)

    csv_filename = Briefly.create!()

    :ok =
      stream
      |> Unzip.file_stream!(csv_file_in_zip)
      |> Stream.into(File.stream!(csv_filename))
      |> Stream.run()

    csv_filename
    |> Unzip.LocalFile.open()
    |> Unzip.new()
  end
end
