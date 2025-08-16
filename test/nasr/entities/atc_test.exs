defmodule NASR.Entities.ATCTest do
  use ExUnit.Case
  alias NASR.Entities.ATC

  describe "new/1" do
    test "creates ATC struct from ATC_BASE sample data" do
      sample_data = create_sample_data(%{})

      result = ATC.new(sample_data)

      assert result.effective_date == ~D[2025-08-07]
      assert result.site_number == "24226.1"
      assert result.site_type_code == :airport
      assert result.facility_type == "NON-ATCT"
      assert result.state_code == "TX"
      assert result.facility_id == "00R"
      assert result.city == "LIVINGSTON"
      assert result.country_code == "US"
      assert result.icao_id == ""
      assert result.facility_name == "LIVINGSTON MUNI"
      assert result.region_code == "ASW"
      assert result.tower_operator_code == ""
      assert result.tower_call == ""
      assert result.tower_hours == ""
      assert result.primary_approach_radio_call == "HOUSTON ARTCC"
      assert result.approach_primary_provider == "ZHU"
      assert result.approach_primary_provider_type_code == "C"
      assert result.secondary_approach_radio_call == ""
      assert result.approach_secondary_provider == ""
      assert result.approach_secondary_provider_type_code == ""
      assert result.primary_departure_radio_call == "HOUSTON ARTCC"
      assert result.departure_primary_provider == "ZHU"
      assert result.departure_primary_provider_type_code == "C"
      assert result.secondary_departure_radio_call == ""
      assert result.departure_secondary_provider == ""
      assert result.departure_secondary_provider_type_code == ""
      assert result.control_facility_approach_departure_calls == ""
      assert result.approach_departure_operator_code == ""
      assert result.control_providing_hours == ""
      assert result.secondary_control_providing_hours == ""
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
        result = ATC.new(sample_data)
        assert result.site_type_code == expected
      end
    end

    test "handles tower-controlled facility" do
      tower_data = create_sample_data(%{
        "FACILITY_TYPE" => "ATCT",
        "TWR_OPERATOR_CODE" => "F",
        "TWR_CALL" => "ATLANTA TOWER",
        "TWR_HRS" => "0700-2300",
        "ICAO_ID" => "KATL"
      })

      result = ATC.new(tower_data)

      assert result.facility_type == "ATCT"
      assert result.tower_operator_code == "F"
      assert result.tower_call == "ATLANTA TOWER"
      assert result.tower_hours == "0700-2300"
      assert result.icao_id == "KATL"
    end

    test "handles approach and departure control services" do
      tracon_data = create_sample_data(%{
        "FACILITY_TYPE" => "TRACON",
        "PRIMARY_APCH_RADIO_CALL" => "ATLANTA APPROACH",
        "APCH_P_PROVIDER" => "A80",
        "APCH_P_PROV_TYPE_CD" => "T",
        "PRIMARY_DEP_RADIO_CALL" => "ATLANTA DEPARTURE",
        "DEP_P_PROVIDER" => "A80",
        "DEP_P_PROV_TYPE_CD" => "T"
      })

      result = ATC.new(tracon_data)

      assert result.facility_type == "TRACON"
      assert result.primary_approach_radio_call == "ATLANTA APPROACH"
      assert result.approach_primary_provider == "A80"
      assert result.approach_primary_provider_type_code == "T"
      assert result.primary_departure_radio_call == "ATLANTA DEPARTURE"
      assert result.departure_primary_provider == "A80"
      assert result.departure_primary_provider_type_code == "T"
    end

    test "handles empty/nil values correctly" do
      sample_data = create_sample_data(%{
        "EFF_DATE" => "",
        "ICAO_ID" => "",
        "TWR_OPERATOR_CODE" => "",
        "TWR_CALL" => "",
        "TWR_HRS" => ""
      })

      result = ATC.new(sample_data)

      assert result.effective_date == nil
      assert result.icao_id == ""
      assert result.tower_operator_code == ""
      assert result.tower_call == ""
      assert result.tower_hours == ""
    end
  end

  describe "type/0" do
    test "returns correct type string" do
      assert ATC.type() == "ATC_BASE"
    end
  end

  # Helper function to create sample data with default values
  defp create_sample_data(overrides) do
    Map.merge(%{
      "EFF_DATE" => "2025/08/07",
      "SITE_NO" => "24226.1",
      "SITE_TYPE_CODE" => "A",
      "FACILITY_TYPE" => "NON-ATCT",
      "STATE_CODE" => "TX",
      "FACILITY_ID" => "00R",
      "CITY" => "LIVINGSTON",
      "COUNTRY_CODE" => "US",
      "ICAO_ID" => "",
      "FACILITY_NAME" => "LIVINGSTON MUNI",
      "REGION_CODE" => "ASW",
      "TWR_OPERATOR_CODE" => "",
      "TWR_CALL" => "",
      "TWR_HRS" => "",
      "PRIMARY_APCH_RADIO_CALL" => "HOUSTON ARTCC",
      "APCH_P_PROVIDER" => "ZHU",
      "APCH_P_PROV_TYPE_CD" => "C",
      "SECONDARY_APCH_RADIO_CALL" => "",
      "APCH_S_PROVIDER" => "",
      "APCH_S_PROV_TYPE_CD" => "",
      "PRIMARY_DEP_RADIO_CALL" => "HOUSTON ARTCC",
      "DEP_P_PROVIDER" => "ZHU",
      "DEP_P_PROV_TYPE_CD" => "C",
      "SECONDARY_DEP_RADIO_CALL" => "",
      "DEP_S_PROVIDER" => "",
      "DEP_S_PROV_TYPE_CD" => "",
      "CTL_FAC_APCH_DEP_CALLS" => "",
      "APCH_DEP_OPER_CODE" => "",
      "CTL_PRVDING_HRS" => "",
      "SECONDARY_CTL_PRVDING_HRS" => ""
    }, overrides)
  end
end