defmodule NASR.Entities.ATC.Service do
  @moduledoc """
  Represents ATC Service information from the NASR ATC_SVC data.

  This entity contains information about the types of air traffic control
  services provided by ATC facilities, including radar systems, approach
  control types, airspace classifications, and other operational capabilities.

  ## Fields

  * `:effective_date` - The 28 Day NASR Subscription Effective Date in format 'YYYY/MM/DD'
  * `:site_number` - Site Number assigned to the Landing Site Location
  * `:site_type_code` - Site Type Code identifying type of landing site. Values: `:airport`, `:balloonport`, `:seaplane_base`, `:gliderport`, `:heliport`, `:ultralight`
  * `:facility_type` - Type of ATC facility (ATCT=Airport Traffic Control Tower, TRACON=Terminal Radar Approach Control, etc.)
  * `:state_code` - Associated State Post Office Code standard two letter abbreviation for US States and Territories
  * `:facility_id` - ATC Facility Identifier
  * `:city` - Associated City Name of ATC facility
  * `:country_code` - Country Post Office Code of the facility location
  * `:control_service` - Type of control service provided (e.g., ARTS-IIIE, CLASS B, APPROACH, etc.)
  """
  import NASR.Utils

  defstruct ~w(
    effective_date
    site_number
    site_type_code
    facility_type
    state_code
    facility_id
    city
    country_code
    control_service
  )a

  @type t() :: %__MODULE__{
          effective_date: Date.t() | nil,
          site_number: String.t(),
          site_type_code: :airport | :balloonport | :seaplane_base | :gliderport | :heliport | :ultralight | String.t() | nil,
          facility_type: String.t(),
          state_code: String.t(),
          facility_id: String.t(),
          city: String.t(),
          country_code: String.t(),
          control_service: String.t()
        }

  @spec type() :: String.t()
  def type, do: "ATC_SVC"

  @spec new(map()) :: t()
  def new(entity) do
    %__MODULE__{
      effective_date: parse_date(Map.fetch!(entity, "EFF_DATE")),
      site_number: Map.fetch!(entity, "SITE_NO"),
      site_type_code: parse_site_type_code(Map.fetch!(entity, "SITE_TYPE_CODE")),
      facility_type: Map.fetch!(entity, "FACILITY_TYPE"),
      state_code: Map.fetch!(entity, "STATE_CODE"),
      facility_id: Map.fetch!(entity, "FACILITY_ID"),
      city: Map.fetch!(entity, "CITY"),
      country_code: Map.fetch!(entity, "COUNTRY_CODE"),
      control_service: Map.fetch!(entity, "CTL_SVC")
    }
  end

  defp parse_site_type_code(nil), do: nil
  defp parse_site_type_code(""), do: nil
  defp parse_site_type_code(code) when is_binary(code) do
    case String.trim(code) do
      "A" -> :airport
      "B" -> :balloonport
      "S" -> :seaplane_base
      "G" -> :gliderport
      "H" -> :heliport
      "U" -> :ultralight
      other -> other
    end
  end
end