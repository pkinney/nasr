defmodule NASR.Entities.MiscellaneousActivityAreaBaseData do
  @moduledoc "Entity struct for MAA1 (BASE MISCELLANEOUS ACTIVITY AREA DATA) records"
  import NASR.Utils

  defstruct [
    :record_type_indicator,
    :maa_id,
    :maa_type,
    :navaid_identifier,
    :navaid_facility_type,
    :navaid_facility_type_described,
    :azimuth_from_navaid,
    :distance_from_navaid,
    :navaid_name,
    :state_abbreviation,
    :state_name,
    :associated_city,
    :latitude,
    :longitude,
    :maa_name,
    :use,
    :controlling_agency,
    :effective_date,
    :sectional_charting_required,
    :published_in_airport_facility_directory,
    :description,
    :fss_ident,
    :fss_name
  ]

  @type t() :: %__MODULE__{
    record_type_indicator: String.t() | nil,
    maa_id: String.t() | nil,
    maa_type: String.t() | nil,
    navaid_identifier: String.t() | nil,
    navaid_facility_type: String.t() | nil,
    navaid_facility_type_described: String.t() | nil,
    azimuth_from_navaid: float() | nil,
    distance_from_navaid: float() | nil,
    navaid_name: String.t() | nil,
    state_abbreviation: String.t() | nil,
    state_name: String.t() | nil,
    associated_city: String.t() | nil,
    latitude: float() | nil,
    longitude: float() | nil,
    maa_name: String.t() | nil,
    use: String.t() | nil,
    controlling_agency: String.t() | nil,
    effective_date: Date.t() | nil,
    sectional_charting_required: boolean() | nil,
    published_in_airport_facility_directory: boolean() | nil,
    description: String.t() | nil,
    fss_ident: String.t() | nil,
    fss_name: String.t() | nil
  }

  @spec new(map()) :: t()
  def new(entry) do
    %__MODULE__{
      record_type_indicator: entry.record_type_indicator,
      maa_id: entry.maa_id,
      maa_type: entry.maa_type,
      navaid_identifier: entry.navaid_identifier,
      navaid_facility_type: entry.navaid_facility_type_code,
      navaid_facility_type_described: entry.navaid_facility_type_described,
      azimuth_from_navaid: safe_str_to_float(entry.azimuth_degrees_from_navaid),
      distance_from_navaid: safe_str_to_float(entry.distance_in_nautical_miles_from_navaid),
      navaid_name: entry.navaid_name,
      state_abbreviation: entry.maa_state_abbreviation,
      state_name: entry.maa_state_name,
      associated_city: entry.maa_associated_city_name,
      latitude: convert_dms_to_decimal(entry.maa_latitude_formatted),
      longitude: convert_dms_to_decimal(entry.maa_longitude_formatted),
      maa_name: entry.maa_name,
      use: entry.maa_use,
      controlling_agency: entry.controlling_agency,
      effective_date: parse_date(entry.effective_date),
      sectional_charting_required: convert_yn(entry.sectional_charting_required),
      published_in_airport_facility_directory: convert_yn(entry.published_in_airport_facility_directory),
      description: entry.additional_descriptive_text,
      fss_ident: entry.associated_fss_ident,
      fss_name: entry.associated_fss_name
    }
  end
end