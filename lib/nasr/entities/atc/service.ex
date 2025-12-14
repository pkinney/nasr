defmodule NASR.Entities.ATC.Service do
  @moduledoc """
  Represents ATC Service information from the NASR ATC_SVC data.

  This entity contains information about the types of air traffic control
  services provided by ATC facilities, including radar systems, approach
  control types, airspace classifications, and other operational capabilities.

  ## Fields

  * `:effective_date` - The 28 Day NASR Subscription Effective Date in format 'YYYY/MM/DD'
  * `:site_number` - Site Number assigned to the Landing Site Location
  * `:site_type` - Site Type identifying type of landing site. Values: `:airport`, `:balloonport`, `:seaplane_base`, `:gliderport`, `:heliport`, `:ultralight`
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
    site_type
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
          site_type:
            :airport | :balloonport | :seaplane_base | :gliderport | :heliport | :ultralight | String.t() | nil,
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
      effective_date: parse_date(Map.get(entity, "EFF_DATE")),
      site_number: Map.get(entity, "SITE_NO"),
      site_type: parse_site_type_code(Map.get(entity, "SITE_TYPE_CODE")),
      facility_type: Map.get(entity, "FACILITY_TYPE"),
      state_code: Map.get(entity, "STATE_CODE"),
      facility_id: Map.get(entity, "FACILITY_ID"),
      city: Map.get(entity, "CITY"),
      country_code: Map.get(entity, "COUNTRY_CODE"),
      control_service: Map.get(entity, "CTL_SVC")
    }
  end
end
