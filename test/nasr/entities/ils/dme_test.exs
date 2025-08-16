defmodule NASR.Entities.ILS.DMETest do
  use ExUnit.Case
  alias NASR.Entities.ILS.DME

  describe "new/1" do
    test "creates DME struct from ILS_DME sample data" do
      sample_data = create_sample_data(%{})

      result = DME.new(sample_data)

      assert result.effective_date == ~D[2025-08-07]
      assert result.site_number == "00146."
      assert result.site_type_code == :airport
      assert result.state_code == "AL"
      assert result.airport_id == "AUO"
      assert result.city == "AUBURN"
      assert result.country_code == "US"
      assert result.runway_end_id == "36"
      assert result.ils_localizer_id == "AUO"
      assert result.system_type_code == :localizer_directional_aid
      assert result.component_status == "OPERATIONAL IFR"
      assert result.component_status_date == ~D[2022-07-28]
      assert result.latitude_degrees == 32
      assert result.latitude_minutes == 37
      assert result.latitude_seconds == 22.81
      assert result.latitude_hemisphere == :north
      assert result.latitude_decimal == 32.62300277
      assert result.longitude_degrees == 85
      assert result.longitude_minutes == 26
      assert result.longitude_seconds == 8.88
      assert result.longitude_hemisphere == :west
      assert result.longitude_decimal == -85.4358
      assert result.latitude_longitude_source_code == "F"
      assert result.site_elevation == 779.0
      assert result.channel == "38X"
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
        result = DME.new(sample_data)
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
        result = DME.new(sample_data)
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
        result = DME.new(sample_data)
        assert result.latitude_hemisphere == expected
        assert result.longitude_hemisphere == expected
      end
    end

    test "handles empty/nil values correctly" do
      sample_data = create_sample_data(%{
        "EFF_DATE" => "",
        "LAT_DEG" => "",
        "SITE_ELEVATION" => "",
        "CHANNEL" => ""
      })

      result = DME.new(sample_data)

      assert result.effective_date == nil
      assert result.latitude_degrees == nil
      assert result.site_elevation == nil
      assert result.channel == ""
    end
  end

  describe "type/0" do
    test "returns correct type string" do
      assert DME.type() == "ILS_DME"
    end
  end

  # Helper function to create sample data with default values
  defp create_sample_data(overrides) do
    Map.merge(%{
      "EFF_DATE" => "2025/08/07",
      "SITE_NO" => "00146.",
      "SITE_TYPE_CODE" => "A",
      "STATE_CODE" => "AL",
      "ARPT_ID" => "AUO",
      "CITY" => "AUBURN",
      "COUNTRY_CODE" => "US",
      "RWY_END_ID" => "36",
      "ILS_LOC_ID" => "AUO",
      "SYSTEM_TYPE_CODE" => "LD",
      "COMPONENT_STATUS" => "OPERATIONAL IFR",
      "COMPONENT_STATUS_DATE" => "2022/07/28",
      "LAT_DEG" => "32",
      "LAT_MIN" => "37",
      "LAT_SEC" => "22.81",
      "LAT_HEMIS" => "N",
      "LAT_DECIMAL" => "32.62300277",
      "LONG_DEG" => "85",
      "LONG_MIN" => "26",
      "LONG_SEC" => "8.88",
      "LONG_HEMIS" => "W",
      "LONG_DECIMAL" => "-85.4358",
      "LAT_LONG_SOURCE_CODE" => "F",
      "SITE_ELEVATION" => "779",
      "CHANNEL" => "38X"
    }, overrides)
  end
end