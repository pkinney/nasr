defmodule NASR.Entities.FixTest do
  use ExUnit.Case

  alias NASR.Entities.Fix

  describe "new/1" do
    test "creates struct from real-world FIX_BASE sample data" do
      sample_data = %{
        "ARTCC_ID_HIGH" => "ZFW",
        "ARTCC_ID_LOW" => "ZFW",
        "CATCH_FLAG" => "N",
        "CHARTING_REMARK" => "RNAV",
        "CHARTS" => "CONTROLLER LOW,ENROUTE LOW,IAP,STAR",
        "COMPULSORY" => "",
        "COUNTRY_CODE" => "US",
        "EFF_DATE" => "2025/08/07",
        "FIX_ID" => "SASIE",
        "FIX_ID_OLD" => "",
        "FIX_USE_CODE" => "RP   ",
        "ICAO_REGION_CODE" => "K4",
        "LAT_DECIMAL" => "33.45016944",
        "LAT_DEG" => "33",
        "LAT_HEMIS" => "N",
        "LAT_MIN" => "27",
        "LAT_SEC" => "0.61",
        "LONG_DECIMAL" => "-96.59659444",
        "LONG_DEG" => "96",
        "LONG_HEMIS" => "W",
        "LONG_MIN" => "35",
        "LONG_SEC" => "47.74",
        "MIN_RECEP_ALT" => "",
        "PITCH_FLAG" => "N",
        "STATE_CODE" => "TX",
        "SUA_ATCAA_FLAG" => "N",
        "__FILE__" => "FIX_BASE.csv"
      }

      result = Fix.new(sample_data)

      assert result.fix_id == "SASIE"
      assert result.fix_id_old == ""
      assert result.latitude == 33.45016944
      assert result.longitude == -96.59659444
      assert result.state_code == "TX"
      assert result.country_code == "US"
      assert result.icao_region_code == "K4"
      assert result.fix_use_code == :reporting_point
      assert result.artcc_id_high == "ZFW"
      assert result.artcc_id_low == "ZFW"
      assert result.charting_remark == "RNAV"
      assert result.pitch_flag == false
      assert result.catch_flag == false
      assert result.sua_atcaa_flag == false
      assert result.min_recep_alt == nil
      assert result.compulsory == nil
      assert result.charts == ["CONTROLLER LOW", "ENROUTE LOW", "IAP", "STAR"]
      assert result.effective_date == ~D[2025-08-07]
    end

    test "handles various fix use codes" do
      test_cases = [
        {"CN", :computer_navigation_fix},
        {"MR", :military_reporting_point},
        {"MW", :military_waypoint},
        {"NRS", :nrs_waypoint},
        {"RADAR", :radar},
        {"RP", :reporting_point},
        {"VFR", :vfr_waypoint},
        {"WP", :waypoint}
      ]

      for {input, expected} <- test_cases do
        sample_data = create_sample_data(%{"FIX_USE_CODE" => input})
        result = Fix.new(sample_data)
        assert result.fix_use_code == expected
      end
    end

    test "handles compulsory values" do
      test_cases = [
        {"HIGH", :high},
        {"LOW", :low},
        {"LOW/HIGH", :low_high},
        {"", nil}
      ]

      for {input, expected} <- test_cases do
        sample_data = create_sample_data(%{"COMPULSORY" => input})
        result = Fix.new(sample_data)
        assert result.compulsory == expected
      end
    end

    test "handles Y/N flags correctly" do
      # Test with Y values
      sample_data =
        create_sample_data(%{
          "PITCH_FLAG" => "Y",
          "CATCH_FLAG" => "Y",
          "SUA_ATCAA_FLAG" => "Y"
        })

      result = Fix.new(sample_data)
      assert result.pitch_flag == true
      assert result.catch_flag == true
      assert result.sua_atcaa_flag == true

      # Test with N values
      sample_data =
        create_sample_data(%{
          "PITCH_FLAG" => "N",
          "CATCH_FLAG" => "N",
          "SUA_ATCAA_FLAG" => "N"
        })

      result = Fix.new(sample_data)
      assert result.pitch_flag == false
      assert result.catch_flag == false
      assert result.sua_atcaa_flag == false
    end

    test "parses charts list correctly" do
      test_cases = [
        {"", []},
        {"IAP", ["IAP"]},
        {"IAP,STAR", ["IAP", "STAR"]},
        {"CONTROLLER LOW,ENROUTE LOW,IAP,STAR", ["CONTROLLER LOW", "ENROUTE LOW", "IAP", "STAR"]},
        {"IAP, STAR, DP", ["IAP", "STAR", "DP"]}
      ]

      for {input, expected} <- test_cases do
        sample_data = create_sample_data(%{"CHARTS" => input})
        result = Fix.new(sample_data)
        assert result.charts == expected
      end
    end

    test "handles empty/nil values correctly" do
      sample_data =
        create_sample_data(%{
          "FIX_ID_OLD" => "",
          "MIN_RECEP_ALT" => "",
          "COMPULSORY" => "",
          "CHARTS" => ""
        })

      result = Fix.new(sample_data)

      assert result.fix_id_old == ""
      assert result.min_recep_alt == nil
      assert result.compulsory == nil
      assert result.charts == []
    end

    test "handles minimum reception altitude" do
      sample_data = create_sample_data(%{"MIN_RECEP_ALT" => "8000"})
      result = Fix.new(sample_data)
      assert result.min_recep_alt == 8000

      sample_data = create_sample_data(%{"MIN_RECEP_ALT" => ""})
      result = Fix.new(sample_data)
      assert result.min_recep_alt == nil
    end

    test "handles fix with old ID" do
      sample_data =
        create_sample_data(%{
          "FIX_ID" => "NEWID",
          "FIX_ID_OLD" => "OLDID"
        })

      result = Fix.new(sample_data)

      assert result.fix_id == "NEWID"
      assert result.fix_id_old == "OLDID"
    end

    test "handles coordinates with positive and negative values" do
      # Northern and Eastern hemispheres (positive)
      sample_data =
        create_sample_data(%{
          "LAT_DECIMAL" => "40.7128",
          "LONG_DECIMAL" => "74.0060"
        })

      result = Fix.new(sample_data)
      assert result.latitude == 40.7128
      assert result.longitude == 74.0060

      # Southern and Western hemispheres (negative)
      sample_data =
        create_sample_data(%{
          "LAT_DECIMAL" => "-33.8688",
          "LONG_DECIMAL" => "-151.2093"
        })

      result = Fix.new(sample_data)
      assert result.latitude == -33.8688
      assert result.longitude == -151.2093
    end
  end

  # Helper function to create sample data with default values
  defp create_sample_data(overrides) do
    Map.merge(
      %{
        "ARTCC_ID_HIGH" => "ZFW",
        "ARTCC_ID_LOW" => "ZFW",
        "CATCH_FLAG" => "N",
        "CHARTING_REMARK" => "RNAV",
        "CHARTS" => "IAP",
        "COMPULSORY" => "",
        "COUNTRY_CODE" => "US",
        "EFF_DATE" => "2025/08/07",
        "FIX_ID" => "TEST",
        "FIX_ID_OLD" => "",
        "FIX_USE_CODE" => "WP",
        "ICAO_REGION_CODE" => "K1",
        "LAT_DECIMAL" => "33.45016944",
        "LAT_DEG" => "33",
        "LAT_HEMIS" => "N",
        "LAT_MIN" => "27",
        "LAT_SEC" => "0.61",
        "LONG_DECIMAL" => "-96.59659444",
        "LONG_DEG" => "96",
        "LONG_HEMIS" => "W",
        "LONG_MIN" => "35",
        "LONG_SEC" => "47.74",
        "MIN_RECEP_ALT" => "",
        "PITCH_FLAG" => "N",
        "STATE_CODE" => "TX",
        "SUA_ATCAA_FLAG" => "N",
        "__FILE__" => "FIX_BASE.csv"
      },
      overrides
    )
  end
end
