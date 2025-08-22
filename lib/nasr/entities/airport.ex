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

  * `:site_id` - Landing Facility Site Number combined with the Site Type. A unique identifying number.
  * `:site_no` - Landing Facility Site Number
  * `:site_type` - Landing Facility Type. Values: `:airport`, `:balloonport`, `:seaplane_base`, `:gliderport`, `:heliport`, `:ultralight`
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
  * `:ownership_type` - Airport Ownership Type. Values: `:public`, `:private`, `:air_force`, `:navy`, `:army`, `:coast_guard`
  * `:facility_use` - Facility Use. Values: `:public`, `:private`
  * `:latitude` - Airport Reference Point Latitude in Decimal Format
  * `:longitude` - Airport Reference Point Longitude in Decimal Format
  * `:survey_method` - Airport Reference Point Determination Method. Values: `:estimated`, `:surveyed`
  * `:elevation` - Airport Elevation (Nearest Tenth of a Foot MSL). Elevation is measured at the highest point on the centerline of the usable landing surface
  * `:elevation_method` - Airport Elevation Determination Method. Values: `:estimated`, `:surveyed`
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
  * `:fss_on_facility` - Tie-In FSS Physically Located On Facility (boolean)
  * `:fss_id` - Tie-In Flight Service Station (FSS) Identifier
  * `:fss_name` - Tie-In FSS Name
  * `:fss_phone_no` - Local Phone Number from Airport to FSS for Administrative Services
  * `:fss_toll_free_no` - Toll Free Phone Number from Airport to FSS for Pilot Briefing Services
  * `:alt_fss_id` - Alternate FSS Identifier provides the identifier of a full-time Flight Service Station that assumes responsibility for the Airport during the off hours of a part-time primary FSS
  * `:alt_fss_name` - Alternate FSS Name
  * `:alt_fss_toll_free_no` - Toll Free Phone Number from Airport to Alternate FSS for Pilot Briefing Services
  * `:notam_facility_id` - Identifier of the Facility responsible for issuing Notices to Airmen (NOTAMS) and Weather information for the Airport
  * `:notam_service` - Availability of NOTAM 'D' Service at Airport (boolean)
  * `:activation_date` - Airport Activation Date (YYYY/MM) provides the YEAR and MONTH that the Facility was added to the NFDC airport database
  * `:airport_status` - Airport Status. Values: `:closed_indefinitely`, `:closed_permanently`, `:operational`
  * `:arff_certification_type` - Airport ARFF Certification Type Code. Format is the class code ('I', 'II', 'III', or 'IV') followed by a one character code A, B, C, D, E, or L
  * `:npias_federal_agreements_code` - NPIAS/Federal Agreements Code. A Combination of 1 to 7 Codes that Indicate the Type of Federal Agreements existing at the Airport
  * `:airspace_analysis_determination` - Airport Airspace Analysis Determination
  * `:customs_entry_airport` - Facility has been designated by the U.S. Department of Homeland Security as an International Airport of Entry for Customs (boolean)
  * `:customs_landing_rights` - Facility has been designated by the U.S. Department of Homeland Security as a Customs Landing Rights Airport (boolean)
  * `:joint_use_agreement` - Facility has Military/Civil Joint Use Agreement that allows Civil Operations at a Military Airport (boolean)
  * `:military_landing_rights` - Airport has entered into an Agreement that Grants Landing Rights to the Military (boolean)
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
  * `:tower_type` - Air Traffic Control Tower Facility Type. Values: `:atct`, `:non_atct`, `:atct_approach`, `:atct_rapcon`, `:atct_ratcf`, `:atct_tracon`
  * `:segmented_circle_flag` - Segmented Circle Airport Marker System on the Airport. Values: `:yes`, `:no`, `:none`, `:yes_lighted`
  * `:beacon_lens_color` - Lens Color of Operable Beacon located on the Airport
  * `:landing_fee` - Landing Fee charged to Non-Commercial Users of Airport (boolean)
  * `:medical_use` - A "Y" in this field indicates that the Landing Facility Is used for Medical Purposes (boolean)
  * `:airport_position_source` - Airport Position Source
  * `:airport_position_source_date` - Airport Position Source Date (YYYY/MM/DD)
  * `:airport_elevation_source` - Airport Elevation Source
  * `:airport_elevation_source_date` - Airport Elevation Source Date (YYYY/MM/DD)
  * `:contract_fuel_available` - Contract Fuel Available (boolean)
  * `:transient_storage_buoy` - Buoy Transient Storage Facilities (boolean)
  * `:transient_storage_hangar` - Hangar Transient Storage Facilities (boolean)
  * `:transient_storage_tiedown` - Tie-Down Transient Storage Facilities (boolean)
  * `:other_services` - Other Airport Services Available. A Comma-Separated List of Other Airport Services Available at the Airport
  * `:wind_indicator` - Wind Indicator shows whether a Wind Indicator exists at the Airport. Values: `:no_wind_indicator`, `:unlighted_wind_indicator`, `:lighted_wind_indicator`
  * `:icao_id` - ICAO Identifier
  * `:minimum_operational_network` - Minimum Operational Network (MON)
  * `:user_fee` - If Flag is checked in NASR, User Fee Airports Will Be Designated With Text "US CUSTOMS USER FEE ARPT." (boolean)
  * `:cold_temperature_altitude_correction` - Cold Temperature Airport. Altitude Correction Required At or Below Temperature Given in Celsius
  * `:effective_date` - The 28 Day NASR Subscription Effective Date in format 'YYYY/MM/DD'
  """
  import NASR.Utils

  defstruct ~w(
    site_id
    site_no
    site_type
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
    ownership_type
    facility_use
    latitude
    longitude
    survey_method
    elevation
    elevation_method
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
    fss_on_facility
    fss_id
    fss_name
    fss_phone_no
    fss_toll_free_no
    alt_fss_id
    alt_fss_name
    alt_fss_toll_free_no
    notam_facility_id
    notam_service
    activation_date
    airport_status
    arff_certification_type
    npias_federal_agreements_code
    airspace_analysis_determination
    customs_entry_airport
    customs_landing_rights
    joint_use_agreement
    military_landing_rights
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
    tower_type
    segmented_circle_flag
    beacon_lens_color
    landing_fee
    medical_use
    airport_position_source
    airport_position_source_date
    airport_elevation_source
    airport_elevation_source_date
    contract_fuel_available
    transient_storage_buoy
    transient_storage_hangar
    transient_storage_tiedown
    other_services
    wind_indicator
    icao_id
    minimum_operational_network
    user_fee
    cold_temperature_altitude_correction
    effective_date
  )a

  @type t() :: %__MODULE__{
          site_id: String.t(),
          site_no: String.t(),
          site_type: :airport | :balloonport | :seaplane_base | :gliderport | :heliport | :ultralight | String.t() | nil,
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
          ownership_type: :public | :private | :air_force | :navy | :army | :coast_guard | String.t() | nil,
          facility_use: :public | :private | String.t() | nil,
          latitude: float() | nil,
          longitude: float() | nil,
          survey_method: :estimated | :surveyed | String.t() | nil,
          elevation: float() | nil,
          elevation_method: :estimated | :surveyed | String.t() | nil,
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
          fss_on_facility: boolean() | nil,
          fss_id: String.t(),
          fss_name: String.t(),
          fss_phone_no: String.t(),
          fss_toll_free_no: String.t(),
          alt_fss_id: String.t(),
          alt_fss_name: String.t(),
          alt_fss_toll_free_no: String.t(),
          notam_facility_id: String.t(),
          notam_service: boolean() | nil,
          activation_date: Date.t() | nil,
          airport_status: :closed_indefinitely | :closed_permanently | :operational | String.t() | nil,
          arff_certification_type: String.t(),
          npias_federal_agreements_code: String.t(),
          airspace_analysis_determination: String.t(),
          customs_entry_airport: boolean() | nil,
          customs_landing_rights: boolean() | nil,
          joint_use_agreement: boolean() | nil,
          military_landing_rights: boolean() | nil,
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
          tower_type: :atct | :non_atct | :atct_approach | :atct_rapcon | :atct_ratcf | :atct_tracon | String.t() | nil,
          segmented_circle_flag: :yes | :no | :none | :yes_lighted | String.t() | nil,
          beacon_lens_color: String.t(),
          landing_fee: boolean() | nil,
          medical_use: boolean() | nil,
          airport_position_source: String.t(),
          airport_position_source_date: Date.t() | nil,
          airport_elevation_source: String.t(),
          airport_elevation_source_date: Date.t() | nil,
          contract_fuel_available: boolean() | nil,
          transient_storage_buoy: boolean() | nil,
          transient_storage_hangar: boolean() | nil,
          transient_storage_tiedown: boolean() | nil,
          other_services: [String.t()],
          wind_indicator: :no_wind_indicator | :unlighted_wind_indicator | :lighted_wind_indicator | String.t() | nil,
          icao_id: String.t(),
          minimum_operational_network: String.t(),
          user_fee: boolean() | nil,
          cold_temperature_altitude_correction: float() | nil,
          effective_date: Date.t() | nil
        }

  @spec new(map()) :: t()
  def new(entity) do
    %__MODULE__{
      site_id: Map.get(entity, "SITE_NO") <> "*" <> Map.get(entity, "SITE_TYPE_CODE"),
      site_no: Map.get(entity, "SITE_NO"),
      site_type: parse_site_type_code(Map.get(entity, "SITE_TYPE_CODE")),
      arpt_id: Map.get(entity, "ARPT_ID"),
      city: Map.get(entity, "CITY"),
      state_code: Map.get(entity, "STATE_CODE"),
      country_code: Map.get(entity, "COUNTRY_CODE"),
      region_code: Map.get(entity, "REGION_CODE"),
      ado_code: Map.get(entity, "ADO_CODE"),
      state_name: Map.get(entity, "STATE_NAME"),
      county_name: Map.get(entity, "COUNTY_NAME"),
      county_assoc_state: Map.get(entity, "COUNTY_ASSOC_STATE"),
      arpt_name: Map.get(entity, "ARPT_NAME"),
      ownership_type: parse_ownership_type_code(Map.get(entity, "OWNERSHIP_TYPE_CODE")),
      facility_use: parse_facility_use_code(Map.get(entity, "FACILITY_USE_CODE")),
      latitude: safe_str_to_float(Map.get(entity, "LAT_DECIMAL")),
      longitude: safe_str_to_float(Map.get(entity, "LONG_DECIMAL")),
      survey_method: parse_survey_method_code(Map.get(entity, "SURVEY_METHOD_CODE")),
      elevation: safe_str_to_float(Map.get(entity, "ELEV")),
      elevation_method: parse_elevation_method_code(Map.get(entity, "ELEV_METHOD_CODE")),
      magnetic_variation: safe_str_to_float(Map.get(entity, "MAG_VARN")),
      magnetic_hemisphere: Map.get(entity, "MAG_HEMIS"),
      magnetic_variation_year: safe_str_to_int(Map.get(entity, "MAG_VARN_YEAR")),
      traffic_pattern_altitude: safe_str_to_int(Map.get(entity, "TPA")),
      sectional_chart: Map.get(entity, "CHART_NAME"),
      distance_from_city: safe_str_to_float(Map.get(entity, "DIST_CITY_TO_AIRPORT")),
      direction_from_city: Map.get(entity, "DIRECTION_CODE"),
      land_area_covered: safe_str_to_float(Map.get(entity, "ACREAGE")),
      boundary_artcc_id: Map.get(entity, "RESP_ARTCC_ID"),
      boundary_artcc_computer_id: Map.get(entity, "COMPUTER_ID"),
      boundary_artcc_name: Map.get(entity, "ARTCC_NAME"),
      fss_on_facility: convert_yn(Map.get(entity, "FSS_ON_ARPT_FLAG")),
      fss_id: Map.get(entity, "FSS_ID"),
      fss_name: Map.get(entity, "FSS_NAME"),
      fss_phone_no: Map.get(entity, "PHONE_NO"),
      fss_toll_free_no: Map.get(entity, "TOLL_FREE_NO"),
      alt_fss_id: Map.get(entity, "ALT_FSS_ID"),
      alt_fss_name: Map.get(entity, "ALT_FSS_NAME"),
      alt_fss_toll_free_no: Map.get(entity, "ALT_TOLL_FREE_NO"),
      notam_facility_id: Map.get(entity, "NOTAM_ID"),
      notam_service: convert_yn(Map.get(entity, "NOTAM_FLAG")),
      activation_date: parse_date(Map.get(entity, "ACTIVATION_DATE")),
      airport_status: parse_airport_status_code(Map.get(entity, "ARPT_STATUS")),
      arff_certification_type: Map.get(entity, "FAR_139_TYPE_CODE"),
      npias_federal_agreements_code: Map.get(entity, "NASP_CODE"),
      airspace_analysis_determination: Map.get(entity, "ASP_ANLYS_DTRM_CODE"),
      customs_entry_airport: convert_yn(Map.get(entity, "CUST_FLAG")),
      customs_landing_rights: convert_yn(Map.get(entity, "LNDG_RIGHTS_FLAG")),
      joint_use_agreement: convert_yn(Map.get(entity, "JOINT_USE_FLAG")),
      military_landing_rights: convert_yn(Map.get(entity, "MIL_LNDG_FLAG")),
      inspection_method_code: Map.get(entity, "INSPECT_METHOD_CODE"),
      agency_performing_inspection: Map.get(entity, "INSPECTOR_CODE"),
      last_inspection_date: parse_date(Map.get(entity, "LAST_INSPECTION")),
      last_information_request_date: parse_date(Map.get(entity, "LAST_INFO_RESPONSE")),
      fuel_types: parse_fuel_types(Map.get(entity, "FUEL_TYPES")),
      airframe_repair_service: parse_repair_service(Map.get(entity, "AIRFRAME_REPAIR_SER_CODE")),
      power_plant_repair_service: parse_repair_service(Map.get(entity, "PWR_PLANT_REPAIR_SER")),
      bottled_oxygen_type: parse_oxygen_type(Map.get(entity, "BOTTLED_OXY_TYPE")),
      bulk_oxygen_type: parse_oxygen_type(Map.get(entity, "BULK_OXY_TYPE")),
      lighting_schedule: Map.get(entity, "LGT_SKED"),
      beacon_lighting_schedule: Map.get(entity, "BCN_LGT_SKED"),
      tower_type: parse_tower_type(Map.get(entity, "TWR_TYPE_CODE")),
      segmented_circle_flag: parse_segmented_circle_flag(Map.get(entity, "SEG_CIRCLE_MKR_FLAG")),
      beacon_lens_color: Map.get(entity, "BCN_LENS_COLOR"),
      landing_fee: convert_yn(Map.get(entity, "LNDG_FEE_FLAG")),
      medical_use: convert_yn(Map.get(entity, "MEDICAL_USE_FLAG")),
      airport_position_source: Map.get(entity, "ARPT_PSN_SOURCE"),
      airport_position_source_date: parse_date(Map.get(entity, "POSITION_SRC_DATE")),
      airport_elevation_source: Map.get(entity, "ARPT_ELEV_SOURCE"),
      airport_elevation_source_date: parse_date(Map.get(entity, "ELEVATION_SRC_DATE")),
      contract_fuel_available: convert_yn(Map.get(entity, "CONTR_FUEL_AVBL")),
      transient_storage_buoy: convert_yn(Map.get(entity, "TRNS_STRG_BUOY_FLAG")),
      transient_storage_hangar: convert_yn(Map.get(entity, "TRNS_STRG_HGR_FLAG")),
      transient_storage_tiedown: convert_yn(Map.get(entity, "TRNS_STRG_TIE_FLAG")),
      other_services: parse_other_services(Map.get(entity, "OTHER_SERVICES")),
      wind_indicator: parse_wind_indicator_flag(Map.get(entity, "WIND_INDCR_FLAG")),
      icao_id: Map.get(entity, "ICAO_ID"),
      minimum_operational_network: Map.get(entity, "MIN_OP_NETWORK"),
      user_fee: convert_yn(Map.get(entity, "USER_FEE_FLAG")),
      cold_temperature_altitude_correction: safe_str_to_float(Map.get(entity, "CTA")),
      effective_date: parse_date(Map.get(entity, "EFF_DATE"))
    }
  end

  @spec type() :: String.t()
  def type, do: "APT_BASE"

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
