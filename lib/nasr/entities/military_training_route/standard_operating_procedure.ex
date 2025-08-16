defmodule NASR.Entities.MilitaryTrainingRoute.StandardOperatingProcedure do
  @moduledoc """
  Represents Standard Operating Procedures for Military Training Routes from the NASR MTR_SOP data.

  This entity contains detailed standard operating procedures (SOPs) that govern
  the use of Military Training Routes (MTRs). These procedures are essential for
  safe and efficient military aviation training operations within the National
  Airspace System.

  Military Training Routes are established to provide military aviators with
  realistic training environments while ensuring separation from civilian air
  traffic. The SOPs define specific operational requirements, coordination
  procedures, communication protocols, and safety measures that must be followed
  when using these routes.

  Each SOP entry represents a specific procedural requirement or operational
  guideline that applies to a particular military training route. These procedures
  are developed through coordination between military aviation units, FAA air
  traffic control facilities, and other airspace users.

  ## Fields

  * `:eff_date` - Effective Date of the SOP information
  * `:route_type_code` - Route Type Code (e.g., "IR" for Instrument Route, "VR" for Visual Route)
  * `:route_id` - Military Training Route Identifier
  * `:artcc` - Air Route Traffic Control Center having jurisdiction
  * `:sop_seq_no` - SOP Sequence Number for ordering multiple procedures
  * `:sop_text` - Standard Operating Procedure text description

  ## Aviation Context

  Military Training Route SOPs serve critical safety and operational functions:

  - **Safety Protocols**: Define safety procedures and emergency protocols
  - **Coordination Requirements**: Specify coordination between military and civilian ATC
  - **Communication Procedures**: Establish required radio communications and frequencies
  - **Route Reservation**: Define procedures for route activation and scheduling
  - **Traffic Separation**: Ensure separation from civilian aircraft operations
  - **Weather Minimums**: Specify minimum weather conditions for route use
  - **Equipment Requirements**: Define required aircraft equipment and capabilities

  Route types include:
  - **IR Routes**: Instrument routes for all-weather training at or below 1,500 feet AGL
  - **VR Routes**: Visual routes for fair-weather training at or below 1,500 feet AGL
  - **SR Routes**: Slow routes for rotorcraft and propeller aircraft
  - **AR Routes**: Air refueling routes for aerial refueling training

  The SOPs ensure that military training activities are conducted safely and
  efficiently while minimizing impact on civilian aviation operations.
  """

  import NASR.Utils

  @type t() :: %__MODULE__{
          eff_date: Date.t() | nil,
          route_type_code: atom() | nil,
          route_id: String.t() | nil,
          artcc: String.t() | nil,
          sop_seq_no: integer() | nil,
          sop_text: String.t() | nil
        }

  defstruct [
    :eff_date,
    :route_type_code,
    :route_id,
    :artcc,
    :sop_seq_no,
    :sop_text
  ]

  @spec type() :: String.t()
  def type, do: "MTR_SOP"

  @spec new(map()) :: t()
  def new(data), do: from_csv(data)

  @spec from_csv(map()) :: t()
  def from_csv(data) do
    %__MODULE__{
      eff_date: parse_date(data["EFF_DATE"]),
      route_type_code: parse_route_type(data["ROUTE_TYPE_CODE"]),
      route_id: clean_string(data["ROUTE_ID"]),
      artcc: clean_string(data["ARTCC"]),
      sop_seq_no: safe_str_to_int(data["SOP_SEQ_NO"]),
      sop_text: clean_string(data["SOP_TEXT"])
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