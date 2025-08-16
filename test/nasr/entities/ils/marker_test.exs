defmodule NASR.Entities.ILS.MarkerTest do
  use ExUnit.Case
  alias NASR.Entities.ILS.Marker

  describe "new/1" do
    test "creates Marker struct from ILS_MKR sample data" do
      sample_data = create_sample_data(%{})

      result = Marker.new(sample_data)

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
      assert result.ils_component_type_code == "OM"
      assert result.component_status == "OPERATIONAL IFR"
      assert result.component_status_date == ~D[2011-08-30]
      assert result.latitude_degrees == 33
      assert result.latitude_minutes == 32
      assert result.latitude_seconds == 3.6585
      assert result.latitude_hemisphere == :north
      assert result.latitude_decimal == 33.53434958
      assert result.longitude_degrees == 85
      assert result.longitude_minutes == 55
      assert result.longitude_seconds == 50.8501
      assert result.longitude_hemisphere == :west
      assert result.longitude_decimal == -85.93079169
      assert result.latitude_longitude_source_code == "K"
      assert result.site_elevation == 589.9
      assert result.marker_facility_type_code == "MR"
      assert result.marker_id_beacon == "AN"
      assert result.compass_locator_name == "BOGGA"
      assert result.frequency == 211
      assert result.nav_id == "AN"
      assert result.nav_type == "NDB"
      assert result.low_powered_ndb_status == ""
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
        result = Marker.new(sample_data)
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
        result = Marker.new(sample_data)
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
        result = Marker.new(sample_data)
        assert result.latitude_hemisphere == expected
        assert result.longitude_hemisphere == expected
      end
    end

    test "handles marker types" do
      outer_marker = create_sample_data(%{
        "ILS_COMP_TYPE_CODE" => "OM",
        "MKR_FAC_TYPE_CODE" => "MR"
      })

      middle_marker = create_sample_data(%{
        "ILS_COMP_TYPE_CODE" => "MM",
        "MKR_FAC_TYPE_CODE" => "M"
      })

      inner_marker = create_sample_data(%{
        "ILS_COMP_TYPE_CODE" => "IM",
        "MKR_FAC_TYPE_CODE" => "M"
      })

      outer_result = Marker.new(outer_marker)
      middle_result = Marker.new(middle_marker)
      inner_result = Marker.new(inner_marker)

      assert outer_result.ils_component_type_code == "OM"
      assert outer_result.marker_facility_type_code == "MR"

      assert middle_result.ils_component_type_code == "MM"
      assert middle_result.marker_facility_type_code == "M"

      assert inner_result.ils_component_type_code == "IM"
      assert inner_result.marker_facility_type_code == "M"
    end

    test "handles numeric conversions" do
      test_data = create_sample_data(%{
        "FREQ" => "215",
        "SITE_ELEVATION" => "1250.8"
      })

      result = Marker.new(test_data)

      assert result.frequency == 215
      assert result.site_elevation == 1250.8
    end

    test "handles empty/nil values correctly" do
      sample_data = create_sample_data(%{
        "EFF_DATE" => "",
        "LAT_DEG" => "",
        "FREQ" => "",
        "SITE_ELEVATION" => "",
        "COMPASS_LOCATOR_NAME" => "",
        "NAV_ID" => "",
        "NAV_TYPE" => ""
      })

      result = Marker.new(sample_data)

      assert result.effective_date == nil
      assert result.latitude_degrees == nil
      assert result.frequency == nil
      assert result.site_elevation == nil
      assert result.compass_locator_name == ""
      assert result.nav_id == ""
      assert result.nav_type == ""
    end
  end

  describe "type/0" do
    test "returns correct type string" do
      assert Marker.type() == "ILS_MKR"
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
      "ILS_COMP_TYPE_CODE" => "OM",
      "COMPONENT_STATUS" => "OPERATIONAL IFR",
      "COMPONENT_STATUS_DATE" => "2011/08/30",
      "LAT_DEG" => "33",
      "LAT_MIN" => "32",
      "LAT_SEC" => "3.6585",
      "LAT_HEMIS" => "N",
      "LAT_DECIMAL" => "33.53434958",
      "LONG_DEG" => "85",
      "LONG_MIN" => "55",
      "LONG_SEC" => "50.8501",
      "LONG_HEMIS" => "W",
      "LONG_DECIMAL" => "-85.93079169",
      "LAT_LONG_SOURCE_CODE" => "K",
      "SITE_ELEVATION" => "589.9",
      "MKR_FAC_TYPE_CODE" => "MR",
      "MARKER_ID_BEACON" => "AN",
      "COMPASS_LOCATOR_NAME" => "BOGGA",
      "FREQ" => "211",
      "NAV_ID" => "AN",
      "NAV_TYPE" => "NDB",
      "LOW_POWERED_NDB_STATUS" => ""
    }, overrides)
  end
end