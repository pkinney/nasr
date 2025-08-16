defmodule NASR.Entities.MaximumAuthorizedAltitudeTest do
  use ExUnit.Case
  alias NASR.Entities.MaximumAuthorizedAltitude

  describe "new/1" do
    test "creates MaximumAuthorizedAltitude struct from MAA_BASE sample data" do
      sample_data = create_sample_data(%{})

      result = MaximumAuthorizedAltitude.new(sample_data)

      assert result.effective_date == ~D[2025-08-07]
      assert result.maa_id == "AAL001"
      assert result.maa_type_name == :aerobatic_practice
      assert result.nav_id == ""
      assert result.nav_type == ""
      assert result.nav_radial == nil
      assert result.nav_distance == nil
      assert result.state_code == "AL"
      assert result.city == "MANCHESTER"
      assert result.latitude == nil
      assert result.longitude == nil
      assert result.arpt_ids == "JFX"
      assert result.nearest_arpt == ""
      assert result.nearest_arpt_dist == nil
      assert result.nearest_arpt_dir == ""
      assert result.maa_name == ""
      assert result.max_alt == "5000AGL"
      assert result.min_alt == "0AGL"
      assert result.maa_radius == nil
      assert String.contains?(result.description, "THE APA WOULD BE LOCATED AT WALKER COUNTY AIRPORT")
      assert result.maa_use == nil
      assert result.check_notams == ""
      assert result.time_of_use == "DAYLIGHT HOURS MONDAY THROUGH SUNDAY"
      assert result.user_group_name == ""
    end

    test "handles different MAA types" do
      test_cases = [
        {"AEROBATIC PRACTICE", :aerobatic_practice},
        {"ALERT AREA", :alert_area},
        {"CONTROLLED FIRING AREA", :controlled_firing_area},
        {"MILITARY OPERATIONS AREA", :military_operations_area},
        {"NATIONAL SECURITY AREA", :national_security_area},
        {"PROHIBITED AREA", :prohibited_area},
        {"RESTRICTED AREA", :restricted_area},
        {"TEMPORARY FLIGHT RESTRICTION", :temporary_flight_restriction},
        {"WARNING AREA", :warning_area}
      ]

      for {maa_type, expected_atom} <- test_cases do
        sample_data = create_sample_data(%{"MAA_TYPE_NAME" => maa_type})
        result = MaximumAuthorizedAltitude.new(sample_data)
        assert result.maa_type_name == expected_atom, "Failed for MAA_TYPE_NAME: #{maa_type}"
      end
    end

    test "handles MAA use types" do
      test_cases = [
        {"CIVIL", :civil},
        {"MILITARY", :military},
        {"JOINT", :joint}
      ]

      for {use_type, expected_atom} <- test_cases do
        sample_data = create_sample_data(%{"MAA_USE" => use_type})
        result = MaximumAuthorizedAltitude.new(sample_data)
        assert result.maa_use == expected_atom, "Failed for MAA_USE: #{use_type}"
      end
    end

    test "handles circular area with radius" do
      circular_data = create_sample_data(%{
        "MAA_ID" => "ACA003",
        "CITY" => "REDLANDS",
        "LATITUDE" => "34-05-06.9000N",
        "LONGITUDE" => "117-08-47.0000W",
        "ARPT_IDS" => "REI",
        "MAA_NAME" => "REDLANDS MUNICIPAL AIRPORT APA",
        "MAX_ALT" => "7500MSL",
        "MIN_ALT" => "3500MSL",
        "MAA_RADIUS" => "1",
        "MAA_USE" => "CIVIL"
      })

      result = MaximumAuthorizedAltitude.new(circular_data)
      
      assert result.maa_id == "ACA003"
      assert result.city == "REDLANDS"
      assert_in_delta result.latitude, 34.085, 0.01
      assert_in_delta result.longitude, -117.146, 0.01
      assert result.arpt_ids == "REI"
      assert result.maa_name == "REDLANDS MUNICIPAL AIRPORT APA"
      assert result.max_alt == "7500MSL"
      assert result.min_alt == "3500MSL"
      assert result.maa_radius == 1
      assert result.maa_use == :civil
    end

    test "handles coordinate parsing in DMS format" do
      coordinate_data = create_sample_data(%{
        "LATITUDE" => "36-22-14.0000N",
        "LONGITUDE" => "092-28-23.0000W"
      })

      result = MaximumAuthorizedAltitude.new(coordinate_data)
      
      # 36 degrees, 22 minutes, 14 seconds North = ~36.37 degrees
      assert_in_delta result.latitude, 36.37, 0.01
      # 92 degrees, 28 minutes, 23 seconds West = ~-92.47 degrees  
      assert_in_delta result.longitude, -92.47, 0.01
    end

    test "handles navaid-based areas" do
      navaid_data = create_sample_data(%{
        "MAA_ID" => "NAV001",
        "NAV_ID" => "ABC",
        "NAV_TYPE" => "VOR",
        "NAV_RADIAL" => "090",
        "NAV_DISTANCE" => "15.5"
      })

      result = MaximumAuthorizedAltitude.new(navaid_data)
      
      assert result.nav_id == "ABC"
      assert result.nav_type == "VOR"
      assert result.nav_radial == 90
      assert result.nav_distance == 15.5
    end

    test "handles different altitude designations" do
      test_cases = [
        {"5000AGL", "0AGL"},
        {"3000AGL", "1000AGL"},
        {"7500MSL", "3500MSL"},
        {"4000MSL", "0MSL"}
      ]

      for {max_alt, min_alt} <- test_cases do
        sample_data = create_sample_data(%{
          "MAX_ALT" => max_alt,
          "MIN_ALT" => min_alt
        })
        result = MaximumAuthorizedAltitude.new(sample_data)
        assert result.max_alt == max_alt
        assert result.min_alt == min_alt
      end
    end

    test "handles time-of-use restrictions" do
      time_restrictions = [
        "DAYLIGHT HOURS MONDAY THROUGH SUNDAY",
        "SUNRISE TO SUNSET",
        "SUNRISE TO SUNSET.",
        "MONDAY THRU SUNDAY DURING DAY LIGHT HOURS"
      ]

      for time_restriction <- time_restrictions do
        sample_data = create_sample_data(%{"TIME_OF_USE" => time_restriction})
        result = MaximumAuthorizedAltitude.new(sample_data)
        assert result.time_of_use == time_restriction
      end
    end

    test "handles nearest airport information" do
      nearest_airport_data = create_sample_data(%{
        "NEAREST_ARPT" => "ABC",
        "NEAREST_ARPT_DIST" => "5.2",
        "NEAREST_ARPT_DIR" => "NE"
      })

      result = MaximumAuthorizedAltitude.new(nearest_airport_data)
      
      assert result.nearest_arpt == "ABC"
      assert result.nearest_arpt_dist == 5.2
      assert result.nearest_arpt_dir == "NE"
    end

    test "handles detailed area descriptions" do
      long_description = "THE APA WOULD BE LOCATED AT WALKER COUNTY AIRPORT. IT WOULD HAVE AN IRREGULAR SHAPE WITH 8 SIDES. BEGINNING WITH THE NORTH WESTERN CORNER AND LISTING CLOCKWISE THE SIDES WOULD MEASURE 2,300 FEET, 650 FEET, 5,100 FEET, 400 FEET, 3,500 FEET, 1,000 FEET, 4,300 FEET AND 1,700 FEET. IT WOULD HAVE A HEIGHT BETWEEN THE SURFACE AND 5,000 FEET ABOVE GROUND LEVEL, AS DEPICTED ON THE ENCLOSED GRAPHIC."
      
      description_data = create_sample_data(%{"DESCRIPTION" => long_description})
      result = MaximumAuthorizedAltitude.new(description_data)
      
      assert result.description == long_description
    end

    test "handles empty/nil values correctly" do
      sample_data = create_sample_data(%{
        "NAV_RADIAL" => "",
        "NAV_DISTANCE" => "",
        "LATITUDE" => "",
        "LONGITUDE" => "",
        "NEAREST_ARPT_DIST" => "",
        "MAA_RADIUS" => "",
        "MAA_USE" => ""
      })

      result = MaximumAuthorizedAltitude.new(sample_data)

      assert result.nav_radial == nil
      assert result.nav_distance == nil
      assert result.latitude == nil
      assert result.longitude == nil
      assert result.nearest_arpt_dist == nil
      assert result.maa_radius == nil
      assert result.maa_use == nil
    end

    test "handles unknown/invalid values" do
      sample_data = create_sample_data(%{
        "MAA_TYPE_NAME" => "UNKNOWN_TYPE",
        "MAA_USE" => "UNKNOWN_USE"
      })

      result = MaximumAuthorizedAltitude.new(sample_data)

      assert result.maa_type_name == "UNKNOWN_TYPE"
      assert result.maa_use == "UNKNOWN_USE"
    end

    test "handles different state and region patterns" do
      state_patterns = [
        {"AL", "AAL001"},
        {"AR", "AAR001"},
        {"AZ", "AAZ001"},
        {"CA", "ACA001"}
      ]

      for {state, maa_id} <- state_patterns do
        sample_data = create_sample_data(%{
          "MAA_ID" => maa_id,
          "STATE_CODE" => state
        })
        result = MaximumAuthorizedAltitude.new(sample_data)
        assert result.state_code == state
        assert result.maa_id == maa_id
      end
    end
  end

  describe "type/0" do
    test "returns correct type string" do
      assert MaximumAuthorizedAltitude.type() == "MAA_BASE"
    end
  end

  # Helper function to create sample data with default values
  defp create_sample_data(overrides) do
    Map.merge(%{
      "EFF_DATE" => "2025/08/07",
      "MAA_ID" => "AAL001",
      "MAA_TYPE_NAME" => "AEROBATIC PRACTICE",
      "NAV_ID" => "",
      "NAV_TYPE" => "",
      "NAV_RADIAL" => "",
      "NAV_DISTANCE" => "",
      "STATE_CODE" => "AL",
      "CITY" => "MANCHESTER",
      "LATITUDE" => "",
      "LONGITUDE" => "",
      "ARPT_IDS" => "JFX",
      "NEAREST_ARPT" => "",
      "NEAREST_ARPT_DIST" => "",
      "NEAREST_ARPT_DIR" => "",
      "MAA_NAME" => "",
      "MAX_ALT" => "5000AGL",
      "MIN_ALT" => "0AGL",
      "MAA_RADIUS" => "",
      "DESCRIPTION" => "THE APA WOULD BE LOCATED AT WALKER COUNTY AIRPORT. IT WOULD HAVE AN IRREGULAR SHAPE WITH 8 SIDES. BEGINNING WITH THE NORTH WESTERN CORNER AND LISTING CLOCKWISE THE SIDES WOULD MEASURE 2,300 FEET, 650 FEET, 5,100 FEET, 400 FEET, 3,500 FEET, 1,000 FEET, 4,300 FEET AND 1,700 FEET. IT WOULD HAVE A HEIGHT BETWEEN THE SURFACE AND 5,000 FEET ABOVE GROUND LEVEL, AS DEPICTED ON THE ENCLOSED GRAPHIC.",
      "MAA_USE" => "",
      "CHECK_NOTAMS" => "",
      "TIME_OF_USE" => "DAYLIGHT HOURS MONDAY THROUGH SUNDAY",
      "USER_GROUP_NAME" => ""
    }, overrides)
  end
end