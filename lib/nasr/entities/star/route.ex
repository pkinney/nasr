defmodule NASR.Entities.STAR.Route do
  @moduledoc """
  Represents STAR Route information from the NASR STAR_RTE data.

  This entity contains the detailed route information for STAR procedures,
  including the sequence of waypoints, navigation aids, and fixes that define
  the arrival path from the en route structure to the terminal area.

  ## Fields

  * `:effective_date` - The 28 Day NASR Subscription Effective Date in format 'YYYY/MM/DD'
  * `:star_computer_code` - Computer code used for the STAR procedure
  * `:artcc` - Air Route Traffic Control Center responsible for the procedure
  * `:route_portion_type` - Type of route portion (BODY, TRANSITION, etc.)
  * `:route_name` - Name of the specific route or transition
  * `:body_sequence` - Sequence number for the procedure body
  * `:transition_computer_code` - Computer code for transition if applicable
  * `:point_sequence` - Sequence number of the point in the route
  * `:point` - Navigation point identifier (waypoint, NAVAID, or fix)
  * `:icao_region_code` - ICAO region code for the point
  * `:point_type` - Type of navigation point (WP=Waypoint, RP=Reporting Point, VOR, NDB, etc.)
  * `:next_point` - Next navigation point in the sequence
  * `:airport_runway_association` - Airports and runways associated with this route segment
  """
  import NASR.Utils

  defstruct ~w(
    effective_date
    star_computer_code
    artcc
    route_portion_type
    route_name
    body_sequence
    transition_computer_code
    point_sequence
    point
    icao_region_code
    point_type
    next_point
    airport_runway_association
  )a

  @type t() :: %__MODULE__{
          effective_date: Date.t() | nil,
          star_computer_code: String.t(),
          artcc: String.t(),
          route_portion_type: String.t(),
          route_name: String.t(),
          body_sequence: integer() | nil,
          transition_computer_code: String.t(),
          point_sequence: integer() | nil,
          point: String.t(),
          icao_region_code: String.t(),
          point_type: String.t(),
          next_point: String.t(),
          airport_runway_association: String.t()
        }

  @spec type() :: String.t()
  def type, do: "STAR_RTE"

  @spec new(map()) :: t()
  def new(entity) do
    %__MODULE__{
      effective_date: parse_date(Map.fetch!(entity, "EFF_DATE")),
      star_computer_code: Map.fetch!(entity, "STAR_COMPUTER_CODE"),
      artcc: Map.fetch!(entity, "ARTCC"),
      route_portion_type: Map.fetch!(entity, "ROUTE_PORTION_TYPE"),
      route_name: Map.fetch!(entity, "ROUTE_NAME"),
      body_sequence: safe_str_to_int(Map.fetch!(entity, "BODY_SEQ")),
      transition_computer_code: Map.fetch!(entity, "TRANSITION_COMPUTER_CODE"),
      point_sequence: safe_str_to_int(Map.fetch!(entity, "POINT_SEQ")),
      point: Map.fetch!(entity, "POINT"),
      icao_region_code: Map.fetch!(entity, "ICAO_REGION_CODE"),
      point_type: Map.fetch!(entity, "POINT_TYPE"),
      next_point: Map.fetch!(entity, "NEXT_POINT"),
      airport_runway_association: Map.fetch!(entity, "ARPT_RWY_ASSOC")
    }
  end
end