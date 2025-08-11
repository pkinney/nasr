defmodule NASR do
  @moduledoc false
  alias Credo.CLI.Options
  alias NASR.Entities.Airport

  require Logger

  @doc """
  Creates a stream of raw maps for each entity in the NASR file. The NASR file can be sourced from a local file or url.
  If no options are provided, it defaults to the latest NASR zip file available at the FAA's website.

  ## Options
  - `:file` - Path to a local NASR zip file.
  - `:url` - URL to a NASR zip file.

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

  def stream_structs(opts \\ []) do
    types = Map.new(entity_modules(), fn module -> {module.type(), module} end)

    opts
    |> stream_raw()
    |> Stream.map(fn %{"__TYPE__" => type} = raw ->
      module = Map.get(types, type)
      module.new(raw)
    end)
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

  def module_for_type(type) do
    # TODO: Make a better way of doing this
    Enum.find(entity_modules(), &(&1.type == type))
  end

  defp entity_modules do
    with {:ok, list} <- :application.get_key(:nasr, :modules) do
      Enum.filter(list, &(length(Module.split(&1)) > 2 and &1 |> Module.split() |> Enum.take(2) == ~w(NASR Entities)))
    end
  end

  #   @doc """
  #   Creates a stream of NASR.Entities structs.

  #   ## Options
  #   - `:file` - Path to a local NASR zip file.
  #   - `:url` - URL to a NASR zip file.
  #   - `:entities` - List of entity types to include in the stream. Defaults to all entities.
  #   """

  #   def stream_structs(opts \\ []) do
  #     {:ok, stream, file} = open_stream(opts)

  #     classes = airport_classes(file: file)
  #     # If entities are specified, filter the categories to only include those
  #     entities = Keyword.get(opts, :entities, NASR.Entities.entity_modules())

  #     categories =
  #       entities
  #       |> Enum.map(fn entity ->
  #         entity
  #         |> NASR.Entities.entity_to_category()
  #         |> case do
  #           nil ->
  #             Logger.warning("[#{__MODULE__}] No category found for entity #{inspect(entity)}. Skipping...")
  #             nil

  #           cat ->
  #             String.upcase(cat)
  #         end
  #       end)
  #       |> IO.inspect()
  #       |> Enum.reject(&is_nil/1)
  #       |> Enum.map(&String.upcase/1)
  #       |> Enum.uniq()

  #     types =
  #       entities
  #       |> Enum.map(&NASR.Entities.entity_to_type/1)
  #       |> Enum.reject(&is_nil/1)
  #       |> Enum.uniq()
  #       |> MapSet.new()

  #     stream
  #     |> raw_stream(categories)
  #     |> Stream.filter(fn %{type: type} ->
  #       MapSet.member?(types, type)
  #     end)
  #     |> Stream.map(&NASR.Entities.from_raw/1)
  #     |> Stream.reject(&is_nil/1)
  #     |> Stream.map(fn
  #       %Airport{} = airport ->
  #         Map.put(airport, :class, Map.get(classes, airport.nasr_id, :G))

  #       entity ->
  #         entity
  #     end)
  #   end

  #   def stream_airports(opts \\ []) do
  #     opts
  #     |> Keyword.put(:entities, [
  #       Airport,
  #       NASR.Entities.AirportAttendance,
  #       NASR.Entities.AirportRemark,
  #       NASR.Entities.WxStation,
  #       NASR.Entities.Runway
  #     ])
  #     |> stream_structs()
  #   end

  #   def load_layouts(opts \\ []) do
  #     skip = ["fss_rf.txt", "Stardp_rf.txt", "lid_rf.txt", "com_rf.txt", "Wxl_rf.txt"]
  #     {:ok, stream, _file} = open_stream(opts)

  #     stream
  #     |> Unzip.list_entries()
  #     |> Enum.map(& &1.file_name)
  #     |> Enum.filter(&String.starts_with?(&1, "Layout_Data"))
  #     |> Enum.reject(fn filename ->
  #       Enum.any?(skip, &String.ends_with?(filename, &1))
  #     end)
  #     |> Enum.map(fn filename ->
  #       Logger.info("[#{__MODULE__}] Loading layout from #{filename}...")

  #       category = filename |> Path.basename() |> String.replace("_rf.txt", "") |> String.upcase()

  #       stream
  #       |> Unzip.file_stream!(filename)
  #       |> Enum.map_join(&IO.iodata_to_binary/1)
  #       |> NASR.Layout.parse(category)
  #     end)
  #     |> List.flatten()

  #     # Map.new(list_layouts(), fn {cat, layout_file, data_file} ->
  #     #   Logger.info("[#{__MODULE__}] Loading layout for #{cat} from #{layout_file}...")
  #     #   layout = NASR.Layout.load(layout_file)
  #     #   {cat, layout, data_file}
  #     # end)
  #   end

  defp open_stream(opts) do
    cond do
      Keyword.has_key?(opts, :file) ->
        {:ok, stream} = opts |> Keyword.get(:file) |> Unzip.LocalFile.open() |> Unzip.new()
        {:ok, stream, Keyword.get(opts, :file)}

      Keyword.has_key?(opts, :url) ->
        url = Keyword.get(opts, :url)
        file = NASR.Utils.download(url)
        {:ok, stream} = file |> Unzip.LocalFile.open() |> Unzip.new()
        {:ok, stream, file}

      true ->
        url = NASR.Utils.get_current_nasr_url()
        open_stream(url: url)
    end
  end

  defp open_csv_stream(stream) do
    csv_file_in_zip =
      stream
      |> Unzip.list_entries()
      |> Enum.filter(&(String.starts_with?(&1.file_name, "CSV_Data") && String.ends_with?(&1.file_name, ".zip")))
      |> List.first()
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

  #   defp list_layouts do
  #     dir()
  #     |> Path.join("layouts")
  #     |> File.ls!()
  #     |> Enum.filter(fn file -> String.ends_with?(file, ".txt") end)
  #     |> Enum.map(fn f ->
  #       cat = f |> String.split("_") |> List.first() |> String.upcase()
  #       data_file = "#{cat}.txt"
  #       layout_file = Path.join(dir(), f)
  #       {cat, layout_file, data_file}
  #     end)
  #   end

  #   defp raw_stream(zip_file, categories) when is_list(categories) do
  #     Logger.info("[#{__MODULE__}] Streaming...")

  #     categories
  #     |> Enum.map(&String.downcase(&1))
  #     |> Enum.map(fn cat ->
  #       if zip_file == nil do
  #         raise "no NARS zip file found in the data directory. Download the latest NASR zip file from https://www.faa.gov/air_traffic/flight_info/aeronav/aero_data/NASR_Subscription/ and place it in `#{Path.join([dir(), "data"])}"
  #       end

  #       layout_file = Path.join([dir(), "layouts", "#{cat}_rf.txt"])
  #       data_file = "#{String.upcase(cat)}.txt"

  #       Logger.debug("[#{__MODULE__}] Creating stream for #{cat} with layout from #{layout_file}...")

  #       layout = NASR.Layout.load(layout_file)
  #       NASR.Entities.stream(zip_file, data_file, layout)
  #     end)
  #     |> Enum.reduce(nil, fn
  #       a, nil -> a
  #       a, b -> Stream.concat(a, b)
  #     end)
  #   end

  #   @doc """
  #   Because the airport entities do not have a field representing the airspace class they sit under, this function
  #   reads the `CLS_ARSP.csv` file from the NASR zip file and returns a map of site IDs to their respective airspace classes.

  #   The returned map will have keys as site IDs (formatted as "SITE_NO*SITE_TYPE_CODE") and values as the airspace class
  #   (`:B`, `:C`, `:D`, `:E`), or `nil` if the site does not have a defined airspace class.

  #   Options are the same as for `open_stream/1`, allowing you to specify a local file or a URL to the NASR zip file.
  #   """
  #   def airport_classes(opts \\ []) do
  #     {:ok, stream, _} = open_stream(opts)

  #     csv_file_in_zip =
  #       stream
  #       |> Unzip.list_entries()
  #       |> Enum.filter(&(String.starts_with?(&1.file_name, "CSV_Data") && String.ends_with?(&1.file_name, ".zip")))
  #       |> List.first()
  #       |> then(fn
  #         nil ->
  #           raise "No CSV_Data zip file found in the NASR zip file"

  #         file ->
  #           file.file_name
  #       end)

  #     csv_filename = Briefly.create!()

  #     :ok =
  #       stream
  #       |> Unzip.file_stream!(csv_file_in_zip)
  #       |> Stream.into(File.stream!(csv_filename))
  #       |> Stream.run()

  #     {:ok, csv_unzip} =
  #       csv_filename
  #       |> Unzip.LocalFile.open()
  #       |> Unzip.new()

  #     [headers | lines] =
  #       csv_unzip
  #       |> Unzip.file_stream!("CLS_ARSP.csv")
  #       |> Stream.map(fn c -> IO.iodata_to_binary(c) end)
  #       |> NimbleCSV.RFC4180.to_line_stream()
  #       |> NimbleCSV.RFC4180.parse_stream(skip_headers: false)
  #       |> Enum.to_list()

  #     lines
  #     |> Enum.map(fn line -> headers |> Enum.zip(line) |> Map.new() end)
  #     |> Enum.map(fn %{"SITE_NO" => site_no, "SITE_TYPE_CODE" => type_code} = line ->
  #       Map.put(line, "SITE_ID", site_no <> "*" <> type_code)
  #     end)
  #     |> Map.new(fn
  #       %{"SITE_ID" => site_id, "CLASS_B_AIRSPACE" => "Y"} -> {site_id, :B}
  #       %{"SITE_ID" => site_id, "CLASS_C_AIRSPACE" => "Y"} -> {site_id, :C}
  #       %{"SITE_ID" => site_id, "CLASS_D_AIRSPACE" => "Y"} -> {site_id, :D}
  #       %{"SITE_ID" => site_id, "CLASS_E_AIRSPACE" => "Y"} -> {site_id, :E}
  #       _ -> nil
  #     end)
  #   end

  #   defp dir, do: :code.priv_dir(:nasr)
end
