defmodule NASR.Entities.ILSBaseData do
  @moduledoc "Entity struct for ILS1 (BASE DATA) records"
  import NASR.Utils
  
  defstruct [
    :record_type_indicator,
    :airport_site_number,
    :ils_runway_end_identifier,
    :ils_system_type,
    :identification_code,
    :information_effective_date,
    :airport_name,
    :associated_city,
    :state_post_office_code,
    :state_name,
    :faa_region_code,
    :airport_identifier,
    :ils_runway_length,
    :ils_runway_width,
    :ils_category,
    :facility_owner_name,
    :facility_operator_name,
    :ils_approach_bearing,
    :magnetic_variation
  ]
  
  @type t() :: %__MODULE__{
    record_type_indicator: String.t() | nil,
    airport_site_number: String.t() | nil,
    ils_runway_end_identifier: String.t() | nil,
    ils_system_type: :ils | :sdf | :localizer | :lda | :ils_dme | :sdf_dme | :loc_dme | :loc_gs | :lda_dme | nil,
    identification_code: String.t() | nil,
    information_effective_date: Date.t() | nil,
    airport_name: String.t() | nil,
    associated_city: String.t() | nil,
    state_post_office_code: String.t() | nil,
    state_name: String.t() | nil,
    faa_region_code: String.t() | nil,
    airport_identifier: String.t() | nil,
    ils_runway_length: integer() | nil,
    ils_runway_width: integer() | nil,
    ils_category: :i | :ii | :iiia | nil,
    facility_owner_name: String.t() | nil,
    facility_operator_name: String.t() | nil,
    ils_approach_bearing: float() | nil,
    magnetic_variation: String.t() | nil
  }
  
  @spec new(map()) :: t()
  def new(entry) do
    %__MODULE__{
      record_type_indicator: entry.record_type_indicator,
      airport_site_number: entry.airport_site_number_identifier_ex_04508_a,
      ils_runway_end_identifier: entry.ils_runway_end_identifier_ex_18_36l,
      ils_system_type: convert_ils_system_type(entry.ils_system_type),
      identification_code: entry.identification_code_of_ils,
      information_effective_date: parse_date(entry.information_effective_date_mm_dd_yyyy),
      airport_name: entry.airport_name_ex_chicago_o_hare_intl,
      associated_city: entry.associated_city_ex_chicago,
      state_post_office_code: entry.two_letter_post_office_code_for_the_state,
      state_name: entry.state_name_ex_illinois,
      faa_region_code: entry.faa_region_code_example_ace_central,
      airport_identifier: entry.airport_identifier,
      ils_runway_length: safe_str_to_int(entry.ils_runway_length_in_whole_feet_ex_4000),
      ils_runway_width: safe_str_to_int(entry.ils_runway_width_in_whole_feet_ex_100),
      ils_category: convert_ils_category(entry.category_of_the_ils_i_ii_iiia),
      facility_owner_name: entry.name_of_owner_of_the_facility_ex_u_s_navy,
      facility_operator_name: entry.name_of_the_ils_facility_operator,
      ils_approach_bearing: safe_str_to_float(entry.ils_approach_bearing_in_degrees_magnetic),
      magnetic_variation: entry.the_magnetic_variation_at_the_ils_facility
    }
  end
  
  
  defp convert_ils_system_type("ILS"), do: :ils
  defp convert_ils_system_type("SDF"), do: :sdf
  defp convert_ils_system_type("LOCALIZER"), do: :localizer
  defp convert_ils_system_type("LDA"), do: :lda
  defp convert_ils_system_type("ILS/DME"), do: :ils_dme
  defp convert_ils_system_type("SDF/DME"), do: :sdf_dme
  defp convert_ils_system_type("LOC/DME"), do: :loc_dme
  defp convert_ils_system_type("LOC/GS"), do: :loc_gs
  defp convert_ils_system_type("LDA/DME"), do: :lda_dme
  defp convert_ils_system_type(_), do: nil
  
  defp convert_ils_category("I"), do: :i
  defp convert_ils_category("II"), do: :ii
  defp convert_ils_category("IIIA"), do: :iiia
  defp convert_ils_category(_), do: nil
end