defmodule NASR.Entities.TowerBaseData do
  @moduledoc "Entity struct for TWR1 (BASE DATA) records"
  import NASR.Utils

  defstruct [
    :record_type_indicator,
    :terminal_communications_facility_identifier,
    :information_effective_date,
    :faa_region_code,
    :associated_state_name,
    :associated_state_post_office_code,
    :associated_city_name,
    :official_facility_name,
    :airport_name,
    :latitude_formatted,
    :latitude_seconds,
    :longitude_formatted,
    :longitude_seconds,
    :facility_type,
    :hours_of_operation
  ]

  @type t() :: %__MODULE__{
    record_type_indicator: String.t() | nil,
    terminal_communications_facility_identifier: String.t() | nil,
    information_effective_date: Date.t() | nil,
    faa_region_code: String.t() | nil,
    associated_state_name: String.t() | nil,
    associated_state_post_office_code: String.t() | nil,
    associated_city_name: String.t() | nil,
    official_facility_name: String.t() | nil,
    airport_name: String.t() | nil,
    latitude_formatted: String.t() | nil,
    latitude_seconds: String.t() | nil,
    longitude_formatted: String.t() | nil,
    longitude_seconds: String.t() | nil,
    facility_type: String.t() | nil,
    hours_of_operation: String.t() | nil
  }

  @spec new(map()) :: t()
  def new(entry) do
    %__MODULE__{
      record_type_indicator: entry.record_type_indicator,
      terminal_communications_facility_identifier: entry.terminal_communications_facility_identifier,
      information_effective_date: parse_date(entry.information_effective_date_mm_dd_yyyy),
      faa_region_code: entry.faa_region_code,
      associated_state_name: entry.associated_state_name,
      associated_state_post_office_code: entry.associated_state_post_office_code,
      associated_city_name: entry.associated_city_name,
      official_facility_name: entry.official_airport_name,
      airport_name: entry.official_airport_name,
      latitude_formatted: entry.airport_reference_point_latitude_formatted,
      latitude_seconds: entry.airport_reference_point_latitude_seconds,
      longitude_formatted: entry.airport_reference_point_longitude_formatted,
      longitude_seconds: entry.airport_reference_point_longitude_seconds,
      facility_type: entry.facility_type,
      hours_of_operation: entry.number_of_hours_of_daily_operation
    }
  end
end