defmodule NASR.EntitiesTest do
  use ExUnit.Case

  describe "from_raw/1" do
    test "creates ILS1 (ILSBaseData) entity from raw map" do
      raw_data = %{
        type: :ils1,
        record_type_indicator: "ILS1",
        blank: "",
        information_effective_date_mm_dd_yyyy: "08/07/2025",
        airport_site_number_identifier_ex_04508_a: "00128.*A",
        ils_runway_end_identifier_ex_18_36l: "05",
        ils_system_type: "ILS",
        identification_code_of_ils: "I-ANB",
        airport_name_ex_chicago_o_hare_intl: "ANNISTON RGNL",
        associated_city_ex_chicago: "ANNISTON",
        two_letter_post_office_code_for_the_state: "AL",
        state_name_ex_illinois: "ALABAMA",
        faa_region_code_example_ace_central: "ASO",
        airport_identifier: "ANB",
        ils_runway_length_in_whole_feet_ex_4000: "7000",
        ils_runway_width_in_whole_feet_ex_100: "150",
        category_of_the_ils_i_ii_iiia: "I",
        name_of_owner_of_the_facility_ex_u_s_navy: "FEDERAL AVIATION ADMIN.",
        name_of_the_ils_facility_operator: "FEDERAL AVIATION ADMIN.",
        ils_approach_bearing_in_degrees_magnetic: "052.45",
        the_magnetic_variation_at_the_ils_facility: "04W"
      }

      result = NASR.Entities.from_raw(raw_data)

      assert %NASR.Entities.ILSBaseData{} = result
      assert result.airport_site_number == "00128.*A"
      assert result.ils_system_type == :ils
      assert result.identification_code == "I-ANB"
    end

    test "creates ILS2 (ILSLocalizerData) entity from raw map" do
      raw_data = %{
        type: :ils2,
        record_type_indicator: "ILS2",
        blank: "",
        airport_site_number_identifier_ex_04508_a: "00128.*A",
        ils_runway_end_identifier_ex_18_36l: "05",
        ils_system_type_see_ils1_record_type_for_list: "ILS",
        status_of_localizer_operational_ifr: "OPERATIONAL IFR",
        date_of_localizer_operational_status: "08/07/2025",
        latitude_of_localizer_antenna_formatted: "33-35-14.2500N",
        latitude_of_localizer_antenna_all_seconds: "121514.2500N",
        longitude_of_localizer_antenna_formatted: "085-51-25.8800W",
        longitude_of_localizer_antenna_all_seconds: "3051258800W",
        indicating_source_of_latitude_longitude: "F",
        distance_of_localizer_antenna: "500",
        of_localizer_antenna_from_runway: "100",
        indicating_source_of_distance: "F",
        elevation_of_localizer_antenna: "612.1",
        localizer_frequency_mhz_ex_108_10: "111.50",
        back_course_status_restricted: "",
        localizer_course_width_degrees_and_hundredths: "3.0",
        course_width_at_threshold: "700",
        localizer_distance_from_stop_end_of_rwy_feet: "1000",
        direction_from_stop_end_of_rwy: "L",
        services_code: "NV"
      }

      result = NASR.Entities.from_raw(raw_data)

      assert %NASR.Entities.ILSLocalizerData{} = result
      assert result.airport_site_number == "00128.*A"
      assert result.ils_system_type == :ils
      assert result.operational_status == :operational_ifr
    end

    test "creates ILS3 (ILSGlideSlopeData) entity from raw map" do
      raw_data = %{
        type: :ils3,
        record_type_indicator: "ILS3",
        blank: "",
        airport_site_number_identifier_ex_04508_a: "00128.*A",
        ils_runway_end_identifier_ex_18_36l: "05",
        ils_system_type_see_ils1_record_type_for_list: "ILS",
        indicating_source_of_latitude_longitude: "K",
        indicating_source_of_distance: "",
        status_of_glide_slope_operational_ifr: "OPERATIONAL IFR",
        date_of_glide_slope_operational_status: "08/07/2025",
        latitude_of_glide_slope_transmitter_antenna: "121514.2500N",
        longitude_of_glide_slope_transmitter_antenna: "3051258800W",
        distance_of_glide_slope_transmitter_antenna: "",
        of_glide_slope_transmitter_antenna: "",
        elevation_of_glide_slope_transmitter_antenna: "590.8",
        glide_slope_class_type: "GLIDE SLOPE",
        glide_slope_angle_in_degrees: "3.00",
        glide_slope_transmission_frequency: "332.90",
        elevation_of_runway_at_point_adjacent_to_the: ""
      }

      result = NASR.Entities.from_raw(raw_data)

      assert %NASR.Entities.ILSGlideSlopeData{} = result
      assert result.airport_site_number == "00128.*A"
      assert result.ils_system_type == :ils
      assert result.glide_slope_class_type == :glide_slope
      assert result.glide_slope_angle == 3.0
    end

    test "creates ILS4 (ILSDMEData) entity from raw map" do
      raw_data = %{
        type: :ils4,
        record_type_indicator: "ILS4",
        blank: "",
        airport_site_number_identifier_ex_04508_a: "00128.*A",
        ils_runway_end_identifier_ex_18_36l: "05",
        ils_system_type_see_ils1_record_type_for_list: "ILS",
        indicating_source_of_latitude_longitude: "F",
        indicating_source_of_distance: "",
        status_of_dme_operational_ifr: "OPERATIONAL IFR",
        date_of_dme_operational_status: "08/07/2025",
        latitude_of_dme_transponder_antenna: "121514.2500N",
        longitude_of_dme_transponder_antenna: "3051258800W",
        distance_of_dme_transmitter_antenna: "",
        of_dme_transponder_antenna: "",
        elevation_of_dme_transponder_antenna: "779",
        channel_on_which_distance_data_is_transmitted: "20X",
        distance_of_dme: ""
      }

      result = NASR.Entities.from_raw(raw_data)

      assert %NASR.Entities.ILSDMEData{} = result
      assert result.airport_site_number == "00128.*A"
      assert result.ils_system_type == :ils
      assert result.dme_channel == "20X"
    end

    test "creates ILS5 (ILSMarkerBeaconData) entity from raw map" do
      raw_data = %{
        type: :ils5,
        record_type_indicator: "ILS5",
        blank: "",
        airport_site_number_identifier_ex_04508_a: "00128.*A",
        ils_runway_end_identifier_ex_18_36l: "05",
        ils_system_type_see_ils1_record_type_for_list: "ILS",
        indicating_source_of_latitude_longitude: "K",
        indicating_source_of_distance: "",
        marker_type_im___inner_marker_mm___middle: "OM",
        status_of_marker_beacon_operational: "OPERATIONAL IFR",
        date_of_marker_beacon_operational_status: "08/07/2025",
        latitude_of_marker_beacon_formatted: "33-34-36.798N",
        latitude_of_marker_beacon_all_seconds: "121514.2500N",
        longitude_of_marker_beacon_formatted: "085-52-23.984W",
        longitude_of_marker_beacon_all_seconds: "3051258800W",
        distance_of_marker_beacon: "",
        of_marker_beacon: "",
        elevation_of_marker_beacon: "590",
        facility_type_of_marker_locator: "MARKER",
        location_identifier_of_beacon_at_marker: "NB",
        name_of_the_marker_locator_beacon: "",
        frequency_of_locator_beacon_at_middle_marker: "",
        identifier_navaid_type_of_navigation: "",
        powered_ndb_status_of_marker_beacon: "",
        provided_by_marker: ""
      }

      result = NASR.Entities.from_raw(raw_data)

      assert %NASR.Entities.ILSMarkerBeaconData{} = result
      assert result.airport_site_number == "00128.*A"
      assert result.ils_system_type == :ils
      assert result.marker_type == :outer_marker
    end

    test "creates ILS6 (ILSRemarks) entity from raw map" do
      raw_data = %{
        type: :ils6,
        record_type_indicator: "ILS6",
        airport_site_number_identifier: "00128.*A",
        ils_runway_end_identifier: "05",
        ils_system_type_see_ils1_record_for_description: "ILS",
        ils_remarks_free_form_text: "ILS CRITICAL AREA NOT DEFINED."
      }

      result = NASR.Entities.from_raw(raw_data)

      assert %NASR.Entities.ILSRemarks{} = result
      assert result.airport_site_number == "00128.*A"
      assert result.ils_system_type == :ils
      assert result.remarks_text == "ILS CRITICAL AREA NOT DEFINED."
    end

    test "creates PFR1 (PreferredRouteData) entity from raw map" do
      raw_data = %{
        type: :pfr1,
        record_type_indicator: "PFR1",
        origin_facility_location_identifier: "ABE",
        destination_facility_location_identifier: "ACY",
        type_of_preferred_route_code: "TEC",
        route_identifier_sequence_number_1_99: "1",
        type_of_preferred_route_description: "TOWER ENROUTE CONTROL",
        preferred_route_area_description: "",
        preferred_route_altitude_description: "5000",
        aircraft_allowed_limitations_description: "",
        effective_hours_gmt_description_1: "",
        effective_hours_gmt_description_2: "",
        effective_hours_gmt_description_3: "",
        route_direction_limitations_description: "",
        nar_type_common_non_common: "",
        designator: "",
        destination_city: ""
      }

      result = NASR.Entities.from_raw(raw_data)

      assert %NASR.Entities.PreferredRouteData{} = result
      assert result.origin_facility_location_identifier == "ABE"
      assert result.destination_facility_location_identifier == "ACY"
      assert result.type_of_preferred_route_code == "TEC"
    end

    test "creates PFR2 (PreferredRouteSegment) entity from raw map" do
      raw_data = %{
        type: :pfr2,
        navaid_facility_type_described: "VORTAC",
        record_type_indicator: "PFR2",
        blank: "",
        icao_region_code: "",
        origin_facility_location_identifier: "ABE",
        destination_facility_location_identifier: "ACY",
        type_of_preferred_route_code: "TEC",
        route_identifier_sequence_number_1_99: "1",
        segment_sequence_number_within_the_route: "005",
        segment_identifier_navaid_ident_awy_number: "FJC",
        segment_type_described: "NAVAID",
        fix_state_code___post_office_alpha_code: "",
        navaid_facility_type_code: "C",
        radial_and_distance_from_navaid: ""
      }

      result = NASR.Entities.from_raw(raw_data)

      assert %NASR.Entities.PreferredRouteSegment{} = result
      assert result.origin_facility_location_identifier == "ABE"
      assert result.segment_identifier_navaid_ident_awy_number == "FJC"
      assert result.segment_type_described == "NAVAID"
    end

    test "creates PJA1 (ParachuteJumpAreaData) entity from raw map" do
      raw_data = %{
        type: :pja1,
        record_type_indicator: "PJA1",
        navaid_facility_type_described: "VOR/DME",
        pja_id: "PAK005",
        navaid_identifier_ex_scy: "TED",
        navaid_facility_type_code_ex_c: "D",
        azimuth_degrees_from_navaid_000_0_359_99: "034.44",
        distance_in_nautical_miles_from_navaid: "14.4",
        navaid_name: "ANCHORAGE",
        pja_state_abbreviation_two_letter_post_office: "AK",
        pja_state_name: "ALASKA",
        pja_associated_city_name: "ANCHORAGE",
        pja_latitude_formatted: "61-18-47.4645N",
        pja_latitude_seconds: "220727.4645N",
        pja_longitude_formatted: "149-33-55.9086W",
        pja_longitude_seconds: "538435.9086W",
        associated_airport_name: "",
        associated_airport_site_number: "",
        pja_drop_zone_name: "",
        pja_maximum_altitude_allowed: "12500MSL",
        pja_area_radius_in_nautical_miles_from: "",
        sectional_charting_required_yes_no: "NO",
        area_to_be_published_in_airport_facility: "YES",
        additional_descriptive_text_for_area: "",
        associated_fss_ident: "ENA",
        associated_fss_name: "KENAI",
        pja_use: "",
        volume: ""
      }

      result = NASR.Entities.from_raw(raw_data)

      assert %NASR.Entities.ParachuteJumpAreaData{} = result
      assert result.pja_id == "PAK005"
      assert result.navaid_identifier == "TED"
      assert result.state == "AK"
    end

    test "creates USA (LocationIdentifier) entity from raw map" do
      raw_data = %{
        type: :usa,
        blanks: "",
        landing_facility_type: "AIRPORT",
        location_identifier: "A05",
        tie_in_flight_service_station_fss_identifier: "",
        identifier_group_sort_code: "1",
        identifier_group_code: "USA",
        faa_region_associated_with_the_location_identifier: "ANM",
        state_associated_with_the_location_identifier: "ID",
        city_associated_with_the_location_identifier: "DIXIE",
        controlling_artcc_for_this_location: "ZSE",
        controlling_artcc_for_this_location___computer_id: "ZCS",
        landing_facility_name: "DIXIE USFS",
        navaid_facility_name_1: "",
        navaid_facility_type_1: "",
        navaid_facility_name_2: "",
        navaid_facility_type_2: "",
        navaid_facility_name_3: "",
        navaid_facility_type_3: "",
        navaid_facility_name_4: "",
        navaid_facility_type_4: "",
        ils_runway_end_ex_08_18r_36l: "",
        ils_facility_type: "",
        location_identifier_of_ils_airport: "",
        ils_airport_name: "",
        fss_name: "",
        artcc_name: "",
        artcc_facility_type: "",
        flight_watch_station_fltwo_indicator: "",
        other_facility___facility_name_description: "",
        other_facility___facility_type: "",
        effective_date_of_this_information_mm_dd_yyyy: "08/15/2025"
      }

      result = NASR.Entities.from_raw(raw_data)

      assert %NASR.Entities.LocationIdentifier{} = result
      assert result.location_identifier == "A05"
      assert result.facility_type == "AIRPORT"
      assert result.state == "ID"
    end

    test "creates NAV1 (NavigationAidBaseData) entity from raw map" do
      raw_data = %{
        type: :nav1,
        record_type_indicator: "NAV1",
        navaid_facility_identifier: "BFF",
        navaid_facility_type_described: "VOR/DME",
        official_navaid_facility_identifier: "",
        effective_date_this_date_coincides_with_the_56_day: "08/15/2025",
        name_of_navaid_ex_washington: "SCOTTSBLUFF",
        city_associated_with_the_navaid_ex_washington: "SCOTTSBLUFF",
        state_name_where_associated_city_is_located: "NEBRASKA",
        state_post_office_code_where_associated_city_is: "NE",
        faa_region_responsible_for_navaid_code_ex_aea: "ACE",
        country_navaid_located_if_other_than_u_s_name: "",
        country_post_office_code_navaid_located_if: "",
        navaid_owner_name_ex_u_s_navy: "FEDERAL AVIATION ADMIN.",
        navaid_operator_name_ex_u_s_navy: "FEDERAL AVIATION ADMIN.",
        common_system_usage_y_or_n_defines_how_the: "Y",
        navaid_public_use_y_or_n_defines_by_whom: "Y",
        class_of_navaid_the_navaid_class_designator: "H",
        hours_of_operation_of_navaid_ex_0800_2400: "",
        identifier_of_artcc_with_high_altitude_boundary: "DEN",
        name_of_artcc_with_high_altitude_boundary_that: "DENVER ARTCC",
        identifier_of_artcc_with_low_altitude_boundary: "DEN",
        name_of_artcc_with_low_altitude_boundary_that: "DENVER ARTCC",
        navaid_latitude_formatted: "41-52-19.8000N",
        navaid_latitude_all_seconds: "150739.8000N",
        navaid_longitude_formatted: "103-35-43.2000W",
        navaid_longitude_all_seconds: "3728432000W",
        latitude_longitude_survery_accuracy_code: "1",
        latitude_of_tacan_portion_of_vortac_when_tacan: "",
        latitude_of_tacan_portion_of_vortac_when_tacan_0: "",
        longitude_of_tacan_portion_of_vortac_when_tacan: "",
        longitude_of_tacan_portion_of_vortac_when_tacan_0: "",
        elevation_in_tenth_of_a_foot_msl: "4054.6",
        magnetic_variation_degrees_00_99_followed_by: "10E",
        magnetic_variation_epoch_year_ex_2015: "2015",
        simultaneous_voice_feature_y_n_or_null: "N",
        power_output_in_watts: "200",
        automatic_voice_identification_feature_y_n_or: "Y",
        monitoring_category: "1",
        radio_voice_call_name_ex_washington_radio: "SCOTTSBLUFF RADIO",
        channel_tacan_navaid_transmits_on_ex_51x: "",
        frequency_the_navaid_transmits_on_except_tacan: "112.10",
        transmitted_fan_marker_marine_radio_beacon: "",
        fan_marker_type_bone_or_elliptical: "",
        true_bearing_of_major_axis_of_fan_marker_ex: "",
        vor_standard_service_volume_h_high_altitude: "H",
        dme_standard_service_volume_h_high_altitude: "H",
        low_altitude_facility_used_in_high_structure: "N",
        navaid_z_marker_available_y_n_or_null: "",
        transcribed_weather_broadcast_hours_tweb_ex: "",
        transcribed_weather_broadcast_phone_number: "",
        associated_controlling_fss_ident: "GRI",
        associated_controlling_fss_name: "GRAND ISLAND",
        hours_of_operation_of_controlling_fss_ex_0800: "",
        notam_accountability_code_ident: "BFF",
        quadrant_identification_and_range_leg_bearing: "",
        navigation_aid_status: "OPERATIONAL",
        pitch_flag_y_or_n: "N",
        catch_flag_y_or_n: "N",
        sua_atcaa_flag_y_or_n: "N",
        navaid_restriction_flag_y_n_or_null: "",
        hiwas_flag_y_n_or_null: "",
        transcribed_weather_broadcast_tweb_restriction: ""
      }

      result = NASR.Entities.from_raw(raw_data)

      assert %NASR.Entities.NavigationAidBaseData{} = result
      assert result.navaid_facility_identifier == "BFF"
      assert result.navaid_facility_type == "VOR/DME"
      assert result.navaid_name == "SCOTTSBLUFF"
      assert result.common_system_usage == true
      assert result.navaid_public_use == true
      assert result.frequency == 112.10
    end

    test "creates NAV2 (NavigationAidRemarks) entity from raw map" do
      raw_data = %{
        type: :nav2,
        record_type_indicator: "NAV2",
        navaid_facility_identifier: "BFF",
        navaid_facitity_type_ex_vor_dme: "VOR/DME",
        navaid_remarks_free_form_text_note_navaid: "DME UNUSABLE BYD 35 NM BLO 9000 FT."
      }

      result = NASR.Entities.from_raw(raw_data)

      assert %NASR.Entities.NavigationAidRemarks{} = result
      assert result.navaid_facility_identifier == "BFF"
      assert result.navaid_facility_type == "VOR/DME"
      assert result.navaid_remarks == "DME UNUSABLE BYD 35 NM BLO 9000 FT."
    end

    test "creates NAV3 (NavigationAidAirspaceFixes) entity from raw map" do
      raw_data = %{
        type: :nav3,
        record_type_indicator: "NAV3",
        navaid_facility_identifier: "BFF", 
        navaid_facitity_type_ex_vor_dme: "VOR/DME",
        name_s_of_fixes_fix_file_the_id_s_of_the: "ALLIS*NE*K4 BAGGS*WY*K4 BISON*WY*K4"
      }

      result = NASR.Entities.from_raw(raw_data)

      assert %NASR.Entities.NavigationAidAirspaceFixes{} = result
      assert result.navaid_facility_identifier == "BFF"
      assert result.navaid_facility_type == "VOR/DME"
      assert result.fix_names == ["ALLIS*NE*K4", "BAGGS*WY*K4", "BISON*WY*K4"]
    end

    test "creates NAV4 (NavigationAidHoldingPatterns) entity from raw map" do
      raw_data = %{
        type: :nav4,
        record_type_indicator: "NAV4",
        navaid_facility_identifier: "BFF",
        navaid_facitity_type_ex_vor_dme: "VOR/DME",
        holding_pattern_information_text: "HOLD EAST, LEFT TURNS, 270° RADIAL"
      }

      result = NASR.Entities.from_raw(raw_data)

      assert %NASR.Entities.NavigationAidHoldingPatterns{} = result
      assert result.navaid_facility_identifier == "BFF"
      assert result.navaid_facility_type == "VOR/DME"
      assert result.holding_pattern_data == "HOLD EAST, LEFT TURNS, 270° RADIAL"
    end

    test "creates NAV5 (NavigationAidFanMarkers) entity from raw map" do
      raw_data = %{
        type: :nav5,
        record_type_indicator: "NAV5",
        navaid_facility_identifier: "BFF",
        navaid_facitity_type_ex_vor_dme: "VOR/DME",
        fan_marker_information_text: "FAN MARKER 25NM"
      }

      result = NASR.Entities.from_raw(raw_data)

      assert %NASR.Entities.NavigationAidFanMarkers{} = result
      assert result.navaid_facility_identifier == "BFF"
      assert result.navaid_facility_type == "VOR/DME"
      assert result.fan_marker_data == "FAN MARKER 25NM"
    end

    test "creates NAV6 (NavigationAidVORCheckpoints) entity from raw map" do
      raw_data = %{
        type: :nav6,
        record_type_indicator: "NAV6",
        navaid_facility_identifier: "BFF",
        navaid_facitity_type_ex_vor_dme: "VOR/DME",
        vor_receiver_checkpoint_information_text: "VOR CHECKPOINT A/G 095°"
      }

      result = NASR.Entities.from_raw(raw_data)

      assert %NASR.Entities.NavigationAidVORCheckpoints{} = result
      assert result.navaid_facility_identifier == "BFF"
      assert result.navaid_facility_type == "VOR/DME"
      assert result.checkpoint_data == "VOR CHECKPOINT A/G 095°"
    end

    test "creates PJA2 (ParachuteJumpAreaTimesOfUse) entity from raw map" do
      raw_data = %{
        type: :pja2,
        record_type_indicator: "PJA2",
        pja_id: "PAK005",
        times_of_use_information_text: "DAILY SR-SS"
      }

      result = NASR.Entities.from_raw(raw_data)

      assert %NASR.Entities.ParachuteJumpAreaTimesOfUse{} = result
      assert result.pja_id == "PAK005"
      assert result.times_of_use_text == "DAILY SR-SS"
    end

    test "creates PJA3 (ParachuteJumpAreaUserGroup) entity from raw map" do
      raw_data = %{
        type: :pja3,
        record_type_indicator: "PJA3",
        pja_id: "PAK005",
        user_group_information_text: "ALASKA SKYDIVING CENTER"
      }

      result = NASR.Entities.from_raw(raw_data)

      assert %NASR.Entities.ParachuteJumpAreaUserGroup{} = result
      assert result.pja_id == "PAK005"
      assert result.user_group_text == "ALASKA SKYDIVING CENTER"
    end

    test "creates PJA4 (ParachuteJumpAreaContactFacility) entity from raw map" do
      raw_data = %{
        type: :pja4,
        record_type_indicator: "PJA4",
        pja_id: "PAK005",
        contact_facility_frequency_information_text: "CTAF 122.9"
      }

      result = NASR.Entities.from_raw(raw_data)

      assert %NASR.Entities.ParachuteJumpAreaContactFacility{} = result
      assert result.pja_id == "PAK005"
      assert result.contact_facility_text == "CTAF 122.9"
    end

    test "creates PJA5 (ParachuteJumpAreaRemarks) entity from raw map" do
      raw_data = %{
        type: :pja5,
        record_type_indicator: "PJA5",
        pja_id: "PAK005",
        pja_remarks_text: "PARACHUTE JUMPING ACTIVITIES MAY NOT BE OBSERVED FROM ATC FACILITIES."
      }

      result = NASR.Entities.from_raw(raw_data)

      assert %NASR.Entities.ParachuteJumpAreaRemarks{} = result
      assert result.pja_id == "PAK005"
      assert result.remarks_text == "PARACHUTE JUMPING ACTIVITIES MAY NOT BE OBSERVED FROM ATC FACILITIES."
    end

    test "creates FIX1 (FixBaseData) entity from raw map" do
      raw_data = %{
        type: :fix1,
        record_type_indicator: "FIX1",
        fix_identifier_record_identifier: "ALLIS",
        fix_state_name: "NEBRASKA",
        icao_region_code: "K4",
        latitude_formatted: "41-23-48.0000N",
        latitude_all_seconds: "149028.0000N",
        longitude_formatted: "102-42-00.0000W",
        longitude_all_seconds: "3699200000W",
        usage_data: "HIGH-LOW",
        nas_identifier: "ALLIS",
        high_artcc_identifier: "DEN",
        high_artcc_name: "DENVER",
        low_artcc_identifier: "DEN", 
        low_artcc_name: "DENVER",
        country_code: "US",
        country_name: "UNITED STATES",
        pitch_flag: "N",
        catch_flag: "N",
        sua_atcaa_flag: "N"
      }

      result = NASR.Entities.from_raw(raw_data)

      assert %NASR.Entities.FixBaseData{} = result
      assert result.fix_identifier == "ALLIS"
      assert result.fix_state_name == "NEBRASKA"
      assert result.usage_data == "HIGH-LOW"
      assert result.pitch_flag == false
    end

    test "creates FIX2 (FixNavaidMakeup) entity from raw map" do
      raw_data = %{
        type: :fix2,
        record_type_indicator: "FIX2",
        fix_identifier_record_identifier: "ALLIS",
        fix_state_name_record_identifier: "NEBRASKA",
        icao_region_code_record_identifier: "K4",
        navaid_makeup_text: "BFF042024"
      }

      result = NASR.Entities.from_raw(raw_data)

      assert %NASR.Entities.FixNavaidMakeup{} = result
      assert result.fix_identifier == "ALLIS"
      assert result.navaid_makeup_text == "BFF042024"
    end

    test "creates FIX3 (FixILSMakeup) entity from raw map" do
      raw_data = %{
        type: :fix3,
        record_type_indicator: "FIX3",
        fix_identifier_record_identifier: "ALLIS",
        fix_state_name_record_identifier: "NEBRASKA",
        icao_region_code_record_identifier: "K4",
        ils_makeup_text: "ILS RWY 05 ANB"
      }

      result = NASR.Entities.from_raw(raw_data)

      assert %NASR.Entities.FixILSMakeup{} = result
      assert result.fix_identifier == "ALLIS"
      assert result.ils_makeup_text == "ILS RWY 05 ANB"
    end

    test "creates FIX4 (FixRemarks) entity from raw map" do
      raw_data = %{
        type: :fix4,
        record_type_indicator: "FIX4",
        fix_identifier_record_identifier: "ALLIS",
        fix_state_name_record_identifier: "NEBRASKA",
        icao_region_code_record_identifier: "K4",
        remark_text: "WAYPOINT USED FOR GPS NAVIGATION"
      }

      result = NASR.Entities.from_raw(raw_data)

      assert %NASR.Entities.FixRemarks{} = result
      assert result.fix_identifier == "ALLIS"
      assert result.remark_text == "WAYPOINT USED FOR GPS NAVIGATION"
    end

    test "creates FIX5 (FixChartingInformation) entity from raw map" do
      raw_data = %{
        type: :fix5,
        record_type_indicator: "FIX5",
        fix_identifier_record_identifier: "ALLIS",
        fix_state_name_record_identifier: "NEBRASKA",
        icao_region_code_record_identifier: "K4",
        charting_information_text: "SECTIONAL CHART: OMAHA"
      }

      result = NASR.Entities.from_raw(raw_data)

      assert %NASR.Entities.FixChartingInformation{} = result
      assert result.fix_identifier == "ALLIS"
      assert result.charting_information_text == "SECTIONAL CHART: OMAHA"
    end

    test "returns nil for unknown entity types" do
      raw_data = %{type: :unknown_type}

      result = NASR.Entities.from_raw(raw_data)

      assert result == nil
    end
  end
end