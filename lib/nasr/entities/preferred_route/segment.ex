defmodule NASR.Entities.PreferredRoute.Segment do
  @moduledoc """
  Represents individual segments of Preferred Routes from the NASR PFR_SEG data.

  This entity contains detailed information about each segment that comprises a
  preferred route. Preferred routes are broken down into individual segments,
  each representing a specific navigation element such as a waypoint, navaid,
  airway junction, or procedure component.

  Each segment defines a specific portion of the route with its own characteristics,
  navigation type, and sequencing information. This granular approach allows for
  precise route definition and enables air traffic control systems to understand
  the exact composition and requirements of each route segment.

  The segment data is essential for:
  - Route validation and verification
  - Navigation system programming
  - Air traffic control route clearances
  - Flight management system database construction
  - Route amendment and modification procedures

  ## Fields

  * `:eff_date` - Effective Date of the segment information
  * `:origin_id` - Origin Airport Identifier for the overall route
  * `:dstn_id` - Destination Airport Identifier for the overall route
  * `:pfr_type_code` - Preferred Route Type Code (e.g., "TEC" for Terminal routes)
  * `:route_no` - Route Number for multiple routes between same origin/destination
  * `:segment_seq` - Segment Sequence Number (order within the route)
  * `:seg_value` - Segment Value (waypoint name, navaid identifier, or fix designation)
  * `:seg_type` - Segment Type indicating the nature of the navigation element
  * `:state_code` - State Code where the segment element is located
  * `:country_code` - Country Code where the segment element is located
  * `:icao_region_code` - ICAO Region Code for international coordination
  * `:nav_type` - Navigation Type specifying the type of navaid or waypoint
  * `:next_seg` - Next Segment identifier for route continuity

  ## Aviation Context

  Route segments serve critical functions in modern navigation:

  - **Route Definition**: Each segment precisely defines a portion of the flight path
  - **Navigation Accuracy**: Specific identification of waypoints and navaids ensures
    precise navigation
  - **System Programming**: Segments provide the granular data needed for FMS programming
  - **ATC Clearances**: Controllers can reference specific segments for route amendments
  - **International Coordination**: ICAO region codes facilitate cross-border routing

  Segment types include:
  - **NAVAID**: VOR, NDB, TACAN, or other ground-based navigation aids
  - **WAYPOINT**: GPS waypoints or intersection points
  - **AIRWAY**: Designated airway segments
  - **PROCEDURE**: SID, STAR, or approach procedure components
  - **FIX**: Named intersections or reporting points
  """

  import NASR.Utils

  @type t() :: %__MODULE__{
          eff_date: Date.t() | nil,
          origin_id: String.t() | nil,
          dstn_id: String.t() | nil,
          pfr_type_code: atom() | nil,
          route_no: integer() | nil,
          segment_seq: integer() | nil,
          seg_value: String.t() | nil,
          seg_type: atom() | nil,
          state_code: String.t() | nil,
          country_code: String.t() | nil,
          icao_region_code: String.t() | nil,
          nav_type: atom() | nil,
          next_seg: String.t() | nil
        }

  defstruct [
    :eff_date,
    :origin_id,
    :dstn_id,
    :pfr_type_code,
    :route_no,
    :segment_seq,
    :seg_value,
    :seg_type,
    :state_code,
    :country_code,
    :icao_region_code,
    :nav_type,
    :next_seg
  ]

  @spec type() :: String.t()
  def type, do: "PFR_SEG"

  @spec new(map()) :: t()
  def new(data), do: from_csv(data)

  @spec from_csv(map()) :: t()
  def from_csv(data) do
    %__MODULE__{
      eff_date: parse_date(data["EFF_DATE"]),
      origin_id: clean_string(data["ORIGIN_ID"]),
      dstn_id: clean_string(data["DSTN_ID"]),
      pfr_type_code: parse_route_type(data["PFR_TYPE_CODE"]),
      route_no: safe_str_to_int(data["ROUTE_NO"]),
      segment_seq: safe_str_to_int(data["SEGMENT_SEQ"]),
      seg_value: clean_string(data["SEG_VALUE"]),
      seg_type: parse_segment_type(data["SEG_TYPE"]),
      state_code: clean_string(data["STATE_CODE"]),
      country_code: clean_string(data["COUNTRY_CODE"]),
      icao_region_code: clean_string(data["ICAO_REGION_CODE"]),
      nav_type: parse_nav_type(data["NAV_TYPE"]),
      next_seg: clean_string(data["NEXT_SEG"])
    }
  end

  defp clean_string(""), do: nil
  defp clean_string(nil), do: nil
  defp clean_string(str), do: String.trim(str)

  defp parse_route_type("TEC"), do: :tec
  defp parse_route_type("NAR"), do: :nar
  defp parse_route_type("PREF"), do: :pref
  defp parse_route_type("HIGH"), do: :high
  defp parse_route_type("LOW"), do: :low
  defp parse_route_type("RNAV"), do: :rnav
  defp parse_route_type(nil), do: nil
  defp parse_route_type(""), do: nil
  defp parse_route_type(code) when is_binary(code), do: String.downcase(code) |> String.to_atom()
  defp parse_route_type(_), do: nil

  defp parse_segment_type("NAVAID"), do: :navaid
  defp parse_segment_type("WAYPOINT"), do: :waypoint
  defp parse_segment_type("AIRWAY"), do: :airway
  defp parse_segment_type("PROCEDURE"), do: :procedure
  defp parse_segment_type("FIX"), do: :fix
  defp parse_segment_type("AIRPORT"), do: :airport
  defp parse_segment_type(nil), do: nil
  defp parse_segment_type(""), do: nil
  defp parse_segment_type(type) when is_binary(type), do: String.downcase(type) |> String.to_atom()
  defp parse_segment_type(_), do: nil

  defp parse_nav_type("VOR"), do: :vor
  defp parse_nav_type("VORTAC"), do: :vortac
  defp parse_nav_type("VOR/DME"), do: :vor_dme
  defp parse_nav_type("NDB"), do: :ndb
  defp parse_nav_type("TACAN"), do: :tacan
  defp parse_nav_type("DME"), do: :dme
  defp parse_nav_type("GPS"), do: :gps
  defp parse_nav_type("RNAV"), do: :rnav
  defp parse_nav_type("ILS"), do: :ils
  defp parse_nav_type("LOC"), do: :loc
  defp parse_nav_type("LDA"), do: :lda
  defp parse_nav_type("SDF"), do: :sdf
  defp parse_nav_type(nil), do: nil
  defp parse_nav_type(""), do: nil
  defp parse_nav_type(type) when is_binary(type), do: String.downcase(type) |> String.to_atom()
  defp parse_nav_type(_), do: nil
end