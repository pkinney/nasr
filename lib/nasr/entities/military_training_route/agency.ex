defmodule NASR.Entities.MilitaryTrainingRoute.Agency do
  @moduledoc """
  Represents Military Training Route Agency information from the NASR MTR_AGY data.

  MTR Agency records provide detailed contact information for the military agencies
  responsible for coordinating and controlling each Military Training Route. These
  agencies include operating units, scheduling facilities, and point-of-contact
  organizations that manage route usage and coordinate with civilian air traffic control.

  ## Fields

  * `:effective_date` - The 28 Day NASR Subscription Effective Date in format 'YYYY/MM/DD'
  * `:route_type_code` - Military Training Route Type Code. Values: `:instrument_route`, `:visual_route`
  * `:route_id` - Military Training Route Identifier (typically 3-digit number)
  * `:artcc` - Air Route Traffic Control Center responsible for coordination
  * `:agency_type` - Type of agency contact. Values: `:operating`, `:scheduling1`, `:scheduling2`
  * `:agency_name` - Name of the responsible military agency or unit
  * `:station` - Military station or installation name
  * `:address` - Street address of the agency
  * `:city` - City where the agency is located
  * `:state_code` - State code where the agency is located
  * `:zip_code` - ZIP code of the agency location
  * `:commercial_number` - Commercial telephone number for contact
  * `:dsn_number` - Defense Switched Network (DSN) telephone number
  * `:hours` - Operating hours for the agency contact
  """
  import NASR.Utils

  defstruct ~w(
    effective_date
    route_type_code
    route_id
    artcc
    agency_type
    agency_name
    station
    address
    city
    state_code
    zip_code
    commercial_number
    dsn_number
    hours
  )a

  @type t() :: %__MODULE__{
          effective_date: Date.t() | nil,
          route_type_code: :instrument_route | :visual_route | String.t() | nil,
          route_id: String.t(),
          artcc: String.t(),
          agency_type: :operating | :scheduling1 | :scheduling2 | String.t() | nil,
          agency_name: String.t(),
          station: String.t(),
          address: String.t(),
          city: String.t(),
          state_code: String.t(),
          zip_code: String.t(),
          commercial_number: String.t(),
          dsn_number: String.t(),
          hours: String.t()
        }

  @spec type() :: String.t()
  def type, do: "MTR_AGY"

  @spec new(map()) :: t()
  def new(entity) do
    %__MODULE__{
      effective_date: parse_date(Map.fetch!(entity, "EFF_DATE")),
      route_type_code: parse_route_type_code(Map.fetch!(entity, "ROUTE_TYPE_CODE")),
      route_id: Map.fetch!(entity, "ROUTE_ID"),
      artcc: Map.fetch!(entity, "ARTCC"),
      agency_type: parse_agency_type(Map.fetch!(entity, "AGENCY_TYPE")),
      agency_name: Map.fetch!(entity, "AGENCY_NAME"),
      station: Map.fetch!(entity, "STATION"),
      address: Map.fetch!(entity, "ADDRESS"),
      city: Map.fetch!(entity, "CITY"),
      state_code: Map.fetch!(entity, "STATE_CODE"),
      zip_code: Map.fetch!(entity, "ZIP_CODE"),
      commercial_number: Map.fetch!(entity, "COMMERCIAL_NO"),
      dsn_number: Map.fetch!(entity, "DSN_NO"),
      hours: Map.fetch!(entity, "HOURS")
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

  defp parse_agency_type(nil), do: nil
  defp parse_agency_type(""), do: nil
  defp parse_agency_type(type) when is_binary(type) do
    case String.trim(type) do
      "O" -> :operating
      "S1" -> :scheduling1
      "S2" -> :scheduling2
      other -> other
    end
  end
end