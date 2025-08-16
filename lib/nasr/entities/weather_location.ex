defmodule NASR.Entities.WeatherLocation do
  @moduledoc """
  Represents Weather Reporting Location data from the NASR WXL_BASE data.

  This entity contains information about Weather Reporting Locations which provide
  weather observations, pilot reports, and meteorological data for aviation operations.
  These locations include airports, weather stations, and other observation points
  that contribute to aviation weather services and pilot weather briefings.

  ## Fields

  * `:effective_date` - The 28 Day NASR Subscription Effective Date in format 'YYYY/MM/DD'
  * `:weather_id` - Weather Location Identifier. Unique 3-4 character alphanumeric identifier
  * `:city` - Associated City Name where weather location is situated
  * `:state_code` - Associated State Code standard two letter abbreviation for US States and Territories
  * `:country_code` - Country Code where weather location is situated
  * `:latitude_degrees` - Latitude degrees (0-90)
  * `:latitude_minutes` - Latitude minutes (0-59)
  * `:latitude_seconds` - Latitude seconds (0-59.999)
  * `:latitude_hemisphere` - Latitude hemisphere (N/S)
  * `:latitude` - Weather Location Latitude in Decimal Format
  * `:longitude_degrees` - Longitude degrees (0-180)
  * `:longitude_minutes` - Longitude minutes (0-59)
  * `:longitude_seconds` - Longitude seconds (0-59.999)
  * `:longitude_hemisphere` - Longitude hemisphere (E/W)
  * `:longitude` - Weather Location Longitude in Decimal Format
  * `:elevation` - Weather Location Elevation in Feet Above Mean Sea Level
  * `:survey_method_code` - Weather Location Position Determination Method. Values: `:estimated`, `:surveyed`
  """
  import NASR.Utils

  defstruct ~w(
    effective_date
    weather_id
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
    elevation
    survey_method_code
  )a

  @type t() :: %__MODULE__{
          effective_date: Date.t() | nil,
          weather_id: String.t(),
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
          elevation: integer() | nil,
          survey_method_code: :estimated | :surveyed | String.t() | nil
        }

  @spec type() :: String.t()
  def type(), do: "WXL_BASE"

  @spec new(map()) :: t()
  def new(entity) do
    %__MODULE__{
      effective_date: parse_date(Map.fetch!(entity, "EFF_DATE")),
      weather_id: Map.fetch!(entity, "WEA_ID"),
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
      elevation: safe_str_to_int(Map.fetch!(entity, "ELEV")),
      survey_method_code: parse_survey_method_code(Map.fetch!(entity, "SURVEY_METHOD_CODE"))
    }
  end

  defp parse_survey_method_code(nil), do: nil
  defp parse_survey_method_code(""), do: nil
  defp parse_survey_method_code(code) when is_binary(code) do
    case String.trim(code) do
      "E" -> :estimated
      "S" -> :surveyed
      other -> other
    end
  end
end