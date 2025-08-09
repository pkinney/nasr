defmodule NASR.Entities.AirRouteTrafficControlCenterBaseData do
  @moduledoc "Entity struct for AFF1 records"

  defstruct [
    :type,
    :record_type_indicator,
    :air_route_traffic_control_center_identifier,
    :air_route_traffic_control_center_name,
    :site_location_location_of_the_facility,
    :cross_reference_alternate_name_for_remote,
    :facility_type,
    :information_effective_date_mm_dd_yyyy,
    :site_state_name_ex_new_mexico,
    :site_state_post_office_code_ex_nm,
    :site_latitude_formatted,
    :site_latitude_seconds,
    :site_longitude_formatted,
    :site_longitude_seconds,
    :icao_artcc_id_ex_kzab
  ]

  @type t() :: %__MODULE__{
          type: atom() | nil,
          record_type_indicator: String.t() | nil,
          air_route_traffic_control_center_identifier: String.t() | nil,
          air_route_traffic_control_center_name: String.t() | nil,
          site_location_location_of_the_facility: String.t() | nil,
          cross_reference_alternate_name_for_remote: String.t() | nil,
          facility_type: String.t() | nil,
          information_effective_date_mm_dd_yyyy: String.t() | nil,
          site_state_name_ex_new_mexico: String.t() | nil,
          site_state_post_office_code_ex_nm: String.t() | nil,
          site_latitude_formatted: String.t() | nil,
          site_latitude_seconds: String.t() | nil,
          site_longitude_formatted: String.t() | nil,
          site_longitude_seconds: String.t() | nil,
          icao_artcc_id_ex_kzab: String.t() | nil
        }

  @spec new(map()) :: t()
  def new(entry) do
    %__MODULE__{
      type: entry.type,
      record_type_indicator: entry.record_type_indicator,
      air_route_traffic_control_center_identifier: entry.air_route_traffic_control_center_identifier,
      air_route_traffic_control_center_name: entry.air_route_traffic_control_center_name,
      site_location_location_of_the_facility: entry.site_location_location_of_the_facility,
      cross_reference_alternate_name_for_remote: entry.cross_reference_alternate_name_for_remote,
      facility_type: entry.facility_type,
      information_effective_date_mm_dd_yyyy: entry.information_effective_date_mm_dd_yyyy,
      site_state_name_ex_new_mexico: entry.site_state_name_ex_new_mexico,
      site_state_post_office_code_ex_nm: entry.site_state_post_office_code_ex_nm,
      site_latitude_formatted: entry.site_latitude_formatted,
      site_latitude_seconds: entry.site_latitude_seconds,
      site_longitude_formatted: entry.site_longitude_formatted,
      site_longitude_seconds: entry.site_longitude_seconds,
      icao_artcc_id_ex_kzab: entry.icao_artcc_id_ex_kzab
    }
  end
end
