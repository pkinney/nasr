defmodule NASR.Entities.MilitaryTrainingRoute.Terrain do
  @moduledoc """
  Represents Terrain information for Military Training Routes from the NASR MTR_TERR data.

  This entity contains terrain-related information and restrictions for Military
  Training Routes (MTRs). Terrain considerations are critical for military aviation
  training as they define authorized flight segments, altitude restrictions, and
  geographic limitations for safe low-level flight operations.

  Military Training Routes often involve low-altitude flight operations that
  require careful consideration of terrain features, obstacles, and geographic
  constraints. The terrain data ensures that military aircraft can safely conduct
  training operations while maintaining appropriate separation from terrain and
  man-made obstacles.

  The terrain information is used by:
  - Military flight planning systems
  - Air traffic control facilities
  - Route approval authorities
  - Military aviation units for mission planning
  - Safety assessment and risk management

  ## Fields

  * `:eff_date` - Effective Date of the terrain information
  * `:route_type_code` - Route Type Code (e.g., "IR" for Instrument Route, "VR" for Visual Route)
  * `:route_id` - Military Training Route Identifier
  * `:artcc` - Air Route Traffic Control Center having jurisdiction
  * `:terrain_seq_no` - Terrain Sequence Number for ordering multiple terrain descriptions
  * `:terrain_text` - Terrain description text providing specific terrain information

  ## Aviation Context

  Military Training Route terrain information addresses several critical aspects:

  - **Authorized Segments**: Defines which portions of a route are authorized for use
  - **Terrain Clearance**: Ensures adequate separation from terrain features
  - **Geographic Boundaries**: Specifies lateral and vertical limits of the route
  - **Obstacle Avoidance**: Identifies terrain-related obstacles and restrictions
  - **Seasonal Variations**: May include seasonal restrictions due to terrain conditions
  - **Emergency Procedures**: Terrain considerations for emergency escape maneuvers

  Route types and terrain considerations:
  - **IR Routes**: Instrument routes requiring terrain clearance for IFR operations
  - **VR Routes**: Visual routes with terrain following capabilities
  - **SR Routes**: Slow routes with specific terrain clearance requirements
  - **AR Routes**: Air refueling routes with terrain separation requirements

  Terrain descriptions typically reference route segments using alphanumeric
  designators (e.g., "A to B", "A to H") that correspond to specific geographic
  points along the route. These designations help define the exact portions of
  the route where specific terrain considerations apply.
  """

  import NASR.Utils

  @type t() :: %__MODULE__{
          eff_date: Date.t() | nil,
          route_type_code: atom() | nil,
          route_id: String.t() | nil,
          artcc: String.t() | nil,
          terrain_seq_no: integer() | nil,
          terrain_text: String.t() | nil
        }

  defstruct [
    :eff_date,
    :route_type_code,
    :route_id,
    :artcc,
    :terrain_seq_no,
    :terrain_text
  ]

  @spec type() :: String.t()
  def type, do: "MTR_TERR"

  @spec new(map()) :: t()
  def new(data), do: from_csv(data)

  @spec from_csv(map()) :: t()
  def from_csv(data) do
    %__MODULE__{
      eff_date: parse_date(data["EFF_DATE"]),
      route_type_code: parse_route_type(data["ROUTE_TYPE_CODE"]),
      route_id: clean_string(data["ROUTE_ID"]),
      artcc: clean_string(data["ARTCC"]),
      terrain_seq_no: safe_str_to_int(data["TERRAIN_SEQ_NO"]),
      terrain_text: clean_string(data["TERRAIN_TEXT"])
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