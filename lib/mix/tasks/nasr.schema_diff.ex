defmodule Mix.Tasks.Nasr.SchemaDiff do
  @moduledoc """
  Compare NASR CSV headers between the current cycle and a past cycle.

  Usage:
      mix nasr.schema_diff 3

  The argument is the number of AIRAC cycles to go back (each cycle is 28 days).
  The task downloads both archives (unless overridden) and reports column
  additions/removals per CSV file.

  ## Options
    * `--current-url URL` – override the download URL for the current cycle.
    * `--previous-url URL` – override the download URL for the past cycle.
    * `--include TYPES` – comma-separated list of CSV types to check (e.g. `APT_BASE,FIX_BASE`).
  """
  use Mix.Task

  alias NimbleCSV.RFC4180
  alias NASR.Utils

  @base_url "https://www.faa.gov/air_traffic/flight_info/aeronav/aero_data/NASR_Subscription/"
  @shortdoc "Diff NASR CSV headers between cycles"

  @impl Mix.Task
  def run([cycles_back | rest]) do
    Mix.Task.run("app.start")

    {opts, _args, _invalid} =
      OptionParser.parse(rest,
        switches: [current_url: :string, previous_url: :string, include: :string],
        aliases: [i: :include]
      )

    cycles_back = String.to_integer(cycles_back)
    include = parse_include(Keyword.get(opts, :include))

    urls = fetch_download_urls()
    today = Date.utc_today()
    current_code = Utils.get_airac_cycle_for_date(today)
    previous_code = Utils.get_airac_cycle_for_date(Date.add(today, -28 * cycles_back))

    current_url =
      Keyword.get(opts, :current_url) ||
        find_url!(urls, current_code, :current)

    previous_url =
      Keyword.get(opts, :previous_url) ||
        find_url!(urls, previous_code, :previous)

    Mix.shell().info("Current (#{current_code}): #{current_url}")
    Mix.shell().info("Previous (#{previous_code}): #{previous_url}")

    current_headers = load_headers(current_url, include)
    previous_headers = load_headers(previous_url, include)

    all_files =
      Map.keys(current_headers)
      |> Enum.concat(Map.keys(previous_headers))
      |> Enum.uniq()
      |> Enum.sort()

    diffs = Enum.map(all_files, &diff_file(&1, current_headers, previous_headers))
    print_diffs(diffs)

    if Enum.any?(diffs, fn %{added: a, removed: r} -> a != [] or r != [] end) do
      Mix.raise("Schema differences detected")
    else
      Mix.shell().info("No schema differences detected")
    end
  end

  def run(_args) do
    Mix.raise("Usage: mix nasr.schema_diff <cycles_back>")
  end

  defp parse_include(nil), do: :all

  defp parse_include(csvs) do
    csvs
    |> String.split(",", trim: true)
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
    |> case do
      [] -> :all
      list -> MapSet.new(list)
    end
  end

  defp fetch_download_urls do
    {:ok, resp} = Req.get(@base_url)
    {:ok, doc} = Floki.parse_document(resp.body)

    doc
    |> Floki.find("a[href*='NASR_Subscription/']")
    |> Enum.map(&Floki.attribute(&1, "href") |> List.first())
    |> Enum.map(&URI.merge(@base_url, &1) |> URI.to_string())
    |> Enum.map(&normalize_date_link/1)
    |> Enum.reject(&is_nil/1)
    |> Enum.map(&fetch_download_for_date/1)
    |> Enum.reject(&is_nil/1)
  end

  defp normalize_date_link(url) do
    case Regex.run(~r/NASR_Subscription\/(\d{4}-\d{2}-\d{2})\/?$/, url) do
      [_, date_str] ->
        {:ok, date} = Date.from_iso8601(date_str)
        {url, date}

      _ ->
        nil
    end
  end

  defp fetch_download_for_date({url, date}) do
    case Req.get(url) do
      {:ok, resp} ->
        {:ok, doc} = Floki.parse_document(resp.body)

        doc
        |> Floki.find("a[href$='.zip']")
        |> Enum.map(&Floki.attribute(&1, "href") |> List.first())
        |> Enum.map(&URI.merge(url, &1) |> URI.to_string())
        |> Enum.find(fn href -> String.contains?(href, "28DaySubscription_Effective") end)
        |> case do
          nil -> nil
          href -> {href, date}
        end

      _ ->
        nil
    end
  end

  defp find_url!(urls_with_dates, code, label) do
    {:ok, start_date} = Utils.get_airac_start_date(code)

    urls_with_dates
    |> Enum.find_value(fn
      {url, ^start_date} -> url
      _ -> nil
    end)
    |> case do
      nil ->
        fallback =
          "https://nfdc.faa.gov/webContent/28DaySub/28DaySubscription_Effective_#{Date.to_iso8601(start_date)}.zip"

        Mix.shell().info("[INFO] Falling back to #{fallback} for #{label} cycle #{code}")
        fallback

      url ->
        url
    end
  end

  defp load_headers(url, include) do
    path = Utils.download(url)
    {:ok, zip} = path |> Unzip.LocalFile.open() |> Unzip.new()
    {:ok, csv_zip} = open_csv_zip(zip)

    csv_zip
    |> list_csv_files(include)
    |> Map.new(fn file ->
      {file, read_headers(csv_zip, file) |> MapSet.new()}
    end)
  end

  defp open_csv_zip(stream) do
    csv_file_in_zip =
      stream
      |> Unzip.list_entries()
      |> Enum.find(&(String.starts_with?(&1.file_name, "CSV_Data") && String.ends_with?(&1.file_name, ".zip")))
      |> case do
        nil -> Mix.raise("No CSV_Data zip file found in NASR zip file")
        file -> file.file_name
      end

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

  defp list_csv_files(csv_zip, include) do
    csv_zip
    |> Unzip.list_entries()
    |> Enum.map(& &1.file_name)
    |> Enum.filter(&String.ends_with?(&1, ".csv"))
    |> Enum.reject(&String.ends_with?(&1, "DATA_STRUCTURE.csv"))
    |> maybe_filter(include)
  end

  defp maybe_filter(files, :all), do: files

  defp maybe_filter(files, %MapSet{} = include) do
    Enum.filter(files, fn file ->
      type = String.replace(file, ".csv", "")
      MapSet.member?(include, type)
    end)
  end

  defp read_headers(csv_zip, file) do
    csv_zip
    |> Unzip.file_stream!(file)
    |> Stream.map(&IO.iodata_to_binary/1)
    |> RFC4180.to_line_stream()
    |> RFC4180.parse_stream(skip_headers: false)
    |> Enum.take(1)
    |> List.first()
    |> Enum.map(&normalize_header/1)
  end

  defp normalize_header(header) do
    header
    |> String.replace(~r/[^\x20-\x7E]/, "")
    |> String.trim()
  end

  defp diff_file(file, current, previous) do
    curr_headers = Map.get(current, file, MapSet.new())
    prev_headers = Map.get(previous, file, MapSet.new())

    %{
      file: file,
      added: MapSet.difference(curr_headers, prev_headers) |> Enum.sort(),
      removed: MapSet.difference(prev_headers, curr_headers) |> Enum.sort()
    }
  end

  defp print_diffs(diffs) do
    Enum.each(diffs, fn
      %{file: file, added: [], removed: []} ->
        Mix.shell().info("[OK] #{file}")

      %{file: file, added: added, removed: removed} ->
        Mix.shell().error("[DIFF] #{file}")

        if added != [] do
          Mix.shell().error("  Added columns: #{Enum.join(added, ", ")}")
        end

        if removed != [] do
          Mix.shell().error("  Removed columns: #{Enum.join(removed, ", ")}")
        end
    end)
  end
end
