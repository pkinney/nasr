defmodule NASR.Entities.MilitaryTrainingRoute do
  @moduledoc """
  Represents Military Training Route base information from the NASR MTR_BASE data.

  Military Training Routes (MTRs) are corridors established for the purpose of conducting
  low-altitude, high-speed military flight training. These routes allow military aircraft
  to practice navigation, formation flying, and tactical maneuvers in realistic environments
  while maintaining separation from civilian air traffic.

  MTRs are designated as either Instrument Routes (IR) or Visual Routes (VR):
  - IR routes can be flown under IFR regardless of weather conditions below 10,000 feet MSL
  - VR routes are flown under VFR only and are generally established below 1,500 feet AGL

  ## Fields

  * `:effective_date` - The 28 Day NASR Subscription Effective Date in format 'YYYY/MM/DD'
  * `:route_type_code` - Military Training Route Type Code. Values: `:instrument_route`, `:visual_route`
  * `:route_id` - Military Training Route Identifier (typically 3-digit number)
  * `:artcc` - Air Route Traffic Control Center(s) responsible for the route
  * `:fss` - Flight Service Station(s) providing services for the route
  * `:time_of_use` - Operating hours and time restrictions for the route
  """
  import NASR.Utils

  defstruct ~w(
    effective_date
    route_type_code
    route_id
    artcc
    fss
    time_of_use
  )a

  @type t() :: %__MODULE__{
          effective_date: Date.t() | nil,
          route_type_code: :instrument_route | :visual_route | String.t() | nil,
          route_id: String.t(),
          artcc: String.t(),
          fss: String.t(),
          time_of_use: String.t()
        }

  @spec type() :: String.t()
  def type, do: "MTR_BASE"

  @spec new(map()) :: t()
  def new(entity) do
    %__MODULE__{
      effective_date: parse_date(Map.fetch!(entity, "EFF_DATE")),
      route_type_code: parse_route_type_code(Map.fetch!(entity, "ROUTE_TYPE_CODE")),
      route_id: Map.fetch!(entity, "ROUTE_ID"),
      artcc: Map.fetch!(entity, "ARTCC"),
      fss: Map.fetch!(entity, "FSS"),
      time_of_use: Map.fetch!(entity, "TIME_OF_USE")
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