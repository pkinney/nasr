defmodule NASR.Entities.MilitaryTrainingRoute.Point do
  @moduledoc """
  Represents Military Training Route Point information from the NASR MTR_PT data.

  MTR Point records define the specific waypoints and segments that make up each
  Military Training Route. These points include entry/exit points, turn points,
  altitude restrictions, and navigation references that define the three-dimensional
  corridor through which military aircraft conduct training operations.

  ## Fields

  * `:effective_date` - The 28 Day NASR Subscription Effective Date in format 'YYYY/MM/DD'
  * `:route_type_code` - Military Training Route Type Code. Values: `:instrument_route`, `:visual_route`
  * `:route_id` - Military Training Route Identifier (typically 3-digit number)
  * `:artcc` - Air Route Traffic Control Center responsible for coordination
  * `:route_point_sequence` - Sequential number of the point along the route
  * `:route_point_id` - Identifier for this specific route point
  * `:next_route_point_id` - Identifier for the next point along the route
  * `:segment_text` - Descriptive text for the route segment including altitude restrictions
  * `:latitude_degrees` - Latitude in degrees (integer part)
  * `:latitude_minutes` - Latitude in minutes (integer part)
  * `:latitude_seconds` - Latitude in seconds (decimal)
  * `:latitude_hemisphere` - Latitude hemisphere (N/S)
  * `:latitude` - Latitude in decimal degrees
  * `:longitude_degrees` - Longitude in degrees (integer part)
  * `:longitude_minutes` - Longitude in minutes (integer part)
  * `:longitude_seconds` - Longitude in seconds (decimal)
  * `:longitude_hemisphere` - Longitude hemisphere (E/W)
  * `:longitude` - Longitude in decimal degrees
  * `:navaid_id` - Reference NAVAID identifier if point is NAVAID-based
  * `:navaid_bearing` - Bearing from reference NAVAID in degrees
  * `:navaid_distance` - Distance from reference NAVAID in nautical miles
  """
  import NASR.Utils

  defstruct ~w(
    effective_date
    route_type_code
    route_id
    artcc
    route_point_sequence
    route_point_id
    next_route_point_id
    segment_text
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
    navaid_id
    navaid_bearing
    navaid_distance
  )a

  @type t() :: %__MODULE__{
          effective_date: Date.t() | nil,
          route_type_code: :instrument_route | :visual_route | String.t() | nil,
          route_id: String.t(),
          artcc: String.t(),
          route_point_sequence: integer() | nil,
          route_point_id: String.t(),
          next_route_point_id: String.t(),
          segment_text: String.t(),
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
          navaid_id: String.t(),
          navaid_bearing: integer() | nil,
          navaid_distance: integer() | nil
        }

  @spec type() :: String.t()
  def type, do: "MTR_PT"

  @spec new(map()) :: t()
  def new(entity) do
    %__MODULE__{
      effective_date: parse_date(Map.fetch!(entity, "EFF_DATE")),
      route_type_code: parse_route_type_code(Map.fetch!(entity, "ROUTE_TYPE_CODE")),
      route_id: Map.fetch!(entity, "ROUTE_ID"),
      artcc: Map.fetch!(entity, "ARTCC"),
      route_point_sequence: safe_str_to_int(Map.fetch!(entity, "ROUTE_PT_SEQ")),
      route_point_id: Map.fetch!(entity, "ROUTE_PT_ID"),
      next_route_point_id: Map.fetch!(entity, "NEXT_ROUTE_PT_ID"),
      segment_text: Map.fetch!(entity, "SEGMENT_TEXT"),
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
      navaid_id: Map.fetch!(entity, "NAV_ID"),
      navaid_bearing: safe_str_to_int(Map.fetch!(entity, "NAVAID_BEARING")),
      navaid_distance: safe_str_to_int(Map.fetch!(entity, "NAVAID_DIST"))
    }
  end

  defp parse_route_type_code(nil), do: nil
  defp parse_route_type_code(""), do: nil
  defp parse_route_type_code(code) when is_binary(code) do
    case String.trim(code) do
      "IR" -> :instrument_route
      "VR" -> :visual_route
      other -> other
    end
  end
end