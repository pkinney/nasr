defmodule NASR.Entities.ParachuteJumpingArea do
  @moduledoc """
  Represents Parachute Jumping Area (PJA) information from the NASR PJA_BASE data.

  Parachute Jumping Areas are designated airspace areas where parachute jumping
  activities regularly occur. These areas are established to ensure the safety
  of both parachute operations and other aircraft by providing advance notice
  of jumping activities and operational parameters.

  ## PJA Operations

  * **Military** - Military parachute training operations
  * **Civilian** - Civilian sport parachuting operations
  * **Mixed** - Both military and civilian operations

  ## Altitude Reference

  * **MSL** - Mean Sea Level altitude reference
  * **AGL** - Above Ground Level altitude reference

  ## Fields

  * `:effective_date` - The 28 Day NASR Subscription Effective Date in format 'YYYY/MM/DD'
  * `:pja_id` - Unique Parachute Jumping Area identifier
  * `:nav_id` - Navigation aid identifier for reference
  * `:nav_type` - Type of navigation aid (:vor, :vortac, :vor_dme, etc.)
  * `:radial` - Magnetic radial from the navigation aid
  * `:distance` - Distance from navigation aid in nautical miles
  * `:navaid_name` - Name of the reference navigation aid
  * `:state_code` - State where the PJA is located
  * `:city` - City associated with the PJA
  * `:latitude` - Latitude in degrees-minutes-seconds format
  * `:latitude_decimal` - Latitude in decimal degrees
  * `:longitude` - Longitude in degrees-minutes-seconds format
  * `:longitude_decimal` - Longitude in decimal degrees
  * `:arpt_id` - Associated airport identifier (if applicable)
  * `:site_no` - Airport site number (if applicable)
  * `:site_type` - Airport site type (if applicable). Values: `:airport`, `:balloonport`, `:seaplane_base`, `:gliderport`, `:heliport`, `:ultralight`
  * `:drop_zone_name` - Name of the drop zone
  * `:max_altitude` - Maximum altitude for parachute operations
  * `:max_altitude_type` - Altitude reference type (:msl, :agl)
  * `:pja_radius` - Radius of the PJA in nautical miles
  * `:chart_request_flag` - Whether charting is requested (boolean)
  * `:publish_criteria` - Publication criteria met (boolean)
  * `:description` - Additional description of the PJA
  * `:time_of_use` - Operating hours and time restrictions
  * `:fss_id` - Flight Service Station identifier
  * `:fss_name` - Flight Service Station name
  * `:pja_use` - Type of use (:military, :civilian, etc.)
  * `:volume` - Volume designation
  * `:pja_user` - Primary user of the PJA
  * `:remark` - Additional remarks
  """
  import NASR.Utils

  defstruct ~w(
    effective_date
    pja_id
    nav_id
    nav_type
    radial
    distance
    navaid_name
    state_code
    city
    latitude
    latitude_decimal
    longitude
    longitude_decimal
    arpt_id
    site_no
    site_type
    drop_zone_name
    max_altitude
    max_altitude_type
    pja_radius
    chart_request_flag
    publish_criteria
    description
    time_of_use
    fss_id
    fss_name
    pja_use
    volume
    pja_user
    remark
  )a

  @type t() :: %__MODULE__{
          effective_date: Date.t() | nil,
          pja_id: String.t(),
          nav_id: String.t(),
          nav_type: :vor | :vortac | :vor_dme | String.t() | nil,
          radial: float() | nil,
          distance: float() | nil,
          navaid_name: String.t(),
          state_code: String.t(),
          city: String.t(),
          latitude: String.t(),
          latitude_decimal: float() | nil,
          longitude: String.t(),
          longitude_decimal: float() | nil,
          arpt_id: String.t(),
          site_no: String.t(),
          site_type:
            :airport | :balloonport | :seaplane_base | :gliderport | :heliport | :ultralight | String.t() | nil,
          drop_zone_name: String.t(),
          max_altitude: integer() | nil,
          max_altitude_type: :msl | :agl | String.t() | nil,
          pja_radius: integer() | nil,
          chart_request_flag: boolean() | nil,
          publish_criteria: boolean() | nil,
          description: String.t(),
          time_of_use: String.t(),
          fss_id: String.t(),
          fss_name: String.t(),
          pja_use: :military | String.t() | nil,
          volume: String.t(),
          pja_user: String.t(),
          remark: String.t()
        }

  @spec type() :: String.t()
  def type, do: "PJA_BASE"

  @spec new(map()) :: t()
  def new(entity) do
    %__MODULE__{
      effective_date: parse_date(Map.get(entity, "EFF_DATE")),
      pja_id: Map.get(entity, "PJA_ID"),
      nav_id: Map.get(entity, "NAV_ID"),
      nav_type: parse_nav_type(Map.get(entity, "NAV_TYPE")),
      radial: safe_str_to_float(Map.get(entity, "RADIAL")),
      distance: safe_str_to_float(Map.get(entity, "DISTANCE")),
      navaid_name: Map.get(entity, "NAVAID_NAME"),
      state_code: Map.get(entity, "STATE_CODE"),
      city: Map.get(entity, "CITY"),
      latitude: Map.get(entity, "LATITUDE"),
      latitude_decimal: safe_str_to_float(Map.get(entity, "LAT_DECIMAL")),
      longitude: Map.get(entity, "LONGITUDE"),
      longitude_decimal: safe_str_to_float(Map.get(entity, "LONG_DECIMAL")),
      arpt_id: Map.get(entity, "ARPT_ID"),
      site_no: Map.get(entity, "SITE_NO"),
      site_type: parse_site_type_code(Map.get(entity, "SITE_TYPE_CODE")),
      drop_zone_name: Map.get(entity, "DROP_ZONE_NAME"),
      max_altitude: safe_str_to_int(Map.get(entity, "MAX_ALTITUDE")),
      max_altitude_type: parse_altitude_type(Map.get(entity, "MAX_ALTITUDE_TYPE_CODE")),
      pja_radius: safe_str_to_int(Map.get(entity, "PJA_RADIUS")),
      chart_request_flag: convert_yn(Map.get(entity, "CHART_REQUEST_FLAG")),
      publish_criteria: convert_yn(Map.get(entity, "PUBLISH_CRITERIA")),
      description: Map.get(entity, "DESCRIPTION"),
      time_of_use: Map.get(entity, "TIME_OF_USE"),
      fss_id: Map.get(entity, "FSS_ID"),
      fss_name: Map.get(entity, "FSS_NAME"),
      pja_use: parse_pja_use(Map.get(entity, "PJA_USE")),
      volume: Map.get(entity, "VOLUME"),
      pja_user: Map.get(entity, "PJA_USER"),
      remark: Map.get(entity, "REMARK")
    }
  end

  defp parse_nav_type(nil), do: nil
  defp parse_nav_type(""), do: nil

  defp parse_nav_type(type) when is_binary(type) do
    case String.trim(type) do
      "VOR" -> :vor
      "VORTAC" -> :vortac
      "VOR/DME" -> :vor_dme
      other -> other
    end
  end

  defp parse_altitude_type(nil), do: nil
  defp parse_altitude_type(""), do: nil

  defp parse_altitude_type(type) when is_binary(type) do
    case String.trim(type) do
      "MSL" -> :msl
      "AGL" -> :agl
      other -> other
    end
  end

  defp parse_pja_use(nil), do: nil
  defp parse_pja_use(""), do: nil

  defp parse_pja_use(use) when is_binary(use) do
    case String.trim(use) do
      "MILITARY" -> :military
      other -> other
    end
  end
end
