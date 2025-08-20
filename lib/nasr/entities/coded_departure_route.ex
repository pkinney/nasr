defmodule NASR.Entities.CodedDepartureRoute do
  @moduledoc """
  Represents Coded Departure Route (CDR) information from the NASR CDR data.

  Coded Departure Routes are pre-planned instrument flight rule (IFR) routes
  that provide traffic flow management and efficiency for departing aircraft.
  These routes specify exact flight paths from departure airports to en-route
  structures, reducing controller workload and improving traffic flow.

  ## Route Components

  * **Route Code** - Unique identifier for the departure route
  * **Origin/Destination** - Airport identifiers
  * **Route String** - Complete navigation sequence including fixes, airways, and procedures
  * **Air Traffic Control Centers** - Responsible ATC facilities
  * **Equipment Requirements** - Navigation equipment needed

  ## Fields

  * `:route_code` - Unique identifier for the coded departure route
  * `:origin_airport` - Origin airport identifier (4-character ICAO code)
  * `:destination_airport` - Destination airport identifier (4-character ICAO code)
  * `:departure_fix` - Initial departure fix or navigation aid
  * `:route_string` - Complete route description with fixes, airways, and procedures
  * `:departure_center` - Departure air traffic control center identifier
  * `:arrival_center` - Arrival air traffic control center identifier
  * `:transition_centers` - Air traffic control centers along the route (space-separated)
  * `:coordination_required` - Whether coordination is required between centers (boolean)
  * `:playbook` - Playbook reference for special procedures
  * `:navigation_equipment` - Required navigation equipment category (integer)
  * `:length` - Route length in nautical miles
  """
  import NASR.Utils

  defstruct ~w(
    route_code
    origin_airport
    destination_airport
    departure_fix
    route_string
    departure_center
    arrival_center
    transition_centers
    coordination_required
    playbook
    navigation_equipment
    length
  )a

  @type t() :: %__MODULE__{
          route_code: String.t(),
          origin_airport: String.t(),
          destination_airport: String.t(),
          departure_fix: String.t(),
          route_string: String.t(),
          departure_center: String.t(),
          arrival_center: String.t(),
          transition_centers: String.t(),
          coordination_required: boolean() | nil,
          playbook: String.t(),
          navigation_equipment: integer() | nil,
          length: integer() | nil
        }

  @spec type() :: String.t()
  def type, do: "CDR"

  @spec new(map()) :: t()
  def new(entity) do
    %__MODULE__{
      route_code: Map.get(entity, "RCode"),
      origin_airport: Map.get(entity, "Orig"),
      destination_airport: Map.get(entity, "Dest"),
      departure_fix: Map.get(entity, "DepFix"),
      route_string: Map.get(entity, "Route String"),
      departure_center: Map.get(entity, "DCNTR"),
      arrival_center: Map.get(entity, "ACNTR"),
      transition_centers: Map.get(entity, "TCNTRs"),
      coordination_required: parse_coordination_required(Map.get(entity, "CoordReq")),
      playbook: Map.get(entity, "Play"),
      navigation_equipment: safe_str_to_int(Map.get(entity, "NavEqp")),
      length: safe_str_to_int(Map.get(entity, "Length"))
    }
  end

  defp parse_coordination_required("Y"), do: true
  defp parse_coordination_required("N"), do: false
  defp parse_coordination_required(_), do: nil
end
