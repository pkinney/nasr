defmodule NASR.Entities.Fix do
  @moduledoc """
  Represents an Airspace Fix (FIX) from the NASR FIX_BASE data.

  A Fix is a geographical position identifier used for navigation and air traffic control.
  Fixes are reference points in the National Airspace System used for routing, reporting,
  and navigation purposes.

  ## Fields

  * `:fix_id` - Fixed Geographical Position Identifier (5 characters)
  * `:fix_id_old` - Previous name(s) of the Fix before it was renamed
  * `:latitude` - Fix latitude in decimal format
  * `:longitude` - Fix longitude in decimal format
  * `:state_code` - Associated State Post Office Code (standard two letter abbreviation)
  * `:country_code` - Country Post Office Code
  * `:icao_region_code` - ICAO Code where first letter refers to country, second discerns region
  * `:fix_use_code` - Fix type, one of:
    * `:computer_navigation_fix` - Computer Navigation Fix (CN)
    * `:military_reporting_point` - Military Reporting Point (MR)
    * `:military_waypoint` - Military Waypoint (MW)
    * `:nrs_waypoint` - NRS Waypoint (NRS)
    * `:radar` - Radar (RADAR)
    * `:reporting_point` - Reporting Point (RP)
    * `:vfr_waypoint` - VFR Waypoint (VFR)
    * `:waypoint` - Waypoint (WP)
  * `:artcc_id_high` - Denotes High ARTCC Area Of Jurisdiction
  * `:artcc_id_low` - Denotes Low ARTCC Area Of Jurisdiction
  * `:charting_remark` - Charting information (e.g., "RNAV")
  * `:pitch_flag` - Pitch flag (boolean: true for Y, false for N)
  * `:catch_flag` - Catch flag (boolean: true for Y, false for N)
  * `:sua_atcaa_flag` - SUA/ATCAA flag (boolean: true for Y, false for N)
  * `:min_recep_alt` - Fix Minimum Reception Altitude (MRA) in feet
  * `:compulsory` - Compulsory fix classification:
    * `:high` - High altitude compulsory
    * `:low` - Low altitude compulsory
    * `:low_high` - Both low and high altitude compulsory
    * `nil` - Non-compulsory fix
  * `:charts` - List of charts on which fix is depicted (e.g., ["CONTROLLER LOW", "ENROUTE LOW", "IAP", "STAR"])
  * `:eff_date` - The 28 Day NASR Subscription Effective Date

  ## Data Source

  This data comes from the FAA's National Airspace System Resources (NASR) subscription,
  specifically from the FIX_BASE.csv file. The data is updated on a 28-day cycle.
  """
  import NASR.Utils

  defstruct ~w(
    fix_id
    fix_id_old
    latitude
    longitude
    state_code
    country_code
    icao_region_code
    fix_use_code
    artcc_id_high
    artcc_id_low
    charting_remark
    pitch_flag
    catch_flag
    sua_atcaa_flag
    min_recep_alt
    compulsory
    charts
    eff_date
  )a

  @type t() :: %__MODULE__{}

  @spec type() :: String.t()
  def type, do: "FIX_BASE"

  @spec new(map()) :: t()
  def new(entity) do
    %__MODULE__{
      fix_id: Map.fetch!(entity, "FIX_ID"),
      fix_id_old: Map.fetch!(entity, "FIX_ID_OLD"),
      latitude: safe_str_to_float(Map.fetch!(entity, "LAT_DECIMAL")),
      longitude: safe_str_to_float(Map.fetch!(entity, "LONG_DECIMAL")),
      state_code: Map.fetch!(entity, "STATE_CODE"),
      country_code: Map.fetch!(entity, "COUNTRY_CODE"),
      icao_region_code: Map.fetch!(entity, "ICAO_REGION_CODE"),
      fix_use_code: parse_fix_use_code(Map.fetch!(entity, "FIX_USE_CODE")),
      artcc_id_high: Map.fetch!(entity, "ARTCC_ID_HIGH"),
      artcc_id_low: Map.fetch!(entity, "ARTCC_ID_LOW"),
      charting_remark: Map.fetch!(entity, "CHARTING_REMARK"),
      pitch_flag: convert_yn(Map.fetch!(entity, "PITCH_FLAG")),
      catch_flag: convert_yn(Map.fetch!(entity, "CATCH_FLAG")),
      sua_atcaa_flag: convert_yn(Map.fetch!(entity, "SUA_ATCAA_FLAG")),
      min_recep_alt: safe_str_to_int(Map.fetch!(entity, "MIN_RECEP_ALT")),
      compulsory: parse_compulsory(Map.fetch!(entity, "COMPULSORY")),
      charts: parse_charts(Map.fetch!(entity, "CHARTS")),
      eff_date: parse_date(Map.fetch!(entity, "EFF_DATE"))
    }
  end

  defp parse_fix_use_code(nil), do: nil
  defp parse_fix_use_code(""), do: nil

  defp parse_fix_use_code(code) when is_binary(code) do
    code
    |> String.trim()
    |> case do
      "CN" -> :computer_navigation_fix
      "MR" -> :military_reporting_point
      "MW" -> :military_waypoint
      "NRS" -> :nrs_waypoint
      "RADAR" -> :radar
      "RP" -> :reporting_point
      "VFR" -> :vfr_waypoint
      "WP" -> :waypoint
      other -> other
    end
  end

  defp parse_compulsory(nil), do: nil
  defp parse_compulsory(""), do: nil

  defp parse_compulsory(value) when is_binary(value) do
    value
    |> String.trim()
    |> String.downcase()
    |> case do
      "high" -> :high
      "low" -> :low
      "low/high" -> :low_high
      _ -> nil
    end
  end

  defp parse_charts(nil), do: []
  defp parse_charts(""), do: []

  defp parse_charts(charts) when is_binary(charts) do
    charts
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
  end
end
