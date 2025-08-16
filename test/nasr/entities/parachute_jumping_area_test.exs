defmodule NASR.Entities.ParachuteJumpingAreaTest do
  use ExUnit.Case
  alias NASR.Entities.ParachuteJumpingArea

  describe "new/1" do
    test "creates ParachuteJumpingArea struct from PJA_BASE sample data" do
      sample_data = create_sample_data(%{})

      result = ParachuteJumpingArea.new(sample_data)

      assert result.effective_date == ~D[2025-08-07]
      assert result.pja_id == "PAK002"
      assert result.nav_id == "FAI"
      assert result.nav_type == :vortac
      assert result.radial == 67.0
      assert result.distance == 27.0
      assert result.navaid_name == "FAIRBANKS"
      assert result.state_code == "AK"
      assert result.city == "FAIRBANKS"
      assert result.latitude == "64-45-26.2123N"
      assert result.latitude_decimal == 64.75728119
      assert result.longitude == "146-57-55.7727W"
      assert result.longitude_decimal == -146.96549241
      assert result.arpt_id == ""
      assert result.site_no == ""
      assert result.site_type_code == ""
      assert result.drop_zone_name == "HUSKY DROP ZONE"
      assert result.max_altitude == 3500
      assert result.max_altitude_type == :msl
      assert result.pja_radius == nil
      assert result.chart_request_flag == true
      assert result.publish_criteria == true
      assert result.description == ""
      assert result.time_of_use == "CONTINUOUS"
      assert result.fss_id == "FAI"
      assert result.fss_name == "FAIRBANKS"
      assert result.pja_use == :military
      assert result.volume == ""
      assert result.pja_user == "ACTIVE ARMY AND USAF"
      assert result.remark == ""
    end

    test "handles navigation aid type conversions" do
      test_cases = [
        {"VOR", :vor},
        {"VORTAC", :vortac},
        {"VOR/DME", :vor_dme},
        {"OTHER", "OTHER"},
        {"", nil}
      ]

      for {input, expected} <- test_cases do
        sample_data = create_sample_data(%{"NAV_TYPE" => input})
        result = ParachuteJumpingArea.new(sample_data)
        assert result.nav_type == expected
      end
    end

    test "handles altitude type conversions" do
      test_cases = [
        {"MSL", :msl},
        {"AGL", :agl},
        {"OTHER", "OTHER"},
        {"", nil}
      ]

      for {input, expected} <- test_cases do
        sample_data = create_sample_data(%{"MAX_ALTITUDE_TYPE_CODE" => input})
        result = ParachuteJumpingArea.new(sample_data)
        assert result.max_altitude_type == expected
      end
    end

    test "handles PJA use type conversions" do
      test_cases = [
        {"MILITARY", :military},
        {"CIVILIAN", "CIVILIAN"},
        {"", nil}
      ]

      for {input, expected} <- test_cases do
        sample_data = create_sample_data(%{"PJA_USE" => input})
        result = ParachuteJumpingArea.new(sample_data)
        assert result.pja_use == expected
      end
    end

    test "handles civilian parachute jumping areas" do
      civilian_pja = create_sample_data(%{
        "PJA_ID" => "PAK004",
        "NAV_ID" => "FAI",
        "NAV_TYPE" => "VORTAC",
        "RADIAL" => "42",
        "DISTANCE" => "10",
        "DROP_ZONE_NAME" => "BIRCH HILL",
        "MAX_ALTITUDE" => "6000",
        "MAX_ALTITUDE_TYPE_CODE" => "MSL",
        "PJA_RADIUS" => "3",
        "CHART_REQUEST_FLAG" => "N",
        "PUBLISH_CRITERIA" => "Y",
        "TIME_OF_USE" => "SR-SS 1 APRIL 31 OCT",
        "PJA_USE" => "",
        "PJA_USER" => ""
      })

      result = ParachuteJumpingArea.new(civilian_pja)
      assert result.pja_id == "PAK004"
      assert result.drop_zone_name == "BIRCH HILL"
      assert result.max_altitude == 6000
      assert result.pja_radius == 3
      assert result.chart_request_flag == false
      assert result.publish_criteria == true
      assert result.time_of_use == "SR-SS 1 APRIL 31 OCT"
      assert result.pja_use == nil
      assert result.pja_user == ""
    end

    test "handles PJAs with airport associations" do
      airport_pja = create_sample_data(%{
        "PJA_ID" => "PAK006",
        "ARPT_ID" => "CSR",
        "SITE_NO" => "50033.",
        "SITE_TYPE_CODE" => "A",
        "DROP_ZONE_NAME" => "CAMPBELL",
        "MAX_ALTITUDE" => "2000",
        "TIME_OF_USE" => "SUNRISE-SUNSET; UNSCHULED"
      })

      result = ParachuteJumpingArea.new(airport_pja)
      assert result.pja_id == "PAK006"
      assert result.arpt_id == "CSR"
      assert result.site_no == "50033."
      assert result.site_type_code == "A"
      assert result.drop_zone_name == "CAMPBELL"
      assert result.max_altitude == 2000
      assert result.time_of_use == "SUNRISE-SUNSET; UNSCHULED"
    end

    test "handles high altitude PJAs" do
      high_altitude_pja = create_sample_data(%{
        "PJA_ID" => "PAK005",
        "DROP_ZONE_NAME" => "",
        "MAX_ALTITUDE" => "12500",
        "TIME_OF_USE" => "SUNRISE-SUNSET; WEEKENDS",
        "REMARK" => "JUMPS OVER PIPPEL FIELD"
      })

      result = ParachuteJumpingArea.new(high_altitude_pja)
      assert result.pja_id == "PAK005"
      assert result.drop_zone_name == ""
      assert result.max_altitude == 12500
      assert result.time_of_use == "SUNRISE-SUNSET; WEEKENDS"
      assert result.remark == "JUMPS OVER PIPPEL FIELD"
    end

    test "handles radial and distance calculations" do
      precise_location = create_sample_data(%{
        "RADIAL" => "34.44",
        "DISTANCE" => "14.4"
      })

      result = ParachuteJumpingArea.new(precise_location)
      assert result.radial == 34.44
      assert result.distance == 14.4
    end

    test "handles boolean flag conversions" do
      test_cases = [
        {"Y", true},
        {"N", false},
        {"", nil}
      ]

      for {input, expected} <- test_cases do
        sample_data = create_sample_data(%{
          "CHART_REQUEST_FLAG" => input,
          "PUBLISH_CRITERIA" => input
        })
        result = ParachuteJumpingArea.new(sample_data)
        assert result.chart_request_flag == expected
        assert result.publish_criteria == expected
      end
    end

    test "handles empty/nil values correctly" do
      sample_data = create_sample_data(%{
        "EFF_DATE" => "",
        "NAV_TYPE" => "",
        "RADIAL" => "",
        "DISTANCE" => "",
        "LAT_DECIMAL" => "",
        "LONG_DECIMAL" => "",
        "MAX_ALTITUDE" => "",
        "MAX_ALTITUDE_TYPE_CODE" => "",
        "PJA_RADIUS" => "",
        "CHART_REQUEST_FLAG" => "",
        "PUBLISH_CRITERIA" => "",
        "PJA_USE" => ""
      })

      result = ParachuteJumpingArea.new(sample_data)

      assert result.effective_date == nil
      assert result.nav_type == nil
      assert result.radial == nil
      assert result.distance == nil
      assert result.latitude_decimal == nil
      assert result.longitude_decimal == nil
      assert result.max_altitude == nil
      assert result.max_altitude_type == nil
      assert result.pja_radius == nil
      assert result.chart_request_flag == nil
      assert result.publish_criteria == nil
      assert result.pja_use == nil
    end

    test "handles special event PJAs" do
      special_event_pja = create_sample_data(%{
        "PJA_ID" => "PAK008",
        "NAV_ID" => "BIG",
        "DROP_ZONE_NAME" => "FAIRGROUNDS",
        "TIME_OF_USE" => "SUNRISE-SUNSET; DURING STATE FAIR",
        "DESCRIPTION" => ""
      })

      result = ParachuteJumpingArea.new(special_event_pja)
      assert result.pja_id == "PAK008"
      assert result.nav_id == "BIG"
      assert result.drop_zone_name == "FAIRGROUNDS"
      assert result.time_of_use == "SUNRISE-SUNSET; DURING STATE FAIR"
      assert result.description == ""
    end

    test "handles coordinate formats" do
      coordinate_pja = create_sample_data(%{
        "LATITUDE" => "60-57-44.3891N",
        "LAT_DECIMAL" => "60.9623303",
        "LONGITUDE" => "149-06-26.3520W",
        "LONG_DECIMAL" => "-149.10732"
      })

      result = ParachuteJumpingArea.new(coordinate_pja)
      assert result.latitude == "60-57-44.3891N"
      assert result.latitude_decimal == 60.9623303
      assert result.longitude == "149-06-26.3520W"
      assert result.longitude_decimal == -149.10732
    end
  end

  describe "type/0" do
    test "returns correct type string" do
      assert ParachuteJumpingArea.type() == "PJA_BASE"
    end
  end

  # Helper function to create sample data with default values
  defp create_sample_data(overrides) do
    Map.merge(%{
      "EFF_DATE" => "2025/08/07",
      "PJA_ID" => "PAK002",
      "NAV_ID" => "FAI",
      "NAV_TYPE" => "VORTAC",
      "RADIAL" => "67",
      "DISTANCE" => "27",
      "NAVAID_NAME" => "FAIRBANKS",
      "STATE_CODE" => "AK",
      "CITY" => "FAIRBANKS",
      "LATITUDE" => "64-45-26.2123N",
      "LAT_DECIMAL" => "64.75728119",
      "LONGITUDE" => "146-57-55.7727W",
      "LONG_DECIMAL" => "-146.96549241",
      "ARPT_ID" => "",
      "SITE_NO" => "",
      "SITE_TYPE_CODE" => "",
      "DROP_ZONE_NAME" => "HUSKY DROP ZONE",
      "MAX_ALTITUDE" => "3500",
      "MAX_ALTITUDE_TYPE_CODE" => "MSL",
      "PJA_RADIUS" => "",
      "CHART_REQUEST_FLAG" => "Y",
      "PUBLISH_CRITERIA" => "Y",
      "DESCRIPTION" => "",
      "TIME_OF_USE" => "CONTINUOUS",
      "FSS_ID" => "FAI",
      "FSS_NAME" => "FAIRBANKS",
      "PJA_USE" => "MILITARY",
      "VOLUME" => "",
      "PJA_USER" => "ACTIVE ARMY AND USAF",
      "REMARK" => ""
    }, overrides)
  end
end