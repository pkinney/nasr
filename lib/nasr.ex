defmodule NASR do
  @moduledoc false

  require Logger

  def stream_airports(opts \\ []) do
    {:ok, stream} =
      cond do
        Keyword.has_key?(opts, :file) ->
          # open the file stream from
          open_zip(Keyword.get(opts, :file))

        Keyword.has_key?(opts, :url) ->
          url = Keyword.get(opts, :url)
          # open the file stream from
          file = NASR.Utils.download(url)
          open_zip(file)

        true ->
          url = NASR.Utils.get_current_nasr_url()
          file = NASR.Utils.download(url)
          open_zip(file)
      end

    classes = airport_classes(stream)

    stream
    |> raw_stream(["APT", "AWOS"])
    |> Stream.map(fn entity ->
      case entity.type do
        :apt -> NASR.Airport.new(entity)
        :apt_rwy -> NASR.Runway.new(entity)
        :apt_rmk -> NASR.AirportRemark.new(entity)
        :apt_att -> NASR.AirportAttendance.new(entity)
        _ -> nil
      end
    end)
    |> Stream.reject(&is_nil/1)
    |> Stream.map(fn
      %NASR.Airport{} = airport ->
        Map.put(airport, :class, Map.get(classes, airport.nasr_id, :G))

      entity ->
        entity
    end)
  end

  defp open_zip(zip_file_path) do
    Logger.info("[#{__MODULE__}] Opening zip file #{zip_file_path}")
    zip_file_path |> Unzip.LocalFile.open() |> Unzip.new()
  end

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

  def raw_stream(zip_file_path, categories) when is_binary(zip_file_path) do
    {:ok, zip_file} = zip_file_path |> Unzip.LocalFile.open() |> Unzip.new()
    raw_stream(zip_file, categories)
  end

  def raw_stream(zip_file, categories) when is_list(categories) do
    Logger.info("[#{__MODULE__}] Streaming...")

    categories
    |> Enum.map(&String.downcase(&1))
    |> Enum.map(fn cat ->
      if preprocessed?(cat) do
        data_file = Path.join([dir(), "output", "#{cat}.data"])

        Logger.info("[#{__MODULE__}] Creating stream for #{cat} from preprocessed file #{data_file}...")

        TermStream.deserialize(File.stream!(data_file, 512 * 1024, [:read, :binary]))
      else
        if zip_file == nil do
          raise "no NARS zip file found in the data directory. Download the latest NASR zip file from https://www.faa.gov/air_traffic/flight_info/aeronav/aero_data/NASR_Subscription/ and place it in `#{Path.join([dir(), "data"])}"
        end

        layout_file = Path.join([dir(), "layouts", "#{cat}_rf.txt"])
        data_file = "#{String.upcase(cat)}.txt"

        Logger.info("[#{__MODULE__}] Creating stream for #{cat} with layout from #{layout_file}...")

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

  def airport_classes(stream) do
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

    {:ok, csv_unzip} =
      csv_filename
      |> Unzip.LocalFile.open()
      |> Unzip.new()

    [headers | lines] =
      csv_unzip
      |> Unzip.file_stream!("CLS_ARSP.csv")
      |> Stream.map(fn c -> IO.iodata_to_binary(c) end)
      |> NimbleCSV.RFC4180.to_line_stream()
      |> NimbleCSV.RFC4180.parse_stream(skip_headers: false)
      |> Enum.to_list()

    lines
    |> Enum.map(fn line -> headers |> Enum.zip(line) |> Map.new() end)
    |> Enum.map(fn %{"SITE_NO" => site_no, "SITE_TYPE_CODE" => type_code} = line ->
      Map.put(line, "SITE_ID", site_no <> "*" <> type_code)
    end)
    |> Map.new(fn
      %{"SITE_ID" => site_id, "CLASS_B_AIRSPACE" => "Y"} -> {site_id, :B}
      %{"SITE_ID" => site_id, "CLASS_C_AIRSPACE" => "Y"} -> {site_id, :C}
      %{"SITE_ID" => site_id, "CLASS_D_AIRSPACE" => "Y"} -> {site_id, :D}
      %{"SITE_ID" => site_id, "CLASS_E_AIRSPACE" => "Y"} -> {site_id, :E}
      _ -> nil
    end)
  end

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
      |> Enum.find(fn file ->
        String.starts_with?(file, "28DaySubscription") and String.ends_with?(file, ".zip")
      end)
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
