defmodule NASR.Utils do
  @moduledoc false
  import SweetXml

  require Logger

  def list_files(dir) do
    dir
    |> File.ls!()
    |> Enum.filter(fn file -> String.ends_with?(file, ".zip") end)
    |> Enum.map(fn file -> Path.join(dir, file) end)
  end

  def download(url) do
    Logger.info("[#{__MODULE__}] Downloading #{url}")

    {:ok, file} = Briefly.create()
    Req.get!(url, into: File.stream!(file))
    Logger.info("[#{__MODULE__}] Download complete")
    file
  end

  def safe_str_to_int(""), do: nil

  def safe_str_to_int(str) do
    cond do
      String.match?(str, ~r/^\-?\d+$/) -> String.to_integer(str)
      String.match?(str, ~r/^\-?\d+\.\d+$/) -> str |> String.to_float() |> trunc()
      true -> nil
    end
  end

  def safe_str_to_float(""), do: nil

  def safe_str_to_float(str) do
    cond do
      String.match?(str, ~r/^\-?\d+$/) -> String.to_float(str)
      String.match?(str, ~r/^\-?\d+\.\d+$/) -> String.to_float(str)
      true -> nil
    end
  end

  def convert_seconds_to_decimal(seconds) do
    {seconds, dir} = Float.parse(seconds)
    deg = seconds / 3600.0

    case dir do
      "N" -> deg
      "S" -> -deg
      "E" -> deg
      "W" -> -deg
    end
  end

  def convert_dms_to_decimal(""), do: nil

  def convert_dms_to_decimal(str) do
    [deg, min, sec] = String.split(str, "-")
    deg = safe_str_to_int(deg)
    min = safe_str_to_int(min)

    {sec, dir} = Float.parse(sec)

    deg = deg + min / 60.0 + sec / 3600.0

    case dir do
      "N" -> deg
      "S" -> -deg
      "E" -> deg
      "W" -> -deg
    end
  end

  def convert_yn("Y"), do: true
  def convert_yn("N"), do: false
  def convert_yn(_), do: nil

  def get_current_nasr_url do
    url = "https://www.faa.gov/air_traffic/flight_info/aeronav/aero_data/NASR_Subscription/"

    {:ok, resp} = Req.get(url)
    {:ok, doc} = Floki.parse_document(resp.body)

    path =
      doc
      |> Floki.find("article#content")
      |> Floki.raw_html()
      |> SweetXml.xpath(~x"//*[text()='Current']/following::ul[1]/li/a/@href"s)

    page_url = url |> URI.merge(path) |> URI.to_string()
    {:ok, resp} = Req.get(page_url)
    {:ok, doc} = Floki.parse_document(resp.body)

    doc
    |> Floki.find("article#content")
    |> Floki.raw_html()
    |> SweetXml.xpath(~x"//a[text()='Download']/@href"l)
    |> List.first()
    |> to_string()
  end

  @doc """
  Converts a Date to a 4-digit AIRAC code.

  AIRAC codes are formatted as YYNN where:
  - YY is the last two digits of the year
  - NN is the cycle number within that year (01-13, occasionally 14)

  Each AIRAC cycle is 28 days long. The reference date used is
  January 2, 2020 (AIRAC cycle 2001).

  ## Examples

      iex> Airports.Tasks.date_to_airac(~D[2025-07-10])
      "2507"

      iex> Airports.Tasks.date_to_airac(~D[2025-01-23])
      "2501"

      iex> Airports.Tasks.date_to_airac(~D[2024-12-26])
      "2413"
  """
  @spec get_airac_cycle_for_date(Date.t() | nil) :: String.t()
  def get_airac_cycle_for_date(date \\ nil)
  def get_airac_cycle_for_date(nil), do: get_airac_cycle_for_date(Date.utc_today())

  def get_airac_cycle_for_date(%Date{} = date) do
    # Reference date: January 2, 2020 was the start of AIRAC cycle 2001
    reference_date = ~D[2020-01-02]

    # Get the year from the date
    # We need to be precise about year boundaries since cycles don't align with calendar years
    year = date.year

    # Find the first AIRAC date of the given year
    # We need to find when cycle 1 starts for the given year
    jan_1 = Date.new!(year, 1, 1)

    # Find how many days from reference to Jan 1 of target year
    days_to_jan_1 = Date.diff(jan_1, reference_date)

    # Find the first cycle that starts in or after Jan 1
    cycles_to_jan_1 = div(days_to_jan_1, 28)

    # The first AIRAC date of the year
    first_airac_of_year = Date.add(reference_date, cycles_to_jan_1 * 28)

    # If the first AIRAC is before Jan 1, move to the next cycle
    first_airac_of_year =
      if Date.before?(first_airac_of_year, jan_1) do
        Date.add(first_airac_of_year, 28)
      else
        first_airac_of_year
      end

    # Now calculate the cycle number within the year
    if Date.before?(date, first_airac_of_year) do
      # Date is before the first AIRAC of its year, so it belongs to previous year
      prev_year = year - 1

      # Find which cycle of the previous year this date falls in
      # We'll count backwards from the first AIRAC of current year
      {cycle_num, _} = find_previous_year_cycle(date, first_airac_of_year, 13)

      # Format as YYNN
      year_str = prev_year |> rem(100) |> to_string() |> String.pad_leading(2, "0")
      cycle_str = cycle_num |> to_string() |> String.pad_leading(2, "0")
      year_str <> cycle_str
    else
      # Count forward from first AIRAC of the year
      days_since_first = Date.diff(date, first_airac_of_year)
      cycle_num = div(days_since_first, 28) + 1

      # Format as YYNN
      year_str = year |> rem(100) |> to_string() |> String.pad_leading(2, "0")
      cycle_str = cycle_num |> to_string() |> String.pad_leading(2, "0")
      year_str <> cycle_str
    end
  end

  # Helper function to find the cycle number when date is in previous year
  defp find_previous_year_cycle(date, current_airac, cycle_num) when cycle_num > 0 do
    prev_airac = Date.add(current_airac, -28)

    if Date.before?(date, prev_airac) do
      find_previous_year_cycle(date, prev_airac, cycle_num - 1)
    else
      {cycle_num, current_airac}
    end
  end

  defp find_previous_year_cycle(_date, current_airac, cycle_num) do
    {cycle_num, current_airac}
  end
end
