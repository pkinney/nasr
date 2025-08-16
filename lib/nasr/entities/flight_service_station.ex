defmodule NASR.Entities.FlightServiceStation do
  @moduledoc """
  Represents Flight Service Station data from the NASR FSS_BASE data.

  This entity contains information about Flight Service Stations (FSS), which provide
  aviation support services including weather briefings, flight plan filing and closing,
  radio communication relay, emergency assistance, and pilot weather information.
  Flight Service Stations are critical for general aviation safety and operations.

  ## Fields

  * `:effective_date` - The 28 Day NASR Subscription Effective Date in format 'YYYY/MM/DD'
  * `:fss_id` - Flight Service Station Identifier. Unique 3-4 character alphanumeric identifier
  * `:name` - Flight Service Station Name
  * `:update_date` - Last update date for this FSS record
  * `:facility_type` - FSS Facility Type. Values: `:radio`, `:fss`, `:hub`
  * `:voice_call` - Voice Call Sign for radio communications
  * `:city` - Associated City Name where FSS is located
  * `:state_code` - Associated State Code standard two letter abbreviation for US States and Territories
  * `:country_code` - Country Code where FSS is located
  * `:latitude_degrees` - Latitude degrees (0-90)
  * `:latitude_minutes` - Latitude minutes (0-59)
  * `:latitude_seconds` - Latitude seconds (0-59.999)
  * `:latitude_hemisphere` - Latitude hemisphere (N/S)
  * `:latitude` - FSS Latitude in Decimal Format
  * `:longitude_degrees` - Longitude degrees (0-180)
  * `:longitude_minutes` - Longitude minutes (0-59)
  * `:longitude_seconds` - Longitude seconds (0-59.999)
  * `:longitude_hemisphere` - Longitude hemisphere (E/W)
  * `:longitude` - FSS Longitude in Decimal Format
  * `:operating_hours` - Operating hours description or "24" for 24-hour operation
  * `:facility_status` - Facility operational status. Values: `:active`, `:inactive`
  * `:alternate_fss` - Alternate FSS identifier for after-hours service
  * `:weather_radar_flag` - Weather radar availability (boolean: true for Y, false for N)
  * `:phone_number` - FSS contact telephone number
  * `:toll_free_number` - Toll-free telephone number (typically 1-800-WX-BRIEF)
  """
  import NASR.Utils

  defstruct ~w(
    effective_date
    fss_id
    name
    update_date
    facility_type
    voice_call
    city
    state_code
    country_code
    latitude_degrees
    latitude_minutes
    latitude_seconds
    latitude_hemisphere
    latitude
    longitude_degrees
    longitude_minutes
    longitude_seconds
    longitude_hemisphere
    longitude
    operating_hours
    facility_status
    alternate_fss
    weather_radar_flag
    phone_number
    toll_free_number
  )a

  @type t() :: %__MODULE__{
          effective_date: Date.t() | nil,
          fss_id: String.t(),
          name: String.t(),
          update_date: Date.t() | nil,
          facility_type: :radio | :fss | :hub | String.t() | nil,
          voice_call: String.t(),
          city: String.t(),
          state_code: String.t(),
          country_code: String.t(),
          latitude_degrees: integer() | nil,
          latitude_minutes: integer() | nil,
          latitude_seconds: float() | nil,
          latitude_hemisphere: String.t(),
          latitude: float() | nil,
          longitude_degrees: integer() | nil,
          longitude_minutes: integer() | nil,
          longitude_seconds: float() | nil,
          longitude_hemisphere: String.t(),
          longitude: float() | nil,
          operating_hours: String.t(),
          facility_status: :active | :inactive | String.t() | nil,
          alternate_fss: String.t(),
          weather_radar_flag: boolean() | nil,
          phone_number: String.t(),
          toll_free_number: String.t()
        }

  @spec type() :: String.t()
  def type(), do: "FSS_BASE"

  @spec new(map()) :: t()
  def new(entity) do
    %__MODULE__{
      effective_date: parse_date(Map.fetch!(entity, "EFF_DATE")),
      fss_id: Map.fetch!(entity, "FSS_ID"),
      name: Map.fetch!(entity, "NAME"),
      update_date: parse_date(Map.fetch!(entity, "UPDATE_DATE")),
      facility_type: parse_facility_type(Map.fetch!(entity, "FSS_FAC_TYPE")),
      voice_call: Map.fetch!(entity, "VOICE_CALL"),
      city: Map.fetch!(entity, "CITY"),
      state_code: Map.fetch!(entity, "STATE_CODE"),
      country_code: Map.fetch!(entity, "COUNTRY_CODE"),
      latitude_degrees: safe_str_to_int(Map.fetch!(entity, "LAT_DEG")),
      latitude_minutes: safe_str_to_int(Map.fetch!(entity, "LAT_MIN")),
      latitude_seconds: safe_str_to_float(Map.fetch!(entity, "LAT_SEC")),
      latitude_hemisphere: Map.fetch!(entity, "LAT_HEMIS"),
      latitude: safe_str_to_float(Map.fetch!(entity, "LAT_DECIMAL")),
      longitude_degrees: safe_str_to_int(Map.fetch!(entity, "LONG_DEG")),
      longitude_minutes: safe_str_to_int(Map.fetch!(entity, "LONG_MIN")),
      longitude_seconds: safe_str_to_float(Map.fetch!(entity, "LONG_SEC")),
      longitude_hemisphere: Map.fetch!(entity, "LONG_HEMIS"),
      longitude: safe_str_to_float(Map.fetch!(entity, "LONG_DECIMAL")),
      operating_hours: Map.fetch!(entity, "OPR_HOURS"),
      facility_status: parse_facility_status(Map.fetch!(entity, "FAC_STATUS")),
      alternate_fss: Map.fetch!(entity, "ALTERNATE_FSS"),
      weather_radar_flag: convert_yn(Map.fetch!(entity, "WEA_RADAR_FLAG")),
      phone_number: Map.fetch!(entity, "PHONE_NO"),
      toll_free_number: Map.fetch!(entity, "TOLL_FREE_NO")
    }
  end

  defp parse_facility_type(nil), do: nil
  defp parse_facility_type(""), do: nil
  defp parse_facility_type(type) when is_binary(type) do
    case String.trim(String.upcase(type)) do
      "RADIO" -> :radio
      "FSS" -> :fss
      "HUB" -> :hub
      other -> other
    end
  end

  defp parse_facility_status(nil), do: nil
  defp parse_facility_status(""), do: nil
  defp parse_facility_status(status) when is_binary(status) do
    case String.trim(String.upcase(status)) do
      "A" -> :active
      "I" -> :inactive
      other -> other
    end
  end
end