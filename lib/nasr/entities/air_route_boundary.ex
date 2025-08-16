defmodule NASR.Entities.AirRouteBoundary do
  @moduledoc """
  Represents Air Route Traffic Control Center (ARTCC) information from the NASR ARB_BASE data.

  Air Route Traffic Control Centers are responsible for controlling aircraft
  operating on instrument flight rules (IFR) flight plans within controlled
  airspace, primarily during the en route phase of flight. Each ARTCC has
  defined boundaries that separate their areas of responsibility.

  ## ARTCC Types

  * **ARTCC** - Air Route Traffic Control Center (domestic)
  * **Oceanic** - Oceanic Air Route Traffic Control Center
  * **FIR** - Flight Information Region (international)

  ## Fields

  * `:effective_date` - The 28 Day NASR Subscription Effective Date in format 'YYYY/MM/DD'
  * `:location_id` - Unique identifier for the ARTCC facility
  * `:location_name` - Full name of the ARTCC facility
  * `:computer_id` - Computer system identifier
  * `:icao_id` - ICAO identifier for the facility
  * `:location_type` - Type of air traffic control facility (:artcc, :oceanic, :fir)
  * `:city` - City where the facility is located
  * `:state` - State where the facility is located
  * `:country_code` - Country code where the facility is located
  * `:latitude_degrees` - Latitude degrees component
  * `:latitude_minutes` - Latitude minutes component
  * `:latitude_seconds` - Latitude seconds component
  * `:latitude_hemisphere` - Latitude hemisphere ('N' or 'S')
  * `:latitude_decimal` - Latitude in decimal degrees
  * `:longitude_degrees` - Longitude degrees component
  * `:longitude_minutes` - Longitude minutes component
  * `:longitude_seconds` - Longitude seconds component
  * `:longitude_hemisphere` - Longitude hemisphere ('E' or 'W')
  * `:longitude_decimal` - Longitude in decimal degrees
  * `:cross_reference` - Cross-reference information
  """
  import NASR.Utils

  defstruct ~w(
    effective_date
    location_id
    location_name
    computer_id
    icao_id
    location_type
    city
    state
    country_code
    latitude_degrees
    latitude_minutes
    latitude_seconds
    latitude_hemisphere
    latitude_decimal
    longitude_degrees
    longitude_minutes
    longitude_seconds
    longitude_hemisphere
    longitude_decimal
    cross_reference
  )a

  @type t() :: %__MODULE__{
          effective_date: Date.t() | nil,
          location_id: String.t(),
          location_name: String.t(),
          computer_id: String.t(),
          icao_id: String.t(),
          location_type: :artcc | String.t() | nil,
          city: String.t(),
          state: String.t(),
          country_code: String.t(),
          latitude_degrees: integer() | nil,
          latitude_minutes: integer() | nil,
          latitude_seconds: float() | nil,
          latitude_hemisphere: String.t(),
          latitude_decimal: float() | nil,
          longitude_degrees: integer() | nil,
          longitude_minutes: integer() | nil,
          longitude_seconds: float() | nil,
          longitude_hemisphere: String.t(),
          longitude_decimal: float() | nil,
          cross_reference: String.t()
        }

  @spec type() :: String.t()
  def type, do: "ARB_BASE"

  @spec new(map()) :: t()
  def new(entity) do
    %__MODULE__{
      effective_date: parse_date(Map.fetch!(entity, "EFF_DATE")),
      location_id: Map.fetch!(entity, "LOCATION_ID"),
      location_name: Map.fetch!(entity, "LOCATION_NAME"),
      computer_id: Map.fetch!(entity, "COMPUTER_ID"),
      icao_id: Map.fetch!(entity, "ICAO_ID"),
      location_type: parse_location_type(Map.fetch!(entity, "LOCATION_TYPE")),
      city: Map.fetch!(entity, "CITY"),
      state: Map.fetch!(entity, "STATE"),
      country_code: Map.fetch!(entity, "COUNTRY_CODE"),
      latitude_degrees: safe_str_to_int(Map.fetch!(entity, "LAT_DEG")),
      latitude_minutes: safe_str_to_int(Map.fetch!(entity, "LAT_MIN")),
      latitude_seconds: safe_str_to_float(Map.fetch!(entity, "LAT_SEC")),
      latitude_hemisphere: Map.fetch!(entity, "LAT_HEMIS"),
      latitude_decimal: safe_str_to_float(Map.fetch!(entity, "LAT_DECIMAL")),
      longitude_degrees: safe_str_to_int(Map.fetch!(entity, "LONG_DEG")),
      longitude_minutes: safe_str_to_int(Map.fetch!(entity, "LONG_MIN")),
      longitude_seconds: safe_str_to_float(Map.fetch!(entity, "LONG_SEC")),
      longitude_hemisphere: Map.fetch!(entity, "LONG_HEMIS"),
      longitude_decimal: safe_str_to_float(Map.fetch!(entity, "LONG_DECIMAL")),
      cross_reference: Map.fetch!(entity, "CROSS_REF")
    }
  end

  defp parse_location_type(nil), do: nil
  defp parse_location_type(""), do: nil
  defp parse_location_type(type) when is_binary(type) do
    case String.trim(type) do
      "ARTCC" -> :artcc
      other -> other
    end
  end
end