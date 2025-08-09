defmodule NASR.Entities.PreferredRouteSegment do
  @moduledoc "Entity struct for PFR2 (PREFERRED ROUTE SEGMENT DESCRIPTION) records"
  import NASR.Utils
  
  defstruct [
    :record_type_indicator,
    :origin_facility_location_identifier,
    :destination_facility_location_identifier,
    :type_of_preferred_route_code,
    :route_identifier_sequence_number,
    :segment_sequence_number_within_the_route,
    :segment_identifier_navaid_ident_awy_number,
    :segment_type_described,
    :fix_state_code_post_office_alpha_code,
    :navaid_facility_type_code,
    :navaid_facility_type_described,
    :radial_and_distance_from_navaid,
    :blank,
    :icao_region_code
  ]
  
  @type t() :: %__MODULE__{
    record_type_indicator: String.t() | nil,
    origin_facility_location_identifier: String.t() | nil,
    destination_facility_location_identifier: String.t() | nil,
    type_of_preferred_route_code: String.t() | nil,
    route_identifier_sequence_number: String.t() | nil,
    segment_sequence_number_within_the_route: String.t() | nil,
    segment_identifier_navaid_ident_awy_number: String.t() | nil,
    segment_type_described: String.t() | nil,
    fix_state_code_post_office_alpha_code: String.t() | nil,
    navaid_facility_type_code: String.t() | nil,
    navaid_facility_type_described: String.t() | nil,
    radial_and_distance_from_navaid: String.t() | nil,
    blank: String.t() | nil,
    icao_region_code: String.t() | nil
  }
  
  @spec new(map()) :: t()
  def new(entry) do
    %__MODULE__{
      record_type_indicator: entry.record_type_indicator,
      origin_facility_location_identifier: entry.origin_facility_location_identifier,
      destination_facility_location_identifier: entry.destination_facility_location_identifier,
      type_of_preferred_route_code: entry.type_of_preferred_route_code,
      route_identifier_sequence_number: entry.route_identifier_sequence_number_1_99,
      segment_sequence_number_within_the_route: entry.segment_sequence_number_within_the_route,
      segment_identifier_navaid_ident_awy_number: entry.segment_identifier_navaid_ident_awy_number,
      segment_type_described: entry.segment_type_described,
      fix_state_code_post_office_alpha_code: entry.fix_state_code___post_office_alpha_code,
      navaid_facility_type_code: entry.navaid_facility_type_code,
      navaid_facility_type_described: entry.navaid_facility_type_described,
      radial_and_distance_from_navaid: entry.radial_and_distance_from_navaid,
      blank: entry.blank,
      icao_region_code: entry.icao_region_code
    }
  end
end