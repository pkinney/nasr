defmodule NASR.Entities.AirportTest do
  use ExUnit.Case

  describe "new/1" do
    test "creates struct from airport base data sample" do
      sample_data = create_sample_data(%{})

      result = NASR.Entities.Airport.new(sample_data)

      assert result.site_no == "04513.0*A"
      assert result.site_type_code == :airport
      assert result.arpt_id == "LAX"
      assert result.arpt_name == "LOS ANGELES INTERNATIONAL"
      assert result.city == "LOS ANGELES"
      assert result.state_code == "CA"
      assert result.state_name == "CALIFORNIA"
      assert result.country_code == "US"
      assert result.region_code == "AWP"
      assert result.ado_code == "01"
      assert result.county_name == "LOS ANGELES"
      assert result.county_assoc_state == "CA"
      assert result.ownership_type_code == :public
      assert result.facility_use_code == :public
      assert result.latitude == 33.94253611
      assert result.longitude == -118.40808333
      assert result.survey_method_code == :surveyed
      assert result.elevation == 125.0
      assert result.elevation_method_code == :surveyed
      assert result.magnetic_variation == 11.0
      assert result.magnetic_hemisphere == "E"
      assert result.magnetic_variation_year == 2020
      assert result.traffic_pattern_altitude == 1125
      assert result.sectional_chart == "LOS ANGELES"
      assert result.distance_from_city == 12.0
      assert result.direction_from_city == "SW"
      assert result.land_area_covered == 3500.0
      assert result.boundary_artcc_id == "ZLA"
      assert result.boundary_artcc_computer_id == "LAX"
      assert result.boundary_artcc_name == "LOS ANGELES ARTCC"
      assert result.fss_on_facility_flag == false
      assert result.notam_facility_id == "LAX"
      assert result.notam_service_flag == true
      assert result.airport_status_code == :operational
      assert result.customs_entry_airport_flag == true
      assert result.effective_date == ~D[2025-08-07]
    end

    test "handles site type codes correctly" do
      test_cases = [
        {"A", :airport},
        {"B", :balloonport},
        {"C", :seaplane_base},
        {"G", :gliderport},
        {"H", :heliport},
        {"U", :ultralight},
        {"UNKNOWN", "UNKNOWN"}
      ]

      for {input, expected} <- test_cases do
        sample_data = create_sample_data(%{"SITE_TYPE_CODE" => input})
        result = NASR.Entities.Airport.new(sample_data)
        assert result.site_type_code == expected
      end
    end

    test "handles ownership type codes correctly" do
      test_cases = [
        {"PU", :public},
        {"PR", :private},
        {"MA", :air_force},
        {"MN", :navy},
        {"MR", :army},
        {"CG", :coast_guard},
        {"OTHER", "OTHER"}
      ]

      for {input, expected} <- test_cases do
        sample_data = create_sample_data(%{"OWNERSHIP_TYPE_CODE" => input})
        result = NASR.Entities.Airport.new(sample_data)
        assert result.ownership_type_code == expected
      end
    end

    test "handles facility use codes correctly" do
      test_cases = [
        {"PU", :public},
        {"PR", :private},
        {"MI", "MI"},  # Parser returns string for unknown codes
        {"OTHER", "OTHER"}
      ]

      for {input, expected} <- test_cases do
        sample_data = create_sample_data(%{"FACILITY_USE_CODE" => input})
        result = NASR.Entities.Airport.new(sample_data)
        assert result.facility_use_code == expected
      end
    end

    test "handles survey method codes correctly" do
      test_cases = [
        {"E", :estimated},
        {"S", :surveyed},
        {"OTHER", "OTHER"}
      ]

      for {input, expected} <- test_cases do
        sample_data = create_sample_data(%{"SURVEY_METHOD_CODE" => input})
        result = NASR.Entities.Airport.new(sample_data)
        assert result.survey_method_code == expected
      end
    end

    test "handles elevation method codes correctly" do
      test_cases = [
        {"E", :estimated},
        {"S", :surveyed},
        {"OTHER", "OTHER"}
      ]

      for {input, expected} <- test_cases do
        sample_data = create_sample_data(%{"ELEV_METHOD_CODE" => input})
        result = NASR.Entities.Airport.new(sample_data)
        assert result.elevation_method_code == expected
      end
    end

    test "handles airport status codes correctly" do
      test_cases = [
        {"O", :operational},
        {"CI", :closed_indefinitely},
        {"CP", :closed_permanently},
        {"OTHER", "OTHER"}
      ]

      for {input, expected} <- test_cases do
        sample_data = create_sample_data(%{"ARPT_STATUS" => input})
        result = NASR.Entities.Airport.new(sample_data)
        assert result.airport_status_code == expected
      end
    end

    test "handles Y/N flags correctly" do
      sample_data = create_sample_data(%{
        "FSS_ON_ARPT_FLAG" => "Y",
        "NOTAM_FLAG" => "Y",
        "CUST_FLAG" => "Y",
        "LNDG_RIGHTS_FLAG" => "Y",
        "JOINT_USE_FLAG" => "N",
        "MIL_LNDG_FLAG" => "Y"
      })
      
      result = NASR.Entities.Airport.new(sample_data)
      
      assert result.fss_on_facility_flag == true
      assert result.notam_service_flag == true
      assert result.customs_entry_airport_flag == true
      assert result.customs_landing_rights_flag == true
      assert result.joint_use_agreement_flag == false
      assert result.military_landing_rights_flag == true
    end

    test "converts numeric fields correctly" do
      sample_data = create_sample_data(%{
        "LAT_DECIMAL" => "40.7128",
        "LONG_DECIMAL" => "-74.0060",
        "ELEV" => "1250.5",
        "MAG_VARN" => "12.5",
        "MAG_VARN_YEAR" => "2022",
        "TPA" => "2250",
        "DIST_CITY_TO_AIRPORT" => "15.2",
        "ACREAGE" => "4500.75"
      })
      
      result = NASR.Entities.Airport.new(sample_data)
      
      assert result.latitude == 40.7128
      assert result.longitude == -74.0060
      assert result.elevation == 1250.5
      assert result.magnetic_variation == 12.5
      assert result.magnetic_variation_year == 2022
      assert result.traffic_pattern_altitude == 2250
      assert result.distance_from_city == 15.2
      assert result.land_area_covered == 4500.75
    end

    test "handles empty and nil numeric values correctly" do
      sample_data = create_sample_data(%{
        "ELEV" => "",
        "MAG_VARN" => "",
        "DIST_CITY_TO_AIRPORT" => "",
        "ACREAGE" => ""
      })
      
      result = NASR.Entities.Airport.new(sample_data)
      
      assert result.elevation == nil
      assert result.magnetic_variation == nil
      assert result.distance_from_city == nil
      assert result.land_area_covered == nil
    end

    test "parses dates correctly" do
      sample_data = create_sample_data(%{
        "ACTIVATION_DATE" => "03/19/1930",
        "EFF_DATE" => "2023/12/15"
      })
      
      result = NASR.Entities.Airport.new(sample_data)
      
      assert result.activation_date == ~D[1930-03-19]
      assert result.effective_date == ~D[2023-12-15]
    end

    test "handles various airport types and characteristics" do
      # Major commercial airport
      major_airport = create_sample_data(%{
        "ARPT_ID" => "ATL",
        "ARPT_NAME" => "HARTSFIELD-JACKSON ATLANTA INTL",
        "OWNERSHIP_TYPE_CODE" => "PU",
        "FACILITY_USE_CODE" => "PU",
        "ARPT_STATUS" => "O"
      })
      
      result = NASR.Entities.Airport.new(major_airport)
      
      assert result.arpt_id == "ATL"
      assert result.arpt_name == "HARTSFIELD-JACKSON ATLANTA INTL"
      assert result.ownership_type_code == :public
      assert result.facility_use_code == :public
      assert result.airport_status_code == :operational

      # Private airstrip
      private_strip = create_sample_data(%{
        "ARPT_ID" => "TX01",
        "ARPT_NAME" => "PRIVATE AIRSTRIP",
        "OWNERSHIP_TYPE_CODE" => "PR",
        "FACILITY_USE_CODE" => "PR",
        "SITE_TYPE_CODE" => "A"
      })
      
      result = NASR.Entities.Airport.new(private_strip)
      
      assert result.arpt_id == "TX01"
      assert result.arpt_name == "PRIVATE AIRSTRIP"
      assert result.ownership_type_code == :private
      assert result.facility_use_code == :private
      assert result.site_type_code == :airport

      # Heliport
      heliport = create_sample_data(%{
        "ARPT_ID" => "CA01",
        "ARPT_NAME" => "HOSPITAL HELIPORT",
        "SITE_TYPE_CODE" => "H",
        "OWNERSHIP_TYPE_CODE" => "PR",
        "FACILITY_USE_CODE" => "PR"
      })
      
      result = NASR.Entities.Airport.new(heliport)
      
      assert result.arpt_id == "CA01"
      assert result.arpt_name == "HOSPITAL HELIPORT"
      assert result.site_type_code == :heliport
      assert result.ownership_type_code == :private
      assert result.facility_use_code == :private
    end

    test "handles coordinate edge cases" do
      # Alaska coordinates (far north and west)
      alaska_data = create_sample_data(%{
        "LAT_DECIMAL" => "64.0685",
        "LONG_DECIMAL" => "-152.1108",
        "ARPT_ID" => "FAI",
        "ARPT_NAME" => "FAIRBANKS INTERNATIONAL"
      })
      
      result = NASR.Entities.Airport.new(alaska_data)
      
      assert result.latitude == 64.0685
      assert result.longitude == -152.1108
      assert result.arpt_id == "FAI"

      # Hawaii coordinates (tropical Pacific)
      hawaii_data = create_sample_data(%{
        "LAT_DECIMAL" => "21.3187",
        "LONG_DECIMAL" => "-157.9225",
        "ARPT_ID" => "HNL",
        "ARPT_NAME" => "DANIEL K INOUYE INTERNATIONAL"
      })
      
      result = NASR.Entities.Airport.new(hawaii_data)
      
      assert result.latitude == 21.3187
      assert result.longitude == -157.9225
      assert result.arpt_id == "HNL"
    end

    test "handles magnetic variation correctly" do
      # Eastern magnetic variation
      east_variation = create_sample_data(%{
        "MAG_VARN" => "14.5",
        "MAG_HEMIS" => "E",
        "MAG_VARN_YEAR" => "2020"
      })
      
      result = NASR.Entities.Airport.new(east_variation)
      
      assert result.magnetic_variation == 14.5
      assert result.magnetic_hemisphere == "E"
      assert result.magnetic_variation_year == 2020

      # Western magnetic variation
      west_variation = create_sample_data(%{
        "MAG_VARN" => "8.2",
        "MAG_HEMIS" => "W",
        "MAG_VARN_YEAR" => "2021"
      })
      
      result = NASR.Entities.Airport.new(west_variation)
      
      assert result.magnetic_variation == 8.2
      assert result.magnetic_hemisphere == "W"
      assert result.magnetic_variation_year == 2021
    end
  end

  test "type/0 returns correct CSV filename" do
    assert NASR.Entities.Airport.type() == "APT_BASE"
  end

  # Helper function to create comprehensive sample data with sensible defaults
  defp create_sample_data(overrides) do
    Map.merge(%{
      "SITE_NO" => "04513.0*A",
      "SITE_TYPE_CODE" => "A",
      "ARPT_ID" => "LAX",
      "CITY" => "LOS ANGELES",
      "STATE_CODE" => "CA",
      "COUNTRY_CODE" => "US",
      "REGION_CODE" => "AWP",
      "ADO_CODE" => "01",
      "STATE_NAME" => "CALIFORNIA",
      "COUNTY_NAME" => "LOS ANGELES",
      "COUNTY_ASSOC_STATE" => "CA",
      "ARPT_NAME" => "LOS ANGELES INTERNATIONAL",
      "OWNERSHIP_TYPE_CODE" => "PU",
      "FACILITY_USE_CODE" => "PU",
      "LAT_DECIMAL" => "33.94253611",
      "LONG_DECIMAL" => "-118.40808333",
      "SURVEY_METHOD_CODE" => "S",
      "ELEV" => "125.0",
      "ELEV_METHOD_CODE" => "S",
      "MAG_VARN" => "11.0",
      "MAG_HEMIS" => "E",
      "MAG_VARN_YEAR" => "2020",
      "TPA" => "1125",
      "CHART_NAME" => "LOS ANGELES",
      "DIST_CITY_TO_AIRPORT" => "12.0",
      "DIRECTION_CODE" => "SW",
      "ACREAGE" => "3500.0",
      "RESP_ARTCC_ID" => "ZLA",
      "COMPUTER_ID" => "LAX",
      "ARTCC_NAME" => "LOS ANGELES ARTCC",
      "FSS_ON_ARPT_FLAG" => "N",
      "FSS_ID" => "",
      "FSS_NAME" => "",
      "PHONE_NO" => "",
      "TOLL_FREE_NO" => "1-800-WX-BRIEF",
      "ALT_FSS_ID" => "ZLA",
      "ALT_FSS_NAME" => "SOCAL FSS",
      "ALT_TOLL_FREE_NO" => "1-800-WX-BRIEF",
      "NOTAM_ID" => "LAX",
      "NOTAM_FLAG" => "Y",
      "ACTIVATION_DATE" => "03/19/1930",
      "ARPT_STATUS" => "O",
      "FAR_139_TYPE_CODE" => "I",
      "NASP_CODE" => "Y",
      "ASP_ANLYS_DTRM_CODE" => "ANALYZED",
      "CUST_FLAG" => "Y",
      "LNDG_RIGHTS_FLAG" => "Y",
      "JOINT_USE_FLAG" => "N",
      "MIL_LNDG_FLAG" => "Y",
      "INSPECT_METHOD_CODE" => "F",
      "INSPECTOR_CODE" => "FAA",
      "LAST_INSPECTION" => "2024/01/15",
      "LAST_INFO_RESPONSE" => "2024/06/30",
      "FUEL_TYPES" => "100LL,JET A",
      "AIRFRAME_REPAIR_SER_CODE" => "MAJOR",
      "PWR_PLANT_REPAIR_SER" => "MAJOR",
      "BOTTLED_OXY_TYPE" => "HIGH",
      "BULK_OXY_TYPE" => "LOW",
      "LGT_SKED" => "SUNSET TO SUNRISE",
      "BCN_LGT_SKED" => "SUNSET TO SUNRISE",
      "TWR_TYPE_CODE" => "Y",
      "SEG_CIRCLE_MKR_FLAG" => "Y",
      "BCN_LENS_COLOR" => "CG",
      "LNDG_FEE_FLAG" => "N",
      "MEDICAL_USE_FLAG" => "N",
      "BASED_SINGLE_ENG" => "25",
      "BASED_MULTI_ENG" => "15",
      "BASED_JET_ENG" => "50",
      "BASED_HEL" => "5",
      "BASED_ GLIDERS" => "0",
      "BASED_ MIL_ACFT" => "0",
      "BASED_ULTRALGT_ACFT" => "0",
      "COMMERCIAL_OPS" => "180000",
      "COMMUTER_OPS" => "25000",
      "AIR_TAXI_OPS" => "15000",
      "LOCAL_OPS" => "50000",
      "ITNRNT_OPS" => "75000",
      "MIL_ACFT_OPS" => "2500",
      "ANNUAL_OPS_DATE" => "2024/12/31",
      "ARPT_PSN_SOURCE" => "GPS",
      "POSITION_SRC_DATE" => "2015/06/01",
      "ARPT_ELEV_SOURCE" => "NGS",
      "ELEVATION_SRC_DATE" => "2015/06/01",
      "CONTR_FUEL_AVBL" => "Y",
      "TRNS_STRG_BUOY_FLAG" => "N",
      "TRNS_STRG_HGR_FLAG" => "N",
      "TRNS_STRG_TIE_FLAG" => "Y",
      "OTHER_SERVICES" => "MAINTENANCE,CHARTER",
      "WIND_INDCR_FLAG" => "Y",
      "ICAO_ID" => "KLAX",
      "MIN_OP_NETWORK" => "",
      "USER_FEE_FLAG" => "N",
      "CTA" => "0",
      "EFF_DATE" => "2025/08/07"
    }, overrides)
  end
end