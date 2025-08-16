defmodule NASR.Entities.MilitaryTrainingRoute.Width do
  @moduledoc """
  Represents Width information for Military Training Routes from the NASR MTR_WDTH data.

  This entity contains detailed width specifications for Military Training Routes
  (MTRs). Route width is a critical parameter that defines the lateral boundaries
  of the airspace authorized for military training operations. These width
  specifications ensure proper separation from civilian air traffic and establish
  clear boundaries for military aviation activities.

  Military Training Routes require precisely defined lateral boundaries to:
  - Ensure separation from civilian aircraft
  - Define the protected airspace for military operations
  - Establish coordination requirements with air traffic control
  - Provide clear operational boundaries for military pilots
  - Support airspace management and conflict resolution

  Width specifications may vary along different segments of a route, reflecting
  terrain considerations, airspace complexity, and operational requirements.
  The width data provides the specific dimensions for each segment of the route.

  ## Fields

  * `:eff_date` - Effective Date of the width information
  * `:route_type_code` - Route Type Code (e.g., "IR" for Instrument Route, "VR" for Visual Route)
  * `:route_id` - Military Training Route Identifier
  * `:artcc` - Air Route Traffic Control Center having jurisdiction
  * `:width_seq_no` - Width Sequence Number for ordering multiple width descriptions
  * `:width_text` - Width description text providing specific width dimensions

  ## Aviation Context

  Military Training Route width specifications address several important aspects:

  - **Lateral Boundaries**: Define the protected airspace on either side of the route centerline
  - **Segment Variations**: Different route segments may have different width requirements
  - **Operational Safety**: Ensure adequate separation from other aircraft and obstacles
  - **ATC Coordination**: Provide clear boundaries for air traffic control coordination
  - **Conflict Resolution**: Enable proper spacing between military and civilian operations
  - **Mission Planning**: Support military flight planning and route selection

  Route types and width considerations:
  - **IR Routes**: Instrument routes typically requiring consistent width protection
  - **VR Routes**: Visual routes that may have variable width based on terrain
  - **SR Routes**: Slow routes with specific width requirements for rotorcraft operations
  - **AR Routes**: Air refueling routes requiring wider protected airspace

  Width descriptions typically specify:
  - Distance in nautical miles (NM) either side of centerline
  - Asymmetrical width specifications (e.g., "3 NM left, 1 NM right")
  - Segment-specific variations along the route
  - Geographic reference points for width changes

  Example width specifications:
  - "5 NM EITHER SIDE OF CENTERLINE FOR THE ENTIRE ROUTE"
  - "4 NM EITHER SIDE OF CENTERLINE FROM A TO B"
  - "3 NM LEFT AND 1 NM RIGHT OF CENTERLINE FROM E TO F"
  """

  import NASR.Utils

  @type t() :: %__MODULE__{
          eff_date: Date.t() | nil,
          route_type_code: atom() | nil,
          route_id: String.t() | nil,
          artcc: String.t() | nil,
          width_seq_no: integer() | nil,
          width_text: String.t() | nil
        }

  defstruct [
    :eff_date,
    :route_type_code,
    :route_id,
    :artcc,
    :width_seq_no,
    :width_text
  ]

  @spec type() :: String.t()
  def type, do: "MTR_WDTH"

  @spec new(map()) :: t()
  def new(data), do: from_csv(data)

  @spec from_csv(map()) :: t()
  def from_csv(data) do
    %__MODULE__{
      eff_date: parse_date(data["EFF_DATE"]),
      route_type_code: parse_route_type(data["ROUTE_TYPE_CODE"]),
      route_id: clean_string(data["ROUTE_ID"]),
      artcc: clean_string(data["ARTCC"]),
      width_seq_no: safe_str_to_int(data["WIDTH_SEQ_NO"]),
      width_text: clean_string(data["WIDTH_TEXT"])
    }
  end

  defp clean_string(""), do: nil
  defp clean_string(nil), do: nil
  defp clean_string(str), do: String.trim(str)

  defp parse_route_type("IR"), do: :ir
  defp parse_route_type("VR"), do: :vr
  defp parse_route_type("SR"), do: :sr
  defp parse_route_type("AR"), do: :ar
  defp parse_route_type(nil), do: nil
  defp parse_route_type(""), do: nil
  defp parse_route_type(code) when is_binary(code), do: String.downcase(code) |> String.to_atom()
  defp parse_route_type(_), do: nil
end