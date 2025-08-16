defmodule NASR.Entities.MaximumAuthorizedAltitude do
  @moduledoc """
  Represents Maximum Authorized Altitude Base information from the NASR MAA_BASE data.

  Maximum Authorized Altitudes (MAA) define special use airspace areas including 
  aerobatic practice areas, restricted areas, prohibited areas, and other special 
  activity areas. These areas have specific altitude restrictions and operational 
  limitations designed to protect aviation activities, national security interests, 
  or public welfare.

  The MAA system provides critical information for flight planning and air traffic 
  control, ensuring that aircraft operations remain within authorized altitude bands 
  and comply with special use airspace restrictions. These areas may be permanently 
  active, activated by NOTAM, or have specific time-of-use restrictions.

  ## Fields

  * `:effective_date` - The 28 Day NASR Subscription Effective Date in format 'YYYY/MM/DD'
  * `:maa_id` - Maximum Authorized Altitude Identifier
  * `:maa_type_name` - Type of MAA area. Values: `:aerobatic_practice`, `:alert_area`, `:controlled_firing_area`, `:military_operations_area`, `:national_security_area`, `:prohibited_area`, `:restricted_area`, `:temporary_flight_restriction`, `:warning_area`
  * `:nav_id` - NAVAID Facility Identifier (if area is navaid-based)
  * `:nav_type` - NAVAID Facility Type
  * `:nav_radial` - Radial from navaid (degrees) if applicable
  * `:nav_distance` - Distance from navaid (nautical miles) if applicable
  * `:state_code` - Associated State Post Office Code standard two letter abbreviation for US States and Territories
  * `:city` - Associated City Name
  * `:latitude` - Latitude in Decimal Format (center point if circular)
  * `:longitude` - Longitude in Decimal Format (center point if circular)
  * `:arpt_ids` - Associated Airport Identifiers (comma separated)
  * `:nearest_arpt` - Nearest Airport Identifier
  * `:nearest_arpt_dist` - Distance to Nearest Airport (nautical miles)
  * `:nearest_arpt_dir` - Direction to Nearest Airport
  * `:maa_name` - Maximum Authorized Altitude Area Name
  * `:max_alt` - Maximum Altitude. Format includes MSL/AGL designation
  * `:min_alt` - Minimum Altitude. Format includes MSL/AGL designation
  * `:maa_radius` - Radius of circular area (nautical miles) if applicable
  * `:description` - Detailed description of the area and its purpose
  * `:maa_use` - Type of use restriction. Values: `:civil`, `:military`, `:joint`
  * `:check_notams` - Flag indicating if NOTAMs should be checked for activation
  * `:time_of_use` - Time periods when area is active
  * `:user_group_name` - Name of user group or organization
  """
  import NASR.Utils

  defstruct ~w(
    effective_date
    maa_id
    maa_type_name
    nav_id
    nav_type
    nav_radial
    nav_distance
    state_code
    city
    latitude
    longitude
    arpt_ids
    nearest_arpt
    nearest_arpt_dist
    nearest_arpt_dir
    maa_name
    max_alt
    min_alt
    maa_radius
    description
    maa_use
    check_notams
    time_of_use
    user_group_name
  )a

  @type t() :: %__MODULE__{
          effective_date: Date.t() | nil,
          maa_id: String.t(),
          maa_type_name: :aerobatic_practice | :alert_area | :controlled_firing_area | :military_operations_area | :national_security_area | :prohibited_area | :restricted_area | :temporary_flight_restriction | :warning_area | String.t() | nil,
          nav_id: String.t(),
          nav_type: String.t(),
          nav_radial: integer() | nil,
          nav_distance: float() | nil,
          state_code: String.t(),
          city: String.t(),
          latitude: float() | nil,
          longitude: float() | nil,
          arpt_ids: String.t(),
          nearest_arpt: String.t(),
          nearest_arpt_dist: float() | nil,
          nearest_arpt_dir: String.t(),
          maa_name: String.t(),
          max_alt: String.t(),
          min_alt: String.t(),
          maa_radius: integer() | nil,
          description: String.t(),
          maa_use: :civil | :military | :joint | String.t() | nil,
          check_notams: String.t(),
          time_of_use: String.t(),
          user_group_name: String.t()
        }

  @spec type() :: String.t()
  def type, do: "MAA_BASE"

  @spec new(map()) :: t()
  def new(entity) do
    %__MODULE__{
      effective_date: parse_date(Map.fetch!(entity, "EFF_DATE")),
      maa_id: Map.fetch!(entity, "MAA_ID"),
      maa_type_name: parse_maa_type(Map.fetch!(entity, "MAA_TYPE_NAME")),
      nav_id: Map.fetch!(entity, "NAV_ID"),
      nav_type: Map.fetch!(entity, "NAV_TYPE"),
      nav_radial: safe_str_to_int(Map.fetch!(entity, "NAV_RADIAL")),
      nav_distance: safe_str_to_float(Map.fetch!(entity, "NAV_DISTANCE")),
      state_code: Map.fetch!(entity, "STATE_CODE"),
      city: Map.fetch!(entity, "CITY"),
      latitude: parse_coordinate(Map.fetch!(entity, "LATITUDE")),
      longitude: parse_coordinate(Map.fetch!(entity, "LONGITUDE")),
      arpt_ids: Map.fetch!(entity, "ARPT_IDS"),
      nearest_arpt: Map.fetch!(entity, "NEAREST_ARPT"),
      nearest_arpt_dist: safe_str_to_float(Map.fetch!(entity, "NEAREST_ARPT_DIST")),
      nearest_arpt_dir: Map.fetch!(entity, "NEAREST_ARPT_DIR"),
      maa_name: Map.fetch!(entity, "MAA_NAME"),
      max_alt: Map.fetch!(entity, "MAX_ALT"),
      min_alt: Map.fetch!(entity, "MIN_ALT"),
      maa_radius: safe_str_to_int(Map.fetch!(entity, "MAA_RADIUS")),
      description: Map.fetch!(entity, "DESCRIPTION"),
      maa_use: parse_maa_use(Map.fetch!(entity, "MAA_USE")),
      check_notams: Map.fetch!(entity, "CHECK_NOTAMS"),
      time_of_use: Map.fetch!(entity, "TIME_OF_USE"),
      user_group_name: Map.fetch!(entity, "USER_GROUP_NAME")
    }
  end

  defp parse_maa_type(nil), do: nil
  defp parse_maa_type(""), do: nil
  defp parse_maa_type(type) when is_binary(type) do
    case String.trim(type) do
      "AEROBATIC PRACTICE" -> :aerobatic_practice
      "ALERT AREA" -> :alert_area
      "CONTROLLED FIRING AREA" -> :controlled_firing_area
      "MILITARY OPERATIONS AREA" -> :military_operations_area
      "NATIONAL SECURITY AREA" -> :national_security_area
      "PROHIBITED AREA" -> :prohibited_area
      "RESTRICTED AREA" -> :restricted_area
      "TEMPORARY FLIGHT RESTRICTION" -> :temporary_flight_restriction
      "WARNING AREA" -> :warning_area
      other -> other
    end
  end

  defp parse_maa_use(nil), do: nil
  defp parse_maa_use(""), do: nil
  defp parse_maa_use(use) when is_binary(use) do
    case String.trim(use) do
      "CIVIL" -> :civil
      "MILITARY" -> :military
      "JOINT" -> :joint
      other -> other
    end
  end

  defp parse_coordinate(nil), do: nil
  defp parse_coordinate(""), do: nil
  defp parse_coordinate(coord) when is_binary(coord) do
    # Parse coordinates in format like "33-54-12.8500N" or "087-19-53.7600W"
    coord = String.trim(coord)
    
    cond do
      String.ends_with?(coord, "N") or String.ends_with?(coord, "S") or 
      String.ends_with?(coord, "E") or String.ends_with?(coord, "W") ->
        parse_dms_coordinate(coord)
      
      true ->
        safe_str_to_float(coord)
    end
  end

  defp parse_dms_coordinate(coord) do
    direction = String.last(coord)
    coord_without_dir = String.slice(coord, 0, String.length(coord) - 1)
    
    case String.split(coord_without_dir, "-") do
      [degrees, minutes, seconds] ->
        deg = safe_str_to_float(degrees) || 0
        min = safe_str_to_float(minutes) || 0
        sec = safe_str_to_float(seconds) || 0
        
        decimal = deg + (min / 60.0) + (sec / 3600.0)
        
        # Apply negative for South/West coordinates
        case direction do
          "S" -> -decimal
          "W" -> -decimal
          _ -> decimal
        end
      
      _ ->
        safe_str_to_float(coord_without_dir)
    end
  end
end