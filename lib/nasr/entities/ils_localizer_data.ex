defmodule NASR.Entities.ILSLocalizerData do
  @moduledoc "Entity struct for ILS2 (LOCALIZER DATA) records"
  import NASR.Utils
  
  defstruct [
    :record_type_indicator,
    :airport_site_number,
    :ils_runway_end_identifier,
    :ils_system_type,
    :operational_status,
    :operational_status_date,
    :latitude_formatted,
    :latitude_seconds,
    :longitude_formatted,
    :longitude_seconds,
    :position_source,
    :distance_from_approach_end,
    :distance_from_centerline,
    :direction_from_centerline,
    :distance_source,
    :site_elevation,
    :localizer_frequency,
    :back_course_status,
    :course_width,
    :course_width_at_threshold,
    :distance_from_stop_end,
    :direction_from_stop_end,
    :services_code
  ]
  
  @type t() :: %__MODULE__{
    record_type_indicator: String.t() | nil,
    airport_site_number: String.t() | nil,
    ils_runway_end_identifier: String.t() | nil,
    ils_system_type: :ils | :sdf | :localizer | :lda | :ils_dme | :sdf_dme | :loc_dme | :loc_gs | :lda_dme | nil,
    operational_status: :operational_ifr | :operational_vfr_only | :operational_restricted | :decommissioned | :shutdown | nil,
    operational_status_date: Date.t() | nil,
    latitude_formatted: String.t() | nil,
    latitude_seconds: String.t() | nil,
    longitude_formatted: String.t() | nil,
    longitude_seconds: String.t() | nil,
    position_source: :air_force | :coast_guard | :canadian_airac | :faa | :tech_ops | :nos | :ngs | :dod | :navy | :owner | :army | :siap | :survey | :surveyed | nil,
    distance_from_approach_end: integer() | nil,
    distance_from_centerline: integer() | nil,
    direction_from_centerline: :left | :right | nil,
    distance_source: :air_force | :coast_guard | :canadian_airac | :faa | :tech_ops | :nos | :ngs | :dod | :navy | :owner | :army | :siap | :survey | :surveyed | nil,
    site_elevation: float() | nil,
    localizer_frequency: float() | nil,
    back_course_status: :restricted | :no_restrictions | :usable | :unusable | nil,
    course_width: float() | nil,
    course_width_at_threshold: float() | nil,
    distance_from_stop_end: integer() | nil,
    direction_from_stop_end: :left | :right | nil,
    services_code: :approach_control | :atis | :no_voice | nil
  }
  
  @spec new(map()) :: t()
  def new(entry) do
    %__MODULE__{
      record_type_indicator: entry.record_type_indicator,
      airport_site_number: entry.airport_site_number_identifier_ex_04508_a,
      ils_runway_end_identifier: entry.ils_runway_end_identifier_ex_18_36l,
      ils_system_type: convert_ils_system_type(entry.ils_system_type_see_ils1_record_type_for_list),
      operational_status: convert_operational_status(entry.status_of_localizer_operational_ifr),
      operational_status_date: parse_date(entry.date_of_localizer_operational_status),
      latitude_formatted: entry.latitude_of_localizer_antenna_formatted,
      latitude_seconds: entry.latitude_of_localizer_antenna_all_seconds,
      longitude_formatted: entry.longitude_of_localizer_antenna_formatted,
      longitude_seconds: entry.longitude_of_localizer_antenna_all_seconds,
      position_source: convert_source_code(entry.indicating_source_of_latitude_longitude),
      distance_from_approach_end: safe_str_to_int(entry.distance_of_localizer_antenna),
      distance_from_centerline: safe_str_to_int(entry.of_localizer_antenna_from_runway),
      direction_from_centerline: convert_direction(entry.indicating_source_of_distance),
      distance_source: convert_source_code(entry.indicating_source_of_distance),
      site_elevation: safe_str_to_float(entry.elevation_of_localizer_antenna),
      localizer_frequency: safe_str_to_float(entry.localizer_frequency_mhz_ex_108_10),
      back_course_status: convert_back_course_status(entry.back_course_status_restricted),
      course_width: safe_str_to_float(entry.localizer_course_width_degrees_and_hundredths),
      course_width_at_threshold: safe_str_to_float(entry.course_width_at_threshold),
      distance_from_stop_end: safe_str_to_int(entry.localizer_distance_from_stop_end_of_rwy_feet),
      direction_from_stop_end: convert_direction(entry.direction_from_stop_end_of_rwy),
      services_code: convert_services_code(entry.services_code)
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
  
  defp convert_operational_status("OPERATIONAL IFR"), do: :operational_ifr
  defp convert_operational_status("OPERATIONAL VFR ONLY"), do: :operational_vfr_only
  defp convert_operational_status("OPERATIONAL RESTRICTED"), do: :operational_restricted
  defp convert_operational_status("DECOMMISSIONED"), do: :decommissioned
  defp convert_operational_status("SHUTDOWN"), do: :shutdown
  defp convert_operational_status(_), do: nil
  
  defp convert_source_code("A"), do: :air_force
  defp convert_source_code("C"), do: :coast_guard
  defp convert_source_code("D"), do: :canadian_airac
  defp convert_source_code("F"), do: :faa
  defp convert_source_code("FS"), do: :tech_ops
  defp convert_source_code("G"), do: :nos
  defp convert_source_code("K"), do: :ngs
  defp convert_source_code("M"), do: :dod
  defp convert_source_code("N"), do: :navy
  defp convert_source_code("O"), do: :owner
  defp convert_source_code("P"), do: :nos
  defp convert_source_code("Q"), do: :nos
  defp convert_source_code("R"), do: :army
  defp convert_source_code("S"), do: :siap
  defp convert_source_code("T"), do: :survey
  defp convert_source_code("Z"), do: :surveyed
  defp convert_source_code(_), do: nil
  
  defp convert_direction("L"), do: :left
  defp convert_direction("R"), do: :right
  defp convert_direction(_), do: nil
  
  defp convert_back_course_status("RESTRICTED"), do: :restricted
  defp convert_back_course_status("NO RESTRICTIONS"), do: :no_restrictions
  defp convert_back_course_status("USABLE"), do: :usable
  defp convert_back_course_status("UNUSABLE"), do: :unusable
  defp convert_back_course_status(_), do: nil
  
  defp convert_services_code("AP"), do: :approach_control
  defp convert_services_code("AT"), do: :atis
  defp convert_services_code("NV"), do: :no_voice
  defp convert_services_code(_), do: nil
end