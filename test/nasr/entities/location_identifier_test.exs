defmodule NASR.Entities.LocationIdentifierTest do
  use ExUnit.Case

  alias NASR.Entities.LocationIdentifier

  describe "new/1" do
    test "creates struct from real-world LID sample data" do
      sample_data = %{
        "EFF_DATE" => "2025/08/07",
        "COUNTRY_CODE" => "US",
        "LOC_ID" => "00A",
        "REGION_CODE" => "AEA",
        "STATE" => "PA",
        "CITY" => "BENSALEM",
        "LID_GROUP" => "LANDING FACILITY",
        "FAC_TYPE" => "H",
        "FAC_NAME" => "TOTAL RF",
        "RESP_ARTCC_ID" => "ZNY",
        "ARTCC_COMPUTER_ID" => "ZCN",
        "FSS_ID" => "IPT"
      }

      result = LocationIdentifier.new(sample_data)

      assert result.location_id == "00A"
      assert result.country_code == "US"
      assert result.region_code == "AEA"
      assert result.state == "PA"
      assert result.city == "BENSALEM"
      assert result.lid_group == :landing_facility
      assert result.facility_type == "H"
      assert result.facility_name == "TOTAL RF"
      assert result.responsible_artcc_id == "ZNY"
      assert result.artcc_computer_id == "ZCN"
      assert result.fss_id == "IPT"
      assert result.effective_date == ~D[2025-08-07]
    end

    test "handles airport landing facility" do
      sample_data = create_sample_data(%{
        "LOC_ID" => "LAX",
        "LID_GROUP" => "LANDING FACILITY",
        "FAC_TYPE" => "A",
        "FAC_NAME" => "LOS ANGELES INTERNATIONAL"
      })

      result = LocationIdentifier.new(sample_data)

      assert result.location_id == "LAX"
      assert result.lid_group == :landing_facility
      assert result.facility_type == "A"
      assert result.facility_name == "LOS ANGELES INTERNATIONAL"
    end

    test "handles navigation aid facility" do
      sample_data = create_sample_data(%{
        "LOC_ID" => "VOR",
        "LID_GROUP" => "NAVIGATION AID",
        "FAC_TYPE" => "VOR",
        "FAC_NAME" => "TEST VOR"
      })

      result = LocationIdentifier.new(sample_data)

      assert result.location_id == "VOR"
      assert result.lid_group == :navigation_aid
      assert result.facility_type == "VOR"
      assert result.facility_name == "TEST VOR"
    end

    test "handles weather reporting station" do
      sample_data = create_sample_data(%{
        "LOC_ID" => "WX1",
        "LID_GROUP" => "WEATHER REPORTING STATION",
        "FAC_TYPE" => "AWOS-3",
        "FAC_NAME" => "AUTOMATED WEATHER STATION"
      })

      result = LocationIdentifier.new(sample_data)

      assert result.location_id == "WX1"
      assert result.lid_group == :weather_reporting_station
      assert result.facility_type == "AWOS-3"
      assert result.facility_name == "AUTOMATED WEATHER STATION"
    end

    test "handles various LID groups" do
      lid_groups = [
        {"LANDING FACILITY", :landing_facility},
        {"NAVIGATION AID", :navigation_aid},
        {"CONTROL FACILITY", :control_facility},
        {"WEATHER REPORTING STATION", :weather_reporting_station},
        {"WEATHER SENSOR", :weather_sensor},
        {"INSTRUMENT LANDING SYSTEM", :instrument_landing_system},
        {"REMOTE COMMUNICATION OUTLET", :remote_communication_outlet},
        {"SPECIAL USE RESOURCE", :special_use_resource},
        {"FLIGHT SERVICE STATION", :flight_service_station},
        {"DOD OVERSEA FACILITY", :dod_oversea_facility}
      ]

      for {input, expected} <- lid_groups do
        sample_data = create_sample_data(%{"LID_GROUP" => input})
        result = LocationIdentifier.new(sample_data)
        assert result.lid_group == expected
      end
    end

    test "handles unknown LID group as string" do
      sample_data = create_sample_data(%{"LID_GROUP" => "UNKNOWN GROUP"})
      result = LocationIdentifier.new(sample_data)
      assert result.lid_group == "UNKNOWN GROUP"
    end

    test "handles empty/nil values correctly" do
      sample_data = create_sample_data(%{
        "LID_GROUP" => "",
        "EFF_DATE" => ""
      })

      result = LocationIdentifier.new(sample_data)

      assert result.lid_group == nil
      assert result.effective_date == nil
    end

    test "handles various facility types" do
      facility_types = [
        "A",         # Airport
        "H",         # Heliport
        "VOR",       # VOR
        "VORTAC",    # VORTAC
        "NDB",       # NDB
        "AWOS-3",    # Weather station
        "ASOS",      # Weather station
        "ILS",       # ILS
        "DME"        # DME
      ]

      for fac_type <- facility_types do
        sample_data = create_sample_data(%{"FAC_TYPE" => fac_type})
        result = LocationIdentifier.new(sample_data)
        assert result.facility_type == fac_type
      end
    end

    test "handles different regional codes" do
      regions = ["AAL", "ACE", "AEA", "AGL", "ANM", "ASO", "ASW", "AWP"]

      for region <- regions do
        sample_data = create_sample_data(%{"REGION_CODE" => region})
        result = LocationIdentifier.new(sample_data)
        assert result.region_code == region
      end
    end

    test "handles case insensitive LID group parsing" do
      sample_data = create_sample_data(%{"LID_GROUP" => "landing facility"})
      result = LocationIdentifier.new(sample_data)
      assert result.lid_group == :landing_facility

      sample_data = create_sample_data(%{"LID_GROUP" => "Navigation Aid"})
      result = LocationIdentifier.new(sample_data)
      assert result.lid_group == :navigation_aid
    end

    test "type/0 returns correct type string" do
      assert LocationIdentifier.type() == "LID"
    end
  end

  # Helper function to create sample data with default values
  defp create_sample_data(overrides) do
    Map.merge(
      %{
        "EFF_DATE" => "2025/08/07",
        "COUNTRY_CODE" => "US",
        "LOC_ID" => "TEST",
        "REGION_CODE" => "AEA",
        "STATE" => "CA",
        "CITY" => "TEST CITY",
        "LID_GROUP" => "LANDING FACILITY",
        "FAC_TYPE" => "A",
        "FAC_NAME" => "TEST FACILITY",
        "RESP_ARTCC_ID" => "ZOA",
        "ARTCC_COMPUTER_ID" => "ZCO",
        "FSS_ID" => "RAL"
      },
      overrides
    )
  end
end