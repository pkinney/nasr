defmodule NASR.Entities.HoldingPattern do
  @moduledoc """
  Represents Holding Pattern/Fix Base information from the NASR HPF_BASE data.

  Holding patterns are standardized racetrack-shaped flight procedures designed to 
  delay aircraft in a known area while maintaining obstacle clearance. They consist 
  of an inbound leg toward a holding fix, followed by a 180-degree turn and an outbound 
  leg away from the fix, followed by another 180-degree turn back to the holding fix.

  Holding patterns are critical for air traffic management during periods of high traffic 
  volume, weather delays, or when sequencing aircraft for approaches. The pattern parameters 
  including entry direction, course, turn direction, and leg length are standardized to 
  ensure safe separation and predictable aircraft behavior.

  ## Fields

  * `:effective_date` - The 28 Day NASR Subscription Effective Date in format 'YYYY/MM/DD'
  * `:hp_name` - Holding Pattern Name
  * `:hp_no` - Holding Pattern Number for the specific fix/navaid
  * `:state_code` - Associated State Post Office Code standard two letter abbreviation for US States and Territories
  * `:country_code` - Country Post Office Code where holding pattern is located
  * `:fix_id` - Fix Identifier for the holding fix
  * `:icao_region_code` - ICAO Region Code
  * `:nav_id` - NAVAID Facility Identifier (if holding pattern is based on navaid)
  * `:nav_type` - NAVAID Facility Type. Values: `:localizer`, `:localizer_dme`, `:ndb`, `:tacan`, `:vor`, `:vortac`, `:vor_dme`
  * `:hold_direction` - Direction from fix to holding pattern. Values: `:north`, `:northeast`, `:east`, `:southeast`, `:south`, `:southwest`, `:west`, `:northwest`
  * `:hold_deg_or_crs` - Holding Pattern Radial/Bearing/Course (degrees from fix)
  * `:azimuth` - Type of azimuth reference. Values: `:bearing`, `:course`, `:radial`, `:rnav`
  * `:course_inbound_deg` - Inbound Course to the Fix (degrees)
  * `:turn_direction` - Direction of turns in holding pattern. Values: `:left`, `:right`
  * `:leg_length_dist` - Leg Length Distance (nautical miles) when specified
  """
  import NASR.Utils

  defstruct ~w(
    effective_date
    hp_name
    hp_no
    state_code
    country_code
    fix_id
    icao_region_code
    nav_id
    nav_type
    hold_direction
    hold_deg_or_crs
    azimuth
    course_inbound_deg
    turn_direction
    leg_length_dist
  )a

  @type t() :: %__MODULE__{
          effective_date: Date.t() | nil,
          hp_name: String.t(),
          hp_no: integer() | nil,
          state_code: String.t(),
          country_code: String.t(),
          fix_id: String.t(),
          icao_region_code: String.t(),
          nav_id: String.t(),
          nav_type: :localizer | :localizer_dme | :ndb | :tacan | :vor | :vortac | :vor_dme | String.t() | nil,
          hold_direction: :north | :northeast | :east | :southeast | :south | :southwest | :west | :northwest | String.t() | nil,
          hold_deg_or_crs: integer() | nil,
          azimuth: :bearing | :course | :radial | :rnav | String.t() | nil,
          course_inbound_deg: integer() | nil,
          turn_direction: :left | :right | String.t() | nil,
          leg_length_dist: integer() | nil
        }

  @spec type() :: String.t()
  def type, do: "HPF_BASE"

  @spec new(map()) :: t()
  def new(entity) do
    %__MODULE__{
      effective_date: parse_date(Map.fetch!(entity, "EFF_DATE")),
      hp_name: Map.fetch!(entity, "HP_NAME"),
      hp_no: safe_str_to_int(Map.fetch!(entity, "HP_NO")),
      state_code: Map.fetch!(entity, "STATE_CODE"),
      country_code: Map.fetch!(entity, "COUNTRY_CODE"),
      fix_id: Map.fetch!(entity, "FIX_ID"),
      icao_region_code: Map.fetch!(entity, "ICAO_REGION_CODE"),
      nav_id: Map.fetch!(entity, "NAV_ID"),
      nav_type: parse_nav_type(Map.fetch!(entity, "NAV_TYPE")),
      hold_direction: parse_hold_direction(Map.fetch!(entity, "HOLD_DIRECTION")),
      hold_deg_or_crs: safe_str_to_int(Map.fetch!(entity, "HOLD_DEG_OR_CRS")),
      azimuth: parse_azimuth(Map.fetch!(entity, "AZIMUTH")),
      course_inbound_deg: safe_str_to_int(Map.fetch!(entity, "COURSE_INBOUND_DEG")),
      turn_direction: parse_turn_direction(Map.fetch!(entity, "TURN_DIRECTION")),
      leg_length_dist: safe_str_to_int(Map.fetch!(entity, "LEG_LENGTH_DIST"))
    }
  end

  defp parse_nav_type(nil), do: nil
  defp parse_nav_type(""), do: nil
  defp parse_nav_type(type) when is_binary(type) do
    case String.trim(type) do
      "LD" -> :localizer_dme
      "LS" -> :localizer
      "NDB" -> :ndb
      "TACAN" -> :tacan
      "VOR" -> :vor
      "VORTAC" -> :vortac
      "VOR/DME" -> :vor_dme
      other -> other
    end
  end

  defp parse_hold_direction(nil), do: nil
  defp parse_hold_direction(""), do: nil
  defp parse_hold_direction(direction) when is_binary(direction) do
    case String.trim(direction) do
      "N" -> :north
      "NE" -> :northeast
      "E" -> :east
      "SE" -> :southeast
      "S" -> :south
      "SW" -> :southwest
      "W" -> :west
      "NW" -> :northwest
      other -> other
    end
  end

  defp parse_azimuth(nil), do: nil
  defp parse_azimuth(""), do: nil
  defp parse_azimuth(azimuth) when is_binary(azimuth) do
    case String.trim(azimuth) do
      "BRG" -> :bearing
      "CRS" -> :course
      "RADIAL" -> :radial
      "RNAV" -> :rnav
      other -> other
    end
  end

  defp parse_turn_direction(nil), do: nil
  defp parse_turn_direction(""), do: nil
  defp parse_turn_direction(direction) when is_binary(direction) do
    case String.trim(direction) do
      "L" -> :left
      "R" -> :right
      other -> other
    end
  end
end