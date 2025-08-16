defmodule NASR.Entities.ATC do
  @moduledoc """
  Represents Air Traffic Control (ATC) facility information from the NASR ATC_BASE data.

  ATC facilities provide air traffic control services including tower control,
  approach and departure control, and other air traffic management services
  throughout the National Airspace System.

  ## Fields

  * `:effective_date` - The 28 Day NASR Subscription Effective Date in format 'YYYY/MM/DD'
  * `:site_number` - Site Number assigned to the Landing Site Location
  * `:site_type_code` - Site Type Code identifying type of landing site. Values: `:airport`, `:balloonport`, `:seaplane_base`, `:gliderport`, `:heliport`, `:ultralight`
  * `:facility_type` - Type of ATC facility (ATCT=Airport Traffic Control Tower, NON-ATCT=Non-Tower)
  * `:state_code` - Associated State Post Office Code standard two letter abbreviation for US States and Territories
  * `:facility_id` - ATC Facility Identifier
  * `:city` - Associated City Name of ATC facility
  * `:country_code` - Country Post Office Code of the facility location
  * `:icao_id` - ICAO Identifier for the facility
  * `:facility_name` - Full name of the ATC facility
  * `:region_code` - FAA Region Code
  * `:tower_operator_code` - Code identifying the tower operator
  * `:tower_call` - Tower radio call sign
  * `:tower_hours` - Hours of tower operation
  * `:primary_approach_radio_call` - Primary approach control radio call sign
  * `:approach_primary_provider` - Primary approach control service provider
  * `:approach_primary_provider_type_code` - Type code for primary approach provider
  * `:secondary_approach_radio_call` - Secondary approach control radio call sign
  * `:approach_secondary_provider` - Secondary approach control service provider
  * `:approach_secondary_provider_type_code` - Type code for secondary approach provider
  * `:primary_departure_radio_call` - Primary departure control radio call sign
  * `:departure_primary_provider` - Primary departure control service provider
  * `:departure_primary_provider_type_code` - Type code for primary departure provider
  * `:secondary_departure_radio_call` - Secondary departure control radio call sign
  * `:departure_secondary_provider` - Secondary departure control service provider
  * `:departure_secondary_provider_type_code` - Type code for secondary departure provider
  * `:control_facility_approach_departure_calls` - Control facility approach/departure call signs
  * `:approach_departure_operator_code` - Approach/departure operator code
  * `:control_providing_hours` - Hours when control services are provided
  * `:secondary_control_providing_hours` - Secondary control service hours
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
    icao_id
    facility_name
    region_code
    tower_operator_code
    tower_call
    tower_hours
    primary_approach_radio_call
    approach_primary_provider
    approach_primary_provider_type_code
    secondary_approach_radio_call
    approach_secondary_provider
    approach_secondary_provider_type_code
    primary_departure_radio_call
    departure_primary_provider
    departure_primary_provider_type_code
    secondary_departure_radio_call
    departure_secondary_provider
    departure_secondary_provider_type_code
    control_facility_approach_departure_calls
    approach_departure_operator_code
    control_providing_hours
    secondary_control_providing_hours
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
          icao_id: String.t(),
          facility_name: String.t(),
          region_code: String.t(),
          tower_operator_code: String.t(),
          tower_call: String.t(),
          tower_hours: String.t(),
          primary_approach_radio_call: String.t(),
          approach_primary_provider: String.t(),
          approach_primary_provider_type_code: String.t(),
          secondary_approach_radio_call: String.t(),
          approach_secondary_provider: String.t(),
          approach_secondary_provider_type_code: String.t(),
          primary_departure_radio_call: String.t(),
          departure_primary_provider: String.t(),
          departure_primary_provider_type_code: String.t(),
          secondary_departure_radio_call: String.t(),
          departure_secondary_provider: String.t(),
          departure_secondary_provider_type_code: String.t(),
          control_facility_approach_departure_calls: String.t(),
          approach_departure_operator_code: String.t(),
          control_providing_hours: String.t(),
          secondary_control_providing_hours: String.t()
        }

  @spec type() :: String.t()
  def type, do: "ATC_BASE"

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
      icao_id: Map.fetch!(entity, "ICAO_ID"),
      facility_name: Map.fetch!(entity, "FACILITY_NAME"),
      region_code: Map.fetch!(entity, "REGION_CODE"),
      tower_operator_code: Map.fetch!(entity, "TWR_OPERATOR_CODE"),
      tower_call: Map.fetch!(entity, "TWR_CALL"),
      tower_hours: Map.fetch!(entity, "TWR_HRS"),
      primary_approach_radio_call: Map.fetch!(entity, "PRIMARY_APCH_RADIO_CALL"),
      approach_primary_provider: Map.fetch!(entity, "APCH_P_PROVIDER"),
      approach_primary_provider_type_code: Map.fetch!(entity, "APCH_P_PROV_TYPE_CD"),
      secondary_approach_radio_call: Map.fetch!(entity, "SECONDARY_APCH_RADIO_CALL"),
      approach_secondary_provider: Map.fetch!(entity, "APCH_S_PROVIDER"),
      approach_secondary_provider_type_code: Map.fetch!(entity, "APCH_S_PROV_TYPE_CD"),
      primary_departure_radio_call: Map.fetch!(entity, "PRIMARY_DEP_RADIO_CALL"),
      departure_primary_provider: Map.fetch!(entity, "DEP_P_PROVIDER"),
      departure_primary_provider_type_code: Map.fetch!(entity, "DEP_P_PROV_TYPE_CD"),
      secondary_departure_radio_call: Map.fetch!(entity, "SECONDARY_DEP_RADIO_CALL"),
      departure_secondary_provider: Map.fetch!(entity, "DEP_S_PROVIDER"),
      departure_secondary_provider_type_code: Map.fetch!(entity, "DEP_S_PROV_TYPE_CD"),
      control_facility_approach_departure_calls: Map.fetch!(entity, "CTL_FAC_APCH_DEP_CALLS"),
      approach_departure_operator_code: Map.fetch!(entity, "APCH_DEP_OPER_CODE"),
      control_providing_hours: Map.fetch!(entity, "CTL_PRVDING_HRS"),
      secondary_control_providing_hours: Map.fetch!(entity, "SECONDARY_CTL_PRVDING_HRS")
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