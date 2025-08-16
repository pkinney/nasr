defmodule NASR.Entities.ILS.Marker do
  @moduledoc """
  Represents ILS Marker Beacon information from the NASR ILS_MKR data.

  Marker beacons are low-powered transmitters that provide distance
  information for ILS approaches. The standard ILS approach includes
  outer marker (OM), middle marker (MM), and sometimes inner marker (IM)
  beacons positioned at specific distances from the runway threshold.

  ## Fields

  * `:effective_date` - The 28 Day NASR Subscription Effective Date in format 'YYYY/MM/DD'
  * `:site_number` - Site Number assigned to the Landing Site Location
  * `:site_type_code` - Site Type Code identifying type of landing site. Values: `:airport`, `:balloonport`, `:seaplane_base`, `:gliderport`, `:heliport`, `:ultralight`
  * `:state_code` - Associated State Post Office Code standard two letter abbreviation for US States and Territories
  * `:airport_id` - Airport Identifier associated with the Landing Site
  * `:city` - Associated City Name of ILS Marker facility
  * `:country_code` - Country Post Office Code of the Landing Site Location
  * `:runway_end_id` - Runway End Identifier (runway number and optional L/R/C designation)
  * `:ils_localizer_id` - ILS Localizer Identifier
  * `:system_type_code` - System Type Code. Values: `:ils`, `:localizer_only`, `:simplified_directional_facility`, `:localizer_directional_aid`, `:microwave_landing_system`
  * `:ils_component_type_code` - ILS Component Type Code (OM=Outer Marker, MM=Middle Marker, IM=Inner Marker)
  * `:component_status` - Current operational status of the Marker component
  * `:component_status_date` - Date when component status was last updated
  * `:latitude_degrees` - Latitude of Marker facility in degrees
  * `:latitude_minutes` - Latitude of Marker facility in minutes
  * `:latitude_seconds` - Latitude of Marker facility in seconds
  * `:latitude_hemisphere` - Latitude hemisphere. Values: `:north`, `:south`
  * `:latitude_decimal` - Latitude of Marker facility in decimal degrees
  * `:longitude_degrees` - Longitude of Marker facility in degrees
  * `:longitude_minutes` - Longitude of Marker facility in minutes
  * `:longitude_seconds` - Longitude of Marker facility in seconds
  * `:longitude_hemisphere` - Longitude hemisphere. Values: `:east`, `:west`
  * `:longitude_decimal` - Longitude of Marker facility in decimal degrees
  * `:latitude_longitude_source_code` - Source code for lat/long coordinates
  * `:site_elevation` - Elevation of Marker site above mean sea level (feet)
  * `:marker_facility_type_code` - Marker Facility Type Code
  * `:marker_id_beacon` - Marker Identification Beacon call sign
  * `:compass_locator_name` - Compass Locator Name associated with marker
  * `:frequency` - Frequency of compass locator or associated navigation aid (kHz)
  * `:nav_id` - Navigation Aid Identifier associated with marker
  * `:nav_type` - Navigation Aid Type associated with marker
  * `:low_powered_ndb_status` - Status of Low Powered NDB associated with marker
  """
  import NASR.Utils

  defstruct ~w(
    effective_date
    site_number
    site_type_code
    state_code
    airport_id
    city
    country_code
    runway_end_id
    ils_localizer_id
    system_type_code
    ils_component_type_code
    component_status
    component_status_date
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
    latitude_longitude_source_code
    site_elevation
    marker_facility_type_code
    marker_id_beacon
    compass_locator_name
    frequency
    nav_id
    nav_type
    low_powered_ndb_status
  )a

  @type t() :: %__MODULE__{
          effective_date: Date.t() | nil,
          site_number: String.t(),
          site_type_code: :airport | :balloonport | :seaplane_base | :gliderport | :heliport | :ultralight | String.t() | nil,
          state_code: String.t(),
          airport_id: String.t(),
          city: String.t(),
          country_code: String.t(),
          runway_end_id: String.t(),
          ils_localizer_id: String.t(),
          system_type_code: :ils | :localizer_only | :simplified_directional_facility | :localizer_directional_aid | :microwave_landing_system | String.t() | nil,
          ils_component_type_code: String.t(),
          component_status: String.t(),
          component_status_date: Date.t() | nil,
          latitude_degrees: integer() | nil,
          latitude_minutes: integer() | nil,
          latitude_seconds: float() | nil,
          latitude_hemisphere: :north | :south | String.t() | nil,
          latitude_decimal: float() | nil,
          longitude_degrees: integer() | nil,
          longitude_minutes: integer() | nil,
          longitude_seconds: float() | nil,
          longitude_hemisphere: :east | :west | String.t() | nil,
          longitude_decimal: float() | nil,
          latitude_longitude_source_code: String.t(),
          site_elevation: float() | nil,
          marker_facility_type_code: String.t(),
          marker_id_beacon: String.t(),
          compass_locator_name: String.t(),
          frequency: integer() | nil,
          nav_id: String.t(),
          nav_type: String.t(),
          low_powered_ndb_status: String.t()
        }

  @spec type() :: String.t()
  def type, do: "ILS_MKR"

  @spec new(map()) :: t()
  def new(entity) do
    %__MODULE__{
      effective_date: parse_date(Map.fetch!(entity, "EFF_DATE")),
      site_number: Map.fetch!(entity, "SITE_NO"),
      site_type_code: parse_site_type_code(Map.fetch!(entity, "SITE_TYPE_CODE")),
      state_code: Map.fetch!(entity, "STATE_CODE"),
      airport_id: Map.fetch!(entity, "ARPT_ID"),
      city: Map.fetch!(entity, "CITY"),
      country_code: Map.fetch!(entity, "COUNTRY_CODE"),
      runway_end_id: Map.fetch!(entity, "RWY_END_ID"),
      ils_localizer_id: Map.fetch!(entity, "ILS_LOC_ID"),
      system_type_code: parse_system_type_code(Map.fetch!(entity, "SYSTEM_TYPE_CODE")),
      ils_component_type_code: Map.fetch!(entity, "ILS_COMP_TYPE_CODE"),
      component_status: Map.fetch!(entity, "COMPONENT_STATUS"),
      component_status_date: parse_date(Map.fetch!(entity, "COMPONENT_STATUS_DATE")),
      latitude_degrees: safe_str_to_int(Map.fetch!(entity, "LAT_DEG")),
      latitude_minutes: safe_str_to_int(Map.fetch!(entity, "LAT_MIN")),
      latitude_seconds: safe_str_to_float(Map.fetch!(entity, "LAT_SEC")),
      latitude_hemisphere: parse_hemisphere(Map.fetch!(entity, "LAT_HEMIS")),
      latitude_decimal: safe_str_to_float(Map.fetch!(entity, "LAT_DECIMAL")),
      longitude_degrees: safe_str_to_int(Map.fetch!(entity, "LONG_DEG")),
      longitude_minutes: safe_str_to_int(Map.fetch!(entity, "LONG_MIN")),
      longitude_seconds: safe_str_to_float(Map.fetch!(entity, "LONG_SEC")),
      longitude_hemisphere: parse_hemisphere(Map.fetch!(entity, "LONG_HEMIS")),
      longitude_decimal: safe_str_to_float(Map.fetch!(entity, "LONG_DECIMAL")),
      latitude_longitude_source_code: Map.fetch!(entity, "LAT_LONG_SOURCE_CODE"),
      site_elevation: safe_str_to_float(Map.fetch!(entity, "SITE_ELEVATION")),
      marker_facility_type_code: Map.fetch!(entity, "MKR_FAC_TYPE_CODE"),
      marker_id_beacon: Map.fetch!(entity, "MARKER_ID_BEACON"),
      compass_locator_name: Map.fetch!(entity, "COMPASS_LOCATOR_NAME"),
      frequency: safe_str_to_int(Map.fetch!(entity, "FREQ")),
      nav_id: Map.fetch!(entity, "NAV_ID"),
      nav_type: Map.fetch!(entity, "NAV_TYPE"),
      low_powered_ndb_status: Map.fetch!(entity, "LOW_POWERED_NDB_STATUS")
    }
  end

  defp parse_site_type_code(nil), do: nil
  defp parse_site_type_code(""), do: nil
  defp parse_site_type_code(code) when is_binary(code) do
    case String.trim(code) do
      "A" -> :airport
      "B" -> :balloonport
      "S" -> :seaplane_base
      "G" -> :gliderport
      "H" -> :heliport
      "U" -> :ultralight
      other -> other
    end
  end

  defp parse_system_type_code(nil), do: nil
  defp parse_system_type_code(""), do: nil
  defp parse_system_type_code(code) when is_binary(code) do
    case String.trim(code) do
      "LS" -> :ils
      "LO" -> :localizer_only
      "SD" -> :simplified_directional_facility
      "LD" -> :localizer_directional_aid
      "ML" -> :microwave_landing_system
      other -> other
    end
  end

  defp parse_hemisphere(nil), do: nil
  defp parse_hemisphere(""), do: nil
  defp parse_hemisphere(hemisphere) when is_binary(hemisphere) do
    case String.trim(hemisphere) do
      "N" -> :north
      "S" -> :south
      "E" -> :east
      "W" -> :west
      other -> other
    end
  end
end