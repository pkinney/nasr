defmodule NASR.Entities.Airport do
  @moduledoc """
  Represents Landing Facility information from the NASR APT_BASE data.

  This entity contains the core information about landing facilities including
  airports, heliports, seaplane bases, gliderports, balloonports, and ultralight
  facilities from the FAA's National Airspace System Resources (NASR) subscription.

  The APT_BASE file is part of the Landing Facility Data comma-separated values (CSV)
  record layout that replaces the legacy APT.txt Subscriber File, providing comprehensive
  information about all types of landing facilities in the United States.

  ## Fields

  * `:site_no` - Landing Facility Site Number. A unique identifying number
  * `:site_type_code` - Landing Facility Type Code. Values: `:airport`, `:balloonport`, `:seaplane_base`, `:gliderport`, `:heliport`, `:ultralight`
  * `:arpt_id` - Location Identifier. Unique 3-4 character alphanumeric identifier assigned to the Landing Facility
  * `:city` - Airport Associated City Name
  * `:state_code` - Associated State Post Office Code standard two letter abbreviation for US States and Territories
  * `:country_code` - Country Post Office Code Airport Located
  * `:region_code` - FAA Region Code
  * `:ado_code` - FAA District or Field Office Code
  * `:state_name` - Associated State Name
  * `:county_name` - Associated County or Parish Name (For Non-Us Aerodromes This May Be Territory Or Province Name)
  * `:county_assoc_state` - Associated County's State (Post Office Code) State where the Associated County is located; may not be the same as the Associated City's State Code
  * `:arpt_name` - Official Facility Name
  * `:ownership_type_code` - Airport Ownership Type. Values: `:public`, `:private`, `:air_force`, `:navy`, `:army`, `:coast_guard`
  * `:facility_use_code` - Facility Use. Values: `:public`, `:private`
  * `:latitude` - Airport Reference Point Latitude in Decimal Format
  * `:longitude` - Airport Reference Point Longitude in Decimal Format
  * `:survey_method_code` - Airport Reference Point Determination Method. Values: `:estimated`, `:surveyed`
  * `:elevation` - Airport Elevation (Nearest Tenth of a Foot MSL). Elevation is measured at the highest point on the centerline of the usable landing surface
  * `:elevation_method_code` - Airport Elevation Determination Method. Values: `:estimated`, `:surveyed`
  * `:magnetic_variation` - Magnetic Variation in degrees
  * `:magnetic_hemisphere` - Magnetic Variation Direction (E/W)
  * `:magnetic_variation_year` - Magnetic Variation Epoch Year
  * `:traffic_pattern_altitude` - Traffic Pattern Altitude (Whole Feet AGL)
  * `:sectional_chart` - Aeronautical Sectional Chart on Which Facility Appears
  * `:distance_from_city` - Distance from Central Business District of the Associated City to the Airport (miles)
  * `:direction_from_city` - Direction of Airport from Central Business District of Associated City (Nearest 1/8 Compass Point)
  * `:land_area_covered` - Land Area Covered by Airport (Acres)
  * `:boundary_artcc_id` - Responsible ARTCC Identifier (The Responsible ARTCC Is The FAA Air Route Traffic Control Center Who Has Control Over The Airport)
  * `:boundary_artcc_computer_id` - Responsible ARTCC (FAA) Computer Identifier
  * `:boundary_artcc_name` - Responsible ARTCC Name
  * `:fss_on_facility_flag` - Tie-In FSS Physically Located On Facility (boolean)
  * `:fss_id` - Tie-In Flight Service Station (FSS) Identifier
  * `:fss_name` - Tie-In FSS Name
  * `:fss_phone_no` - Local Phone Number from Airport to FSS for Administrative Services
  * `:fss_toll_free_no` - Toll Free Phone Number from Airport to FSS for Pilot Briefing Services
  * `:alt_fss_id` - Alternate FSS Identifier provides the identifier of a full-time Flight Service Station that assumes responsibility for the Airport during the off hours of a part-time primary FSS
  * `:alt_fss_name` - Alternate FSS Name
  * `:alt_fss_toll_free_no` - Toll Free Phone Number from Airport to Alternate FSS for Pilot Briefing Services
  * `:notam_facility_id` - Identifier of the Facility responsible for issuing Notices to Airmen (NOTAMS) and Weather information for the Airport
  * `:notam_service_flag` - Availability of NOTAM 'D' Service at Airport (boolean)
  * `:activation_date` - Airport Activation Date (YYYY/MM) provides the YEAR and MONTH that the Facility was added to the NFDC airport database
  * `:airport_status_code` - Airport Status Code. Values: `:closed_indefinitely`, `:closed_permanently`, `:operational`
  * `:arff_certification_type` - Airport ARFF Certification Type Code. Format is the class code ('I', 'II', 'III', or 'IV') followed by a one character code A, B, C, D, E, or L
  * `:npias_federal_agreements_code` - NPIAS/Federal Agreements Code. A Combination of 1 to 7 Codes that Indicate the Type of Federal Agreements existing at the Airport
  * `:airspace_analysis_determination` - Airport Airspace Analysis Determination
  * `:customs_entry_airport_flag` - Facility has been designated by the U.S. Department of Homeland Security as an International Airport of Entry for Customs (boolean)
  * `:customs_landing_rights_flag` - Facility has been designated by the U.S. Department of Homeland Security as a Customs Landing Rights Airport (boolean)
  * `:joint_use_agreement_flag` - Facility has Military/Civil Joint Use Agreement that allows Civil Operations at a Military Airport (boolean)
  * `:military_landing_rights_flag` - Airport has entered into an Agreement that Grants Landing Rights to the Military (boolean)
  * `:inspection_method_code` - Airport Inspection Method
  * `:agency_performing_inspection` - Agency/Group Performing Physical Inspection
  * `:last_inspection_date` - Last Physical Inspection Date (YYYY/MM/DD)
  * `:last_information_request_date` - Last Date Information Request was completed by Facility Owner or Manager (YYYY/MM/DD)
  * `:fuel_types` - Fuel Types available for public use at the Airport (list of fuel type strings)
  * `:airframe_repair_service` - Airframe Repair Service Availability/Type. Values: `:major`, `:minor`, `:none`
  * `:power_plant_repair_service` - Power Plant (Engine) Repair Availability/Type. Values: `:major`, `:minor`, `:none`
  * `:bottled_oxygen_type` - Type of Bottled Oxygen Available (Value represents High and/or Low Pressure Replacement Bottle). Values: `:high`, `:low`, `:high_low`, `:none`
  * `:bulk_oxygen_type` - Type of Bulk Oxygen Available (Value represents High and/or Low Pressure Cylinders). Values: `:high`, `:low`, `:high_low`, `:none`
  * `:lighting_schedule` - Airport Lighting Schedule value is the beginning-ending times (local time) that the Standard Airport Lights are operated
  * `:beacon_lighting_schedule` - Beacon Lighting Schedule value is the beginning-ending times (local time) that the Rotating Airport Beacon Light is operated
  * `:air_traffic_control_tower` - Air Traffic Control Tower Facility Type. Values: `:atct`, `:non_atct`, `:atct_approach`, `:atct_rapcon`, `:atct_ratcf`, `:atct_tracon`
  * `:segmented_circle_flag` - Segmented Circle Airport Marker System on the Airport. Values: `:yes`, `:no`, `:none`, `:yes_lighted`
  * `:beacon_lens_color` - Lens Color of Operable Beacon located on the Airport
  * `:landing_fee_flag` - Landing Fee charged to Non-Commercial Users of Airport (boolean)
  * `:medical_use_flag` - A "Y" in this field indicates that the Landing Facility Is used for Medical Purposes (boolean)
  * `:based_aircraft_single_engine` - Single Engine General Aviation Aircraft count
  * `:based_aircraft_multi_engine` - Multi Engine General Aviation Aircraft count
  * `:based_aircraft_jet_engine` - Jet Engine General Aviation Aircraft count
  * `:based_aircraft_helicopter` - General Aviation Helicopter count
  * `:based_aircraft_gliders` - Operational Gliders count
  * `:based_aircraft_military` - Operational Military Aircraft (Including Helicopters) count
  * `:based_aircraft_ultralight` - Ultralight Aircraft count
  * `:commercial_operations` - Commercial Services (Scheduled Operations by CAB-Certificated Carriers or Intrastate Carriers) count
  * `:commuter_operations` - Commuter Services Operations (Scheduled Commuter/Cargo Carriers) count
  * `:air_taxi_operations` - Air Taxi Operations (Air Taxi Operators Carrying Passengers, Mail, or Mail for Revenue) count
  * `:local_operations` - General Aviation Local Operations (Those Operating in the Local Traffic Pattern or Within a 20-Mile Radius of the Airport) count
  * `:itinerant_operations` - General Aviation Itinerant Operations (Those General Aviation Operations Excluding Commuter or Air Taxi Not qualifying as Local) count
  * `:military_operations` - Military Aircraft Operations count
  * `:operations_ending_date` - 12-Month Ending Date on which Annual Operations data in above six fields is based (YYYY/MM/DD)
  * `:airport_position_source` - Airport Position Source
  * `:airport_position_source_date` - Airport Position Source Date (YYYY/MM/DD)
  * `:airport_elevation_source` - Airport Elevation Source
  * `:airport_elevation_source_date` - Airport Elevation Source Date (YYYY/MM/DD)
  * `:contract_fuel_available_flag` - Contract Fuel Available (boolean)
  * `:transient_storage_buoy_flag` - Buoy Transient Storage Facilities (boolean)
  * `:transient_storage_hangar_flag` - Hangar Transient Storage Facilities (boolean)
  * `:transient_storage_tiedown_flag` - Tie-Down Transient Storage Facilities (boolean)
  * `:other_services` - Other Airport Services Available. A Comma-Separated List of Other Airport Services Available at the Airport
  * `:wind_indicator_flag` - Wind Indicator shows whether a Wind Indicator exists at the Airport. Values: `:no_wind_indicator`, `:unlighted_wind_indicator`, `:lighted_wind_indicator`
  * `:icao_id` - ICAO Identifier
  * `:minimum_operational_network` - Minimum Operational Network (MON)
  * `:user_fee_flag` - If Flag is checked in NASR, User Fee Airports Will Be Designated With Text "US CUSTOMS USER FEE ARPT." (boolean)
  * `:cold_temperature_altitude_correction` - Cold Temperature Airport. Altitude Correction Required At or Below Temperature Given in Celsius
  * `:eff_date` - The 28 Day NASR Subscription Effective Date in format 'YYYY/MM/DD'
  """
  import NASR.Utils

  defstruct ~w(
    site_no
    site_type_code
    arpt_id
    city
    state_code
    country_code
    region_code
    ado_code
    state_name
    county_name
    county_assoc_state
    arpt_name
    ownership_type_code
    facility_use_code
    latitude
    longitude
    survey_method_code
    elevation
    elevation_method_code
    magnetic_variation
    magnetic_hemisphere
    magnetic_variation_year
    traffic_pattern_altitude
    sectional_chart
    distance_from_city
    direction_from_city
    land_area_covered
    boundary_artcc_id
    boundary_artcc_computer_id
    boundary_artcc_name
    fss_on_facility_flag
    fss_id
    fss_name
    fss_phone_no
    fss_toll_free_no
    alt_fss_id
    alt_fss_name
    alt_fss_toll_free_no
    notam_facility_id
    notam_service_flag
    activation_date
    airport_status_code
    arff_certification_type
    npias_federal_agreements_code
    airspace_analysis_determination
    customs_entry_airport_flag
    customs_landing_rights_flag
    joint_use_agreement_flag
    military_landing_rights_flag
    inspection_method_code
    agency_performing_inspection
    last_inspection_date
    last_information_request_date
    fuel_types
    airframe_repair_service
    power_plant_repair_service
    bottled_oxygen_type
    bulk_oxygen_type
    lighting_schedule
    beacon_lighting_schedule
    air_traffic_control_tower
    segmented_circle_flag
    beacon_lens_color
    landing_fee_flag
    medical_use_flag
    based_aircraft_single_engine
    based_aircraft_multi_engine
    based_aircraft_jet_engine
    based_aircraft_helicopter
    based_aircraft_gliders
    based_aircraft_military
    based_aircraft_ultralight
    commercial_operations
    commuter_operations
    air_taxi_operations
    local_operations
    itinerant_operations
    military_operations
    operations_ending_date
    airport_position_source
    airport_position_source_date
    airport_elevation_source
    airport_elevation_source_date
    contract_fuel_available_flag
    transient_storage_buoy_flag
    transient_storage_hangar_flag
    transient_storage_tiedown_flag
    other_services
    wind_indicator_flag
    icao_id
    minimum_operational_network
    user_fee_flag
    cold_temperature_altitude_correction
    eff_date
  )a

  @type t() :: %__MODULE__{
          site_no: String.t(),
          site_type_code: :airport | :balloonport | :seaplane_base | :gliderport | :heliport | :ultralight | String.t() | nil,
          arpt_id: String.t(),
          city: String.t(),
          state_code: String.t(),
          country_code: String.t(),
          region_code: String.t(),
          ado_code: String.t(),
          state_name: String.t(),
          county_name: String.t(),
          county_assoc_state: String.t(),
          arpt_name: String.t(),
          ownership_type_code: :public | :private | :air_force | :navy | :army | :coast_guard | String.t() | nil,
          facility_use_code: :public | :private | String.t() | nil,
          latitude: float() | nil,
          longitude: float() | nil,
          survey_method_code: :estimated | :surveyed | String.t() | nil,
          elevation: float() | nil,
          elevation_method_code: :estimated | :surveyed | String.t() | nil,
          magnetic_variation: float() | nil,
          magnetic_hemisphere: String.t(),
          magnetic_variation_year: integer() | nil,
          traffic_pattern_altitude: integer() | nil,
          sectional_chart: String.t(),
          distance_from_city: float() | nil,
          direction_from_city: String.t(),
          land_area_covered: float() | nil,
          boundary_artcc_id: String.t(),
          boundary_artcc_computer_id: String.t(),
          boundary_artcc_name: String.t(),
          fss_on_facility_flag: boolean() | nil,
          fss_id: String.t(),
          fss_name: String.t(),
          fss_phone_no: String.t(),
          fss_toll_free_no: String.t(),
          alt_fss_id: String.t(),
          alt_fss_name: String.t(),
          alt_fss_toll_free_no: String.t(),
          notam_facility_id: String.t(),
          notam_service_flag: boolean() | nil,
          activation_date: Date.t() | nil,
          airport_status_code: :closed_indefinitely | :closed_permanently | :operational | String.t() | nil,
          arff_certification_type: String.t(),
          npias_federal_agreements_code: String.t(),
          airspace_analysis_determination: String.t(),
          customs_entry_airport_flag: boolean() | nil,
          customs_landing_rights_flag: boolean() | nil,
          joint_use_agreement_flag: boolean() | nil,
          military_landing_rights_flag: boolean() | nil,
          inspection_method_code: String.t(),
          agency_performing_inspection: String.t(),
          last_inspection_date: Date.t() | nil,
          last_information_request_date: Date.t() | nil,
          fuel_types: [String.t()],
          airframe_repair_service: :major | :minor | :none | String.t() | nil,
          power_plant_repair_service: :major | :minor | :none | String.t() | nil,
          bottled_oxygen_type: :high | :low | :high_low | :none | String.t() | nil,
          bulk_oxygen_type: :high | :low | :high_low | :none | String.t() | nil,
          lighting_schedule: String.t(),
          beacon_lighting_schedule: String.t(),
          air_traffic_control_tower: :atct | :non_atct | :atct_approach | :atct_rapcon | :atct_ratcf | :atct_tracon | String.t() | nil,
          segmented_circle_flag: :yes | :no | :none | :yes_lighted | String.t() | nil,
          beacon_lens_color: String.t(),
          landing_fee_flag: boolean() | nil,
          medical_use_flag: boolean() | nil,
          based_aircraft_single_engine: integer() | nil,
          based_aircraft_multi_engine: integer() | nil,
          based_aircraft_jet_engine: integer() | nil,
          based_aircraft_helicopter: integer() | nil,
          based_aircraft_gliders: integer() | nil,
          based_aircraft_military: integer() | nil,
          based_aircraft_ultralight: integer() | nil,
          commercial_operations: integer() | nil,
          commuter_operations: integer() | nil,
          air_taxi_operations: integer() | nil,
          local_operations: integer() | nil,
          itinerant_operations: integer() | nil,
          military_operations: integer() | nil,
          operations_ending_date: Date.t() | nil,
          airport_position_source: String.t(),
          airport_position_source_date: Date.t() | nil,
          airport_elevation_source: String.t(),
          airport_elevation_source_date: Date.t() | nil,
          contract_fuel_available_flag: boolean() | nil,
          transient_storage_buoy_flag: boolean() | nil,
          transient_storage_hangar_flag: boolean() | nil,
          transient_storage_tiedown_flag: boolean() | nil,
          other_services: [String.t()],
          wind_indicator_flag: :no_wind_indicator | :unlighted_wind_indicator | :lighted_wind_indicator | String.t() | nil,
          icao_id: String.t(),
          minimum_operational_network: String.t(),
          user_fee_flag: boolean() | nil,
          cold_temperature_altitude_correction: float() | nil,
          eff_date: Date.t() | nil
        }

  @spec new(map()) :: t()
  def new(entity) do
    %__MODULE__{
      site_no: Map.fetch!(entity, "SITE_NO"),
      site_type_code: parse_site_type_code(Map.fetch!(entity, "SITE_TYPE_CODE")),
      arpt_id: Map.fetch!(entity, "ARPT_ID"),
      city: Map.fetch!(entity, "CITY"),
      state_code: Map.fetch!(entity, "STATE_CODE"),
      country_code: Map.fetch!(entity, "COUNTRY_CODE"),
      region_code: Map.fetch!(entity, "REGION_CODE"),
      ado_code: Map.fetch!(entity, "ADO_CODE"),
      state_name: Map.fetch!(entity, "STATE_NAME"),
      county_name: Map.fetch!(entity, "COUNTY_NAME"),
      county_assoc_state: Map.fetch!(entity, "COUNTY_ASSOC_STATE"),
      arpt_name: Map.fetch!(entity, "ARPT_NAME"),
      ownership_type_code: parse_ownership_type_code(Map.fetch!(entity, "OWNERSHIP_TYPE_CODE")),
      facility_use_code: parse_facility_use_code(Map.fetch!(entity, "FACILITY_USE_CODE")),
      latitude: safe_str_to_float(Map.fetch!(entity, "LAT_DECIMAL")),
      longitude: safe_str_to_float(Map.fetch!(entity, "LONG_DECIMAL")),
      survey_method_code: parse_survey_method_code(Map.fetch!(entity, "SURVEY_METHOD_CODE")),
      elevation: safe_str_to_float(Map.fetch!(entity, "ELEV")),
      elevation_method_code: parse_elevation_method_code(Map.fetch!(entity, "ELEV_METHOD_CODE")),
      magnetic_variation: safe_str_to_float(Map.fetch!(entity, "MAG_VARN")),
      magnetic_hemisphere: Map.fetch!(entity, "MAG_HEMIS"),
      magnetic_variation_year: safe_str_to_int(Map.fetch!(entity, "MAG_VARN_YEAR")),
      traffic_pattern_altitude: safe_str_to_int(Map.fetch!(entity, "TPA")),
      sectional_chart: Map.fetch!(entity, "CHART_NAME"),
      distance_from_city: safe_str_to_float(Map.fetch!(entity, "DIST_CITY_TO_AIRPORT")),
      direction_from_city: Map.fetch!(entity, "DIRECTION_CODE"),
      land_area_covered: safe_str_to_float(Map.fetch!(entity, "ACREAGE")),
      boundary_artcc_id: Map.fetch!(entity, "RESP_ARTCC_ID"),
      boundary_artcc_computer_id: Map.fetch!(entity, "COMPUTER_ID"),
      boundary_artcc_name: Map.fetch!(entity, "ARTCC_NAME"),
      fss_on_facility_flag: convert_yn(Map.fetch!(entity, "FSS_ON_ARPT_FLAG")),
      fss_id: Map.fetch!(entity, "FSS_ID"),
      fss_name: Map.fetch!(entity, "FSS_NAME"),
      fss_phone_no: Map.fetch!(entity, "PHONE_NO"),
      fss_toll_free_no: Map.fetch!(entity, "TOLL_FREE_NO"),
      alt_fss_id: Map.fetch!(entity, "ALT_FSS_ID"),
      alt_fss_name: Map.fetch!(entity, "ALT_FSS_NAME"),
      alt_fss_toll_free_no: Map.fetch!(entity, "ALT_TOLL_FREE_NO"),
      notam_facility_id: Map.fetch!(entity, "NOTAM_ID"),
      notam_service_flag: convert_yn(Map.fetch!(entity, "NOTAM_FLAG")),
      activation_date: parse_date(Map.fetch!(entity, "ACTIVATION_DATE")),
      airport_status_code: parse_airport_status_code(Map.fetch!(entity, "ARPT_STATUS")),
      arff_certification_type: Map.fetch!(entity, "FAR_139_TYPE_CODE"),
      npias_federal_agreements_code: Map.fetch!(entity, "NASP_CODE"),
      airspace_analysis_determination: Map.fetch!(entity, "ASP_ANLYS_DTRM_CODE"),
      customs_entry_airport_flag: convert_yn(Map.fetch!(entity, "CUST_FLAG")),
      customs_landing_rights_flag: convert_yn(Map.fetch!(entity, "LNDG_RIGHTS_FLAG")),
      joint_use_agreement_flag: convert_yn(Map.fetch!(entity, "JOINT_USE_FLAG")),
      military_landing_rights_flag: convert_yn(Map.fetch!(entity, "MIL_LNDG_FLAG")),
      inspection_method_code: Map.fetch!(entity, "INSPECT_METHOD_CODE"),
      agency_performing_inspection: Map.fetch!(entity, "INSPECTOR_CODE"),
      last_inspection_date: parse_date(Map.fetch!(entity, "LAST_INSPECTION")),
      last_information_request_date: parse_date(Map.fetch!(entity, "LAST_INFO_RESPONSE")),
      fuel_types: parse_fuel_types(Map.fetch!(entity, "FUEL_TYPES")),
      airframe_repair_service: parse_repair_service(Map.fetch!(entity, "AIRFRAME_REPAIR_SER_CODE")),
      power_plant_repair_service: parse_repair_service(Map.fetch!(entity, "PWR_PLANT_REPAIR_SER")),
      bottled_oxygen_type: parse_oxygen_type(Map.fetch!(entity, "BOTTLED_OXY_TYPE")),
      bulk_oxygen_type: parse_oxygen_type(Map.fetch!(entity, "BULK_OXY_TYPE")),
      lighting_schedule: Map.fetch!(entity, "LGT_SKED"),
      beacon_lighting_schedule: Map.fetch!(entity, "BCN_LGT_SKED"),
      air_traffic_control_tower: parse_tower_type(Map.fetch!(entity, "TWR_TYPE_CODE")),
      segmented_circle_flag: parse_segmented_circle_flag(Map.fetch!(entity, "SEG_CIRCLE_MKR_FLAG")),
      beacon_lens_color: Map.fetch!(entity, "BCN_LENS_COLOR"),
      landing_fee_flag: convert_yn(Map.fetch!(entity, "LNDG_FEE_FLAG")),
      medical_use_flag: convert_yn(Map.fetch!(entity, "MEDICAL_USE_FLAG")),
      based_aircraft_single_engine: safe_str_to_int(Map.fetch!(entity, "BASED_SINGLE_ENG")),
      based_aircraft_multi_engine: safe_str_to_int(Map.fetch!(entity, "BASED_MULTI_ENG")),
      based_aircraft_jet_engine: safe_str_to_int(Map.fetch!(entity, "BASED_JET_ENG")),
      based_aircraft_helicopter: safe_str_to_int(Map.fetch!(entity, "BASED_HEL")),
      based_aircraft_gliders: safe_str_to_int(Map.fetch!(entity, "BASED_ GLIDERS")),
      based_aircraft_military: safe_str_to_int(Map.fetch!(entity, "BASED_ MIL_ACFT")),
      based_aircraft_ultralight: safe_str_to_int(Map.fetch!(entity, "BASED_ULTRALGT_ACFT")),
      commercial_operations: safe_str_to_int(Map.fetch!(entity, "COMMERCIAL_OPS")),
      commuter_operations: safe_str_to_int(Map.fetch!(entity, "COMMUTER_OPS")),
      air_taxi_operations: safe_str_to_int(Map.fetch!(entity, "AIR_TAXI_OPS")),
      local_operations: safe_str_to_int(Map.fetch!(entity, "LOCAL_OPS")),
      itinerant_operations: safe_str_to_int(Map.fetch!(entity, "ITNRNT_OPS")),
      military_operations: safe_str_to_int(Map.fetch!(entity, "MIL_ACFT_OPS")),
      operations_ending_date: parse_date(Map.fetch!(entity, "ANNUAL_OPS_DATE")),
      airport_position_source: Map.fetch!(entity, "ARPT_PSN_SOURCE"),
      airport_position_source_date: parse_date(Map.fetch!(entity, "POSITION_SRC_DATE")),
      airport_elevation_source: Map.fetch!(entity, "ARPT_ELEV_SOURCE"),
      airport_elevation_source_date: parse_date(Map.fetch!(entity, "ELEVATION_SRC_DATE")),
      contract_fuel_available_flag: convert_yn(Map.fetch!(entity, "CONTR_FUEL_AVBL")),
      transient_storage_buoy_flag: convert_yn(Map.fetch!(entity, "TRNS_STRG_BUOY_FLAG")),
      transient_storage_hangar_flag: convert_yn(Map.fetch!(entity, "TRNS_STRG_HGR_FLAG")),
      transient_storage_tiedown_flag: convert_yn(Map.fetch!(entity, "TRNS_STRG_TIE_FLAG")),
      other_services: parse_other_services(Map.fetch!(entity, "OTHER_SERVICES")),
      wind_indicator_flag: parse_wind_indicator_flag(Map.fetch!(entity, "WIND_INDCR_FLAG")),
      icao_id: Map.fetch!(entity, "ICAO_ID"),
      minimum_operational_network: Map.fetch!(entity, "MIN_OP_NETWORK"),
      user_fee_flag: convert_yn(Map.fetch!(entity, "USER_FEE_FLAG")),
      cold_temperature_altitude_correction: safe_str_to_float(Map.fetch!(entity, "CTA")),
      eff_date: parse_date(Map.fetch!(entity, "EFF_DATE"))
    }
  end

  @spec type() :: String.t()
  def type(), do: "APT_BASE"

  defp parse_site_type_code(nil), do: nil
  defp parse_site_type_code(""), do: nil
  defp parse_site_type_code(code) when is_binary(code) do
    case String.trim(code) do
      "A" -> :airport
      "B" -> :balloonport
      "C" -> :seaplane_base
      "G" -> :gliderport
      "H" -> :heliport
      "U" -> :ultralight
      other -> other
    end
  end

  defp parse_ownership_type_code(nil), do: nil
  defp parse_ownership_type_code(""), do: nil
  defp parse_ownership_type_code(code) when is_binary(code) do
    case String.trim(code) do
      "PU" -> :public
      "PR" -> :private
      "MA" -> :air_force
      "MN" -> :navy
      "MR" -> :army
      "CG" -> :coast_guard
      other -> other
    end
  end

  defp parse_facility_use_code(nil), do: nil
  defp parse_facility_use_code(""), do: nil
  defp parse_facility_use_code(code) when is_binary(code) do
    case String.trim(code) do
      "PU" -> :public
      "PR" -> :private
      other -> other
    end
  end

  defp parse_survey_method_code(nil), do: nil
  defp parse_survey_method_code(""), do: nil
  defp parse_survey_method_code(code) when is_binary(code) do
    case String.trim(code) do
      "E" -> :estimated
      "S" -> :surveyed
      other -> other
    end
  end

  defp parse_elevation_method_code(nil), do: nil
  defp parse_elevation_method_code(""), do: nil
  defp parse_elevation_method_code(code) when is_binary(code) do
    case String.trim(code) do
      "E" -> :estimated
      "S" -> :surveyed
      other -> other
    end
  end

  defp parse_airport_status_code(nil), do: nil
  defp parse_airport_status_code(""), do: nil
  defp parse_airport_status_code(code) when is_binary(code) do
    case String.trim(code) do
      "CI" -> :closed_indefinitely
      "CP" -> :closed_permanently
      "O" -> :operational
      other -> other
    end
  end

  defp parse_fuel_types(nil), do: []
  defp parse_fuel_types(""), do: []
  defp parse_fuel_types(fuels) when is_binary(fuels) do
    fuels
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
  end

  defp parse_repair_service(nil), do: nil
  defp parse_repair_service(""), do: nil
  defp parse_repair_service(service) when is_binary(service) do
    case String.trim(service) do
      "MAJOR" -> :major
      "MINOR" -> :minor
      "NONE" -> :none
      other -> other
    end
  end

  defp parse_oxygen_type(nil), do: nil
  defp parse_oxygen_type(""), do: nil
  defp parse_oxygen_type(type) when is_binary(type) do
    case String.trim(type) do
      "HIGH" -> :high
      "LOW" -> :low
      "HIGH/LOW" -> :high_low
      "NONE" -> :none
      other -> other
    end
  end

  defp parse_tower_type(nil), do: nil
  defp parse_tower_type(""), do: nil
  defp parse_tower_type(type) when is_binary(type) do
    case String.trim(type) do
      "ATCT" -> :atct
      "NON-ATCT" -> :non_atct
      "ATCT-A/C" -> :atct_approach
      "ATCT-RAPCON" -> :atct_rapcon
      "ATCT-RATCF" -> :atct_ratcf
      "ATCT-TRACON" -> :atct_tracon
      other -> other
    end
  end

  defp parse_segmented_circle_flag(nil), do: nil
  defp parse_segmented_circle_flag(""), do: nil
  defp parse_segmented_circle_flag(flag) when is_binary(flag) do
    case String.trim(flag) do
      "Y" -> :yes
      "N" -> :no
      "NONE" -> :none
      "Y-L" -> :yes_lighted
      other -> other
    end
  end

  defp parse_other_services(nil), do: []
  defp parse_other_services(""), do: []
  defp parse_other_services(services) when is_binary(services) do
    services
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
  end

  defp parse_wind_indicator_flag(nil), do: nil
  defp parse_wind_indicator_flag(""), do: nil
  defp parse_wind_indicator_flag(flag) when is_binary(flag) do
    case String.trim(flag) do
      "N" -> :no_wind_indicator
      "Y" -> :unlighted_wind_indicator
      "Y-L" -> :lighted_wind_indicator
      other -> other
    end
  end
end