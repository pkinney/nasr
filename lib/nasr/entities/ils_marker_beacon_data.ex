defmodule NASR.Entities.ILSMarkerBeaconData do
  @moduledoc "Entity struct for ILS5 (MARKER BEACON DATA) records"
  import NASR.Utils
  
  defstruct [
    :record_type_indicator,
    :airport_site_number,
    :ils_runway_end_identifier,
    :ils_system_type,
    :marker_type,
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
    :facility_type,
    :location_identifier,
    :marker_name,
    :locator_frequency,
    :colocated_navaid_info,
    :ndb_status,
    :service_provided
  ]
  
  @type t() :: %__MODULE__{
    record_type_indicator: String.t() | nil,
    airport_site_number: String.t() | nil,
    ils_runway_end_identifier: String.t() | nil,
    ils_system_type: :ils | :sdf | :localizer | :lda | :ils_dme | :sdf_dme | :loc_dme | :loc_gs | :lda_dme | nil,
    marker_type: :inner_marker | :middle_marker | :outer_marker | nil,
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
    facility_type: :marker | :comlo | :ndb | :marker_comlo | :marker_ndb | nil,
    location_identifier: String.t() | nil,
    marker_name: String.t() | nil,
    locator_frequency: integer() | nil,
    colocated_navaid_info: String.t() | nil,
    ndb_status: :operational_ifr | :operational_vfr_only | :operational_restricted | :decommissioned | :shutdown | nil,
    service_provided: String.t() | nil
  }
  
  @spec new(map()) :: t()
  def new(entry) do
    %__MODULE__{
      record_type_indicator: entry.record_type_indicator,
      airport_site_number: entry.airport_site_number_identifier_ex_04508_a,
      ils_runway_end_identifier: entry.ils_runway_end_identifier_ex_18_36l,
      ils_system_type: convert_ils_system_type(entry.ils_system_type_see_ils1_record_type_for_list),
      marker_type: convert_marker_type(entry.marker_type_im___inner_marker_mm___middle),
      operational_status: convert_operational_status(entry.status_of_marker_beacon_operational),
      operational_status_date: parse_date(entry.date_of_marker_beacon_operational_status),
      latitude_formatted: entry.latitude_of_marker_beacon_formatted,
      latitude_seconds: entry.latitude_of_marker_beacon_all_seconds,
      longitude_formatted: entry.longitude_of_marker_beacon_formatted,
      longitude_seconds: entry.longitude_of_marker_beacon_all_seconds,
      position_source: convert_source_code(entry.indicating_source_of_latitude_longitude),
      distance_from_approach_end: safe_str_to_int(entry.distance_of_marker_beacon),
      distance_from_centerline: safe_str_to_int(entry.of_marker_beacon),
      direction_from_centerline: convert_direction(entry.indicating_source_of_distance),
      distance_source: convert_source_code(entry.indicating_source_of_distance),
      site_elevation: safe_str_to_float(entry.elevation_of_marker_beacon),
      facility_type: convert_facility_type(entry.facility_type_of_marker_locator),
      location_identifier: entry.location_identifier_of_beacon_at_marker,
      marker_name: entry.name_of_the_marker_locator_beacon,
      locator_frequency: safe_str_to_int(entry.frequency_of_locator_beacon_at_middle_marker),
      colocated_navaid_info: entry.identifier_navaid_type_of_navigation,
      ndb_status: convert_operational_status(entry.powered_ndb_status_of_marker_beacon),
      service_provided: entry.provided_by_marker
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
  
  defp convert_marker_type("IM"), do: :inner_marker
  defp convert_marker_type("MM"), do: :middle_marker
  defp convert_marker_type("OM"), do: :outer_marker
  defp convert_marker_type(_), do: nil
  
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
  
  defp convert_facility_type("MARKER"), do: :marker
  defp convert_facility_type("COMLO"), do: :comlo
  defp convert_facility_type("NDB"), do: :ndb
  defp convert_facility_type("MARKER/COMLO"), do: :marker_comlo
  defp convert_facility_type("MARKER/NDB"), do: :marker_ndb
  defp convert_facility_type(_), do: nil
end