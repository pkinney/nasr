defmodule NASR do
  @moduledoc false

  require Logger

  def list_layouts do
    dir()
    |> Path.join("layouts")
    |> File.ls!()
    |> Enum.filter(fn file -> String.ends_with?(file, ".txt") end)
    |> Enum.map(fn f ->
      cat = f |> String.split("_") |> List.first() |> String.upcase()
      data_file = "#{cat}.txt"
      layout_file = Path.join(dir(), f)
      {cat, layout_file, data_file}
    end)
  end

  def stream do
    stream(categories())
  end

  def stream(categories) when is_list(categories) do
    zip_file_path = find_zip_file()

    {:ok, zip_file} =
      case zip_file_path do
        nil -> {:ok, nil}
        file -> file |> Unzip.LocalFile.open() |> Unzip.new()
      end

    categories
    |> Enum.map(fn cat ->
      if preprocessed?(cat) do
        data_file = Path.join([dir(), "output", "#{cat}.data"])

        Logger.debug("[#{__MODULE__}] Creating stream for #{cat} from preprocessed file #{data_file}...")

        TermStream.deserialize(File.stream!(data_file, 512 * 1024, [:read, :binary]))
      else
        if zip_file == nil do
          raise "no NARS zip file found in the data directory. Download the latest NASR zip file from https://www.faa.gov/air_traffic/flight_info/aeronav/aero_data/NASR_Subscription/ and place it in `#{Path.join([dir(), "data"])}"
        end

        layout_file = Path.join([dir(), "layouts", "#{cat}_rf.txt"])
        data_file = "#{cat}.txt"

        Logger.debug(
          "[#{__MODULE__}] Creating stream for #{cat} from #{zip_file_path} with layout from #{layout_file}..."
        )

        layout = NASR.Layout.load(layout_file)
        NASR.Entities.stream(zip_file, data_file, layout)
      end
    end)
    |> Enum.reduce(nil, fn
      a, nil -> a
      a, b -> Stream.concat(a, b)
    end)
  end

  def stream(zip_file_path, category), do: stream(zip_file_path, [category])

  def categories do
    Enum.map(list_layouts(), &elem(&1, 0))
  end

  def load(zip_file_path, file, layout) do
    {:ok, zip_file} = zip_file_path |> Unzip.LocalFile.open() |> Unzip.new()
    NASR.Entities.load(zip_file, file, layout)
  end

  def stream(zip_file_path, file, layout) do
    {:ok, zip_file} = zip_file_path |> Unzip.LocalFile.open() |> Unzip.new()
    NASR.Entities.stream(zip_file, file, layout)
  end

  def preprocessed?(cat) do
    File.exists?(Path.join([dir(), "output", "#{cat}.data"]))
  end

  def find_zip_file do
    if File.exists?(Path.join([dir(), "data"])) do
      dir()
      |> Path.join("data")
      |> File.ls!()
      |> Enum.find(fn file -> String.starts_with?(file, "28DaySubscription") and String.ends_with?(file, ".zip") end)
      |> then(fn
        nil ->
          nil

        file ->
          Path.join([dir(), "data", file])
      end)
    end
  end

  defp dir, do: :code.priv_dir(:nasr)
end
