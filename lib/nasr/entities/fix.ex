defmodule NASR.Entities.Fix do
  @moduledoc """
  Represents Airspace Fixes (FIX) information from the NASR FIX_BASE data.

  A Fix is a Fixed Geographical Position Identifier used for navigation and air traffic control.
  Fixes are reference points in the National Airspace System used for routing, reporting,
  and navigation purposes. The FIX_BASE file was designed to replace the legacy FIX.txt
  Subscriber File.

  ## Fields

  * `:fix_id` - Fixed Geographical Position Identifier
  * `:fix_id_old` - Previous Name(s) of the Fix before It was Renamed
  * `:latitude` - FIX Latitude in Decimal Format
  * `:longitude` - FIX Longitude in Decimal Format
  * `:state_code` - Associated State Post Office Code standard two letter abbreviation for US States and Territories
  * `:country_code` - Country Post Office Code
  * `:icao_region_code` - International Civil Aviation Organization (ICAO) Code. In General, the First Letter of an ICAO Code refers to the Country. The Second Letter discerns the Region within the Country
  * `:fix_use_code` - FIX Type. Values: `:computer_navigation_fix`, `:military_reporting_point`, `:military_waypoint`, `:nrs_waypoint`, `:radar`, `:reporting_point`, `:vfr_waypoint`, `:waypoint`
  * `:artcc_id_high` - Denotes High ARTCC Area Of Jurisdiction
  * `:artcc_id_low` - Denotes Low ARTCC Area Of Jurisdiction
  * `:charting_remark` - Charting Information
  * `:pitch_flag` - Pitch (boolean: true for Y, false for N)
  * `:catch_flag` - Catch (boolean: true for Y, false for N)
  * `:sua_atcaa_flag` - SUA/ATCAA (boolean: true for Y, false for N)
  * `:min_recep_alt` - Fix Minimum Reception Altitude (MRA) in feet
  * `:compulsory` - Compulsory FIX identified as HIGH or LOW or LOW/HIGH. Null in this field identifies Non-Compulsory FIX. Values: `:high`, `:low`, `:low_high`, `nil`
  * `:charts` - Concatenated list of the information found in the FIX_CHRT file separated by a comma (list of chart names)
  * `:effective_date` - The 28 Day NASR Subscription Effective Date in format 'YYYY/MM/DD'
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
    effective_date
  )a

  @type t() :: %__MODULE__{
          fix_id: String.t(),
          fix_id_old: String.t(),
          latitude: float() | nil,
          longitude: float() | nil,
          state_code: String.t(),
          country_code: String.t(),
          icao_region_code: String.t(),
          fix_use_code: :computer_navigation_fix | :military_reporting_point | :military_waypoint | :nrs_waypoint | :radar | :reporting_point | :vfr_waypoint | :waypoint | String.t() | nil,
          artcc_id_high: String.t(),
          artcc_id_low: String.t(),
          charting_remark: String.t(),
          pitch_flag: boolean() | nil,
          catch_flag: boolean() | nil,
          sua_atcaa_flag: boolean() | nil,
          min_recep_alt: integer() | nil,
          compulsory: :high | :low | :low_high | nil,
          charts: [String.t()],
          effective_date: Date.t() | nil
        }

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
      effective_date: parse_date(Map.fetch!(entity, "EFF_DATE"))
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
