defmodule NASR.Entities.ILS.GlideslopeTest do
  use ExUnit.Case
  alias NASR.Entities.ILS.Glideslope

  describe "new/1" do
    test "creates Glideslope struct from ILS_GS sample data" do
      sample_data = create_sample_data(%{})

      result = Glideslope.new(sample_data)

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
      assert result.component_status == "OPERATIONAL IFR"
      assert result.component_status_date == ~D[1991-07-25]
      assert result.latitude_degrees == 33
      assert result.latitude_minutes == 35
      assert result.latitude_seconds == 1.8321
      assert result.latitude_hemisphere == :north
      assert result.latitude_decimal == 33.58384225
      assert result.longitude_degrees == 85
      assert result.longitude_minutes == 51
      assert result.longitude_seconds == 55.9415
      assert result.longitude_hemisphere == :west
      assert result.longitude_decimal == -85.8655393
      assert result.latitude_longitude_source_code == "K"
      assert result.site_elevation == 590.8
      assert result.glideslope_type_code == "GS"
      assert result.glideslope_angle == 3
      assert result.glideslope_frequency == 332.9
    end

    test "handles site type code conversions" do
      test_cases = [
        {"A", :airport},
        {"B", :balloonport},
        {"S", :seaplane_base},
        {"G", :gliderport},
        {"H", :heliport},
        {"U", :ultralight}
      ]

      for {input, expected} <- test_cases do
        sample_data = create_sample_data(%{"SITE_TYPE_CODE" => input})
        result = Glideslope.new(sample_data)
        assert result.site_type_code == expected
      end
    end

    test "handles system type code conversions" do
      test_cases = [
        {"LS", :ils},
        {"LO", :localizer_only},
        {"SD", :simplified_directional_facility},
        {"LD", :localizer_directional_aid},
        {"ML", :microwave_landing_system}
      ]

      for {input, expected} <- test_cases do
        sample_data = create_sample_data(%{"SYSTEM_TYPE_CODE" => input})
        result = Glideslope.new(sample_data)
        assert result.system_type_code == expected
      end
    end

    test "handles hemisphere conversions" do
      test_cases = [
        {"N", :north},
        {"S", :south},
        {"E", :east},
        {"W", :west}
      ]

      for {input, expected} <- test_cases do
        sample_data = create_sample_data(%{
          "LAT_HEMIS" => input,
          "LONG_HEMIS" => input
        })
        result = Glideslope.new(sample_data)
        assert result.latitude_hemisphere == expected
        assert result.longitude_hemisphere == expected
      end
    end

    test "handles numeric conversions" do
      test_data = create_sample_data(%{
        "G_S_ANGLE" => "3",
        "G_S_FREQ" => "329.5",
        "SITE_ELEVATION" => "1250.8"
      })

      result = Glideslope.new(test_data)

      assert result.glideslope_angle == 3
      assert result.glideslope_frequency == 329.5
      assert result.site_elevation == 1250.8
    end

    test "handles empty/nil values correctly" do
      sample_data = create_sample_data(%{
        "EFF_DATE" => "",
        "LAT_DEG" => "",
        "G_S_ANGLE" => "",
        "G_S_FREQ" => "",
        "SITE_ELEVATION" => ""
      })

      result = Glideslope.new(sample_data)

      assert result.effective_date == nil
      assert result.latitude_degrees == nil
      assert result.glideslope_angle == nil
      assert result.glideslope_frequency == nil
      assert result.site_elevation == nil
    end
  end

  describe "type/0" do
    test "returns correct type string" do
      assert Glideslope.type() == "ILS_GS"
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
      "COMPONENT_STATUS" => "OPERATIONAL IFR",
      "COMPONENT_STATUS_DATE" => "1991/07/25",
      "LAT_DEG" => "33",
      "LAT_MIN" => "35",
      "LAT_SEC" => "1.8321",
      "LAT_HEMIS" => "N",
      "LAT_DECIMAL" => "33.58384225",
      "LONG_DEG" => "85",
      "LONG_MIN" => "51",
      "LONG_SEC" => "55.9415",
      "LONG_HEMIS" => "W",
      "LONG_DECIMAL" => "-85.8655393",
      "LAT_LONG_SOURCE_CODE" => "K",
      "SITE_ELEVATION" => "590.8",
      "G_S_TYPE_CODE" => "GS",
      "G_S_ANGLE" => "3",
      "G_S_FREQ" => "332.9"
    }, overrides)
  end
end