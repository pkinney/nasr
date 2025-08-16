defmodule NASR.Entities.Radar do
  @moduledoc """
  Represents Radar Information from the NASR RDR data.

  This entity contains information about radar facilities and their operational characteristics
  within the National Airspace System, including airport surveillance radar (ASR),
  precision approach radar (PAR), and air route surveillance radar (ARSR).

  ## Fields

  * `:facility_id` - Facility identifier (airport or TRACON identifier)
  * `:facility_type` - Type of facility (Airport or TRACON)
  * `:state_code` - State abbreviation where the radar is located
  * `:country_code` - Country code (typically "US")
  * `:radar_type` - Type of radar system
  * `:radar_number` - Radar number at the facility (for multiple radars)
  * `:radar_hours` - Operating hours of the radar
  * `:remark` - Additional remarks about the radar system
  * `:effective_date` - The 28 Day NASR Subscription Effective Date

  ## Radar Types

  * `:asr` - Airport Surveillance Radar (ASR) - primary radar for terminal approach control
  * `:par` - Precision Approach Radar (PAR) - provides precision guidance for approaches
  * `:arsr` - Air Route Surveillance Radar (ARSR) - long-range radar for en route control
  * `:bcn` - Beacon - radar beacon system

  ## Facility Types

  * `:airport` - Airport-based radar
  * `:tracon` - Terminal Radar Approach Control facility

  ## Operating Hours

  The radar_hours field typically contains:
  * "24" for 24-hour operation
  * Time ranges like "0600-2300" for specific operating hours
  * Special schedules like "WKDAYS; EXCP HOLS" for weekdays except holidays

  ## Data Source

  This data comes from the FAA's National Airspace System Resources (NASR) subscription,
  specifically from the RDR.csv file. The data is updated on a 28-day cycle.
  """
  import NASR.Utils

  defstruct ~w(
    facility_id
    facility_type
    state_code
    country_code
    radar_type
    radar_number
    radar_hours
    remark
    effective_date
  )a

  @type t() :: %__MODULE__{
          facility_id: String.t(),
          facility_type: :airport | :tracon | String.t() | nil,
          state_code: String.t(),
          country_code: String.t(),
          radar_type: :asr | :par | :arsr | :bcn | String.t() | nil,
          radar_number: integer() | nil,
          radar_hours: String.t(),
          remark: String.t(),
          effective_date: Date.t() | nil
        }

  @spec type() :: String.t()
  def type, do: "RDR"

  @spec new(map()) :: t()
  def new(entity) do
    %__MODULE__{
      facility_id: Map.fetch!(entity, "FACILITY_ID"),
      facility_type: parse_facility_type(Map.fetch!(entity, "FACILITY_TYPE")),
      state_code: Map.fetch!(entity, "STATE_CODE"),
      country_code: Map.fetch!(entity, "COUNTRY_CODE"),
      radar_type: parse_radar_type(Map.fetch!(entity, "RADAR_TYPE")),
      radar_number: safe_str_to_int(Map.fetch!(entity, "RADAR_NO")),
      radar_hours: Map.fetch!(entity, "RADAR_HRS"),
      remark: Map.fetch!(entity, "REMARK"),
      effective_date: parse_date(Map.fetch!(entity, "EFF_DATE"))
    }
  end

  defp parse_facility_type(nil), do: nil
  defp parse_facility_type(""), do: nil

  defp parse_facility_type(type) when is_binary(type) do
    type
    |> String.trim()
    |> String.upcase()
    |> case do
      "AIRPORT" -> :airport
      "TRACON" -> :tracon
      other -> other
    end
  end

  defp parse_radar_type(nil), do: nil
  defp parse_radar_type(""), do: nil

  defp parse_radar_type(type) when is_binary(type) do
    type
    |> String.trim()
    |> String.upcase()
    |> case do
      "ASR" -> :asr
      "PAR" -> :par
      "ARSR" -> :arsr
      "BCN" -> :bcn
      other -> other
    end
  end
end