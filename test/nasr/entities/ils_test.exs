defmodule NASR.Entities.ILSTest do
  use ExUnit.Case
  alias NASR.Entities.ILS

  describe "new/1" do
    test "creates ILS struct from ILS_BASE sample data" do
      sample_data = create_sample_data(%{})

      result = ILS.new(sample_data)

      assert result.effective_date == ~D[2025-08-07]
      assert result.site_number == "00128."
      assert result.site_type_code == :airport
      assert result.state_code == "AL"
      assert result.airport_id == "ANB"
      assert result.city == "ANNISTON"
      assert result.country_code == "US"
      assert result.runway_end_id == "05"
      assert result.ils_localizer_id == "ANB"
      assert result.system_type_code == :ils
      assert result.state_name == "ALABAMA"
      assert result.region_code == "ASO"
      assert result.runway_length == 7000
      assert result.runway_width == 150
      assert result.category == "I"
      assert result.owner == "F-FEDERAL AVIATION ADMIN."
      assert result.operator == "F-FEDERAL AVIATION ADMIN."
      assert result.approach_bearing == 52.45
      assert result.magnetic_variation == 4
      assert result.magnetic_variation_hemisphere == :west
      assert result.component_status == "OPERATIONAL RESTRICTED"
      assert result.component_status_date == ~D[2017-07-18]
      assert result.latitude_degrees == 33
      assert result.latitude_minutes == 35
      assert result.latitude_seconds == 47.26
      assert result.latitude_hemisphere == :north
      assert result.latitude_decimal == 33.59646111
      assert result.longitude_degrees == 85
      assert result.longitude_minutes == 50
      assert result.longitude_seconds == 48.96
      assert result.longitude_hemisphere == :west
      assert result.longitude_decimal == -85.84693333
      assert result.latitude_longitude_source_code == "K"
      assert result.site_elevation == 612.1
      assert result.localizer_frequency == 111.5
      assert result.back_course_status_code == ""
    end

    test "handles site type code conversions" do
      test_cases = [
        {"A", :airport},
        {"B", :balloonport},
        {"S", :seaplane_base},
        {"G", :gliderport},
        {"H", :heliport},
        {"U", :ultralight},
        {"OTHER", "OTHER"}
      ]

      for {input, expected} <- test_cases do
        sample_data = create_sample_data(%{"SITE_TYPE_CODE" => input})
        result = ILS.new(sample_data)
        assert result.site_type_code == expected
      end
    end

    test "handles system type code conversions" do
      test_cases = [
        {"LS", :ils},
        {"LO", :localizer_only},
        {"SD", :simplified_directional_facility},
        {"LD", :localizer_directional_aid},
        {"ML", :microwave_landing_system},
        {"OTHER", "OTHER"}
      ]

      for {input, expected} <- test_cases do
        sample_data = create_sample_data(%{"SYSTEM_TYPE_CODE" => input})
        result = ILS.new(sample_data)
        assert result.system_type_code == expected
      end
    end

    test "handles hemisphere conversions" do
      test_cases = [
        {"N", :north},
        {"S", :south},
        {"E", :east},
        {"W", :west},
        {"OTHER", "OTHER"}
      ]

      for {input, expected} <- test_cases do
        sample_data = create_sample_data(%{
          "MAG_VAR_HEMIS" => input,
          "LAT_HEMIS" => input,
          "LONG_HEMIS" => input
        })
        result = ILS.new(sample_data)
        assert result.magnetic_variation_hemisphere == expected
        assert result.latitude_hemisphere == expected
        assert result.longitude_hemisphere == expected
      end
    end

    test "handles numeric conversions" do
      test_data = create_sample_data(%{
        "RWY_LEN" => "8000",
        "RWY_WIDTH" => "200",
        "APCH_BEAR" => "270.5",
        "MAG_VAR" => "12",
        "LAT_DEG" => "40",
        "LAT_MIN" => "30",
        "LAT_SEC" => "15.5",
        "LAT_DECIMAL" => "40.504305",
        "LONG_DEG" => "74",
        "LONG_MIN" => "45",
        "LONG_SEC" => "30.25",
        "LONG_DECIMAL" => "-74.758402",
        "SITE_ELEVATION" => "1250.5",
        "LOC_FREQ" => "109.9"
      })

      result = ILS.new(test_data)

      assert result.runway_length == 8000
      assert result.runway_width == 200
      assert result.approach_bearing == 270.5
      assert result.magnetic_variation == 12
      assert result.latitude_degrees == 40
      assert result.latitude_minutes == 30
      assert result.latitude_seconds == 15.5
      assert result.latitude_decimal == 40.504305
      assert result.longitude_degrees == 74
      assert result.longitude_minutes == 45
      assert result.longitude_seconds == 30.25
      assert result.longitude_decimal == -74.758402
      assert result.site_elevation == 1250.5
      assert result.localizer_frequency == 109.9
    end

    test "handles empty/nil numeric values correctly" do
      sample_data = create_sample_data(%{
        "RWY_LEN" => "",
        "RWY_WIDTH" => "",
        "APCH_BEAR" => "",
        "MAG_VAR" => "",
        "LAT_DEG" => "",
        "SITE_ELEVATION" => "",
        "LOC_FREQ" => ""
      })

      result = ILS.new(sample_data)

      assert result.runway_length == nil
      assert result.runway_width == nil
      assert result.approach_bearing == nil
      assert result.magnetic_variation == nil
      assert result.latitude_degrees == nil
      assert result.site_elevation == nil
      assert result.localizer_frequency == nil
    end

    test "handles date parsing" do
      sample_data = create_sample_data(%{
        "EFF_DATE" => "2025/12/31",
        "COMPONENT_STATUS_DATE" => "2020/05/15"
      })

      result = ILS.new(sample_data)

      assert result.effective_date == ~D[2025-12-31]
      assert result.component_status_date == ~D[2020-05-15]
    end

    test "handles localizer only system" do
      localizer_data = create_sample_data(%{
        "SYSTEM_TYPE_CODE" => "LO",
        "ILS_LOC_ID" => "LGA",
        "CATEGORY" => "LOC"
      })

      result = ILS.new(localizer_data)

      assert result.system_type_code == :localizer_only
      assert result.ils_localizer_id == "LGA"
      assert result.category == "LOC"
    end
  end

  describe "type/0" do
    test "returns correct type string" do
      assert ILS.type() == "ILS_BASE"
    end
  end

  # Helper function to create sample data with default values
  defp create_sample_data(overrides) do
    Map.merge(%{
      "EFF_DATE" => "2025/08/07",
      "SITE_NO" => "00128.",
      "SITE_TYPE_CODE" => "A",
      "STATE_CODE" => "AL",
      "ARPT_ID" => "ANB",
      "CITY" => "ANNISTON",
      "COUNTRY_CODE" => "US",
      "RWY_END_ID" => "05",
      "ILS_LOC_ID" => "ANB",
      "SYSTEM_TYPE_CODE" => "LS",
      "STATE_NAME" => "ALABAMA",
      "REGION_CODE" => "ASO",
      "RWY_LEN" => "7000",
      "RWY_WIDTH" => "150",
      "CATEGORY" => "I",
      "OWNER" => "F-FEDERAL AVIATION ADMIN.",
      "OPERATOR" => "F-FEDERAL AVIATION ADMIN.",
      "APCH_BEAR" => "52.45",
      "MAG_VAR" => "4",
      "MAG_VAR_HEMIS" => "W",
      "COMPONENT_STATUS" => "OPERATIONAL RESTRICTED",
      "COMPONENT_STATUS_DATE" => "2017/07/18",
      "LAT_DEG" => "33",
      "LAT_MIN" => "35",
      "LAT_SEC" => "47.26",
      "LAT_HEMIS" => "N",
      "LAT_DECIMAL" => "33.59646111",
      "LONG_DEG" => "85",
      "LONG_MIN" => "50",
      "LONG_SEC" => "48.96",
      "LONG_HEMIS" => "W",
      "LONG_DECIMAL" => "-85.84693333",
      "LAT_LONG_SOURCE_CODE" => "K",
      "SITE_ELEVATION" => "612.1",
      "LOC_FREQ" => "111.5",
      "BK_COURSE_STATUS_CODE" => ""
    }, overrides)
  end
end