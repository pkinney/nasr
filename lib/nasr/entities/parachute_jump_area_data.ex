defmodule NASR.Entities.ParachuteJumpAreaData do
  @moduledoc "Entity struct for PJA1 (BASE AIRSPACE DATA) records"
  import NASR.Utils
  
  defstruct [
    :record_type_indicator,
    :pja_id,
    :navaid_identifier,
    :navaid_facility_type,
    :navaid_facility_type_described,
    :azimuth_from_navaid,
    :distance_from_navaid,
    :navaid_name,
    :state,
    :state_name,
    :city,
    :latitude,
    :longitude,
    :airport_name,
    :airport_site_number,
    :drop_zone_name,
    :max_altitude,
    :area_radius,
    :sectional_charting_required,
    :published_in_airport_facility_directory,
    :description,
    :fss_ident,
    :fss_name,
    :use,
    :volume
  ]
  
  @type t() :: %__MODULE__{
    record_type_indicator: String.t() | nil,
    pja_id: String.t() | nil,
    navaid_identifier: String.t() | nil,
    navaid_facility_type: String.t() | nil,
    navaid_facility_type_described: String.t() | nil,
    azimuth_from_navaid: float() | nil,
    distance_from_navaid: float() | nil,
    navaid_name: String.t() | nil,
    state: String.t() | nil,
    state_name: String.t() | nil,
    city: String.t() | nil,
    latitude: float() | nil,
    longitude: float() | nil,
    airport_name: String.t() | nil,
    airport_site_number: String.t() | nil,
    drop_zone_name: String.t() | nil,
    max_altitude: String.t() | nil,
    area_radius: String.t() | nil,
    sectional_charting_required: boolean() | nil,
    published_in_airport_facility_directory: boolean() | nil,
    description: String.t() | nil,
    fss_ident: String.t() | nil,
    fss_name: String.t() | nil,
    use: String.t() | nil,
    volume: String.t() | nil
  }
  
  @spec new(map()) :: t()
  def new(entry) do
    %__MODULE__{
      record_type_indicator: entry.record_type_indicator,
      pja_id: entry.pja_id,
      navaid_identifier: entry.navaid_identifier_ex_scy,
      navaid_facility_type: entry.navaid_facility_type_code_ex_c,
      navaid_facility_type_described: entry.navaid_facility_type_described,
      azimuth_from_navaid: safe_str_to_float(entry.azimuth_degrees_from_navaid_000_0_359_99),
      distance_from_navaid: safe_str_to_float(entry.distance_in_nautical_miles_from_navaid),
      navaid_name: entry.navaid_name,
      state: entry.pja_state_abbreviation_two_letter_post_office,
      state_name: entry.pja_state_name,
      city: entry.pja_associated_city_name,
      latitude: convert_dms_to_decimal(entry.pja_latitude_formatted),
      longitude: convert_dms_to_decimal(entry.pja_longitude_formatted),
      airport_name: entry.associated_airport_name,
      airport_site_number: entry.associated_airport_site_number,
      drop_zone_name: entry.pja_drop_zone_name,
      max_altitude: entry.pja_maximum_altitude_allowed,
      area_radius: entry.pja_area_radius_in_nautical_miles_from,
      sectional_charting_required: entry.sectional_charting_required_yes_no == "YES",
      published_in_airport_facility_directory: entry.area_to_be_published_in_airport_facility == "YES",
      description: entry.additional_descriptive_text_for_area,
      fss_ident: entry.associated_fss_ident,
      fss_name: entry.associated_fss_name,
      use: entry.pja_use,
      volume: entry.volume
    }
  end
end