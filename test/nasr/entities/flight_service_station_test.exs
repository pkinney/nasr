defmodule NASR.Entities.FlightServiceStationTest do
  use ExUnit.Case
  alias NASR.Entities.FlightServiceStation

  describe "new/1" do
    test "creates FlightServiceStation struct from CSV data" do
      raw_data = create_sample_data()

      fss = FlightServiceStation.new(raw_data)

      assert fss.effective_date == ~D[2025-08-07]
      assert fss.fss_id == "ABQ"
      assert fss.name == "ALBUQUERQUE"
      assert fss.update_date == ~D[2024-11-27]
      assert fss.facility_type == :radio
      assert fss.voice_call == "ALBUQUERQUE"
      assert fss.city == "ALBUQUERQUE"
      assert fss.state_code == "NM"
      assert fss.country_code == "US"
      assert fss.latitude_degrees == 35
      assert fss.latitude_minutes == 2
      assert fss.latitude_seconds == 20.1536
      assert fss.latitude_hemisphere == "N"
      assert fss.latitude == 35.03893155
      assert fss.longitude_degrees == 106
      assert fss.longitude_minutes == 36
      assert fss.longitude_seconds == 29.7438
      assert fss.longitude_hemisphere == "W"
      assert fss.longitude == -106.60826216
      assert fss.operating_hours == "24"
      assert fss.facility_status == :active
      assert fss.alternate_fss == ""
      assert fss.weather_radar_flag == false
      assert fss.phone_number == ""
      assert fss.toll_free_number == "1-800-WX-BRIEF"
    end

    test "handles FSS facility type" do
      raw_data = create_sample_data_fss()

      fss = FlightServiceStation.new(raw_data)

      assert fss.facility_type == :fss
      assert fss.operating_hours == "0600-2200; OT CTC FAIRBANKS FSS."
      assert fss.alternate_fss == "FAI"
      assert fss.phone_number == "907-852-2511"
      assert fss.toll_free_number == "LC852-2511"
    end

    test "handles HUB facility type" do
      raw_data = create_sample_data_hub()

      fss = FlightServiceStation.new(raw_data)

      assert fss.facility_type == :hub
      assert fss.fss_id == "DCA"
      assert fss.name == "LEESBURG"
      assert fss.voice_call == "LEESBURG"
      assert fss.city == "WASHINGTON"
      assert fss.state_code == "DC"
    end

    test "handles nil and empty values" do
      raw_data = %{
        "EFF_DATE" => "",
        "FSS_ID" => "TEST",
        "NAME" => "TEST FSS",
        "UPDATE_DATE" => "",
        "FSS_FAC_TYPE" => "",
        "VOICE_CALL" => "",
        "CITY" => "",
        "STATE_CODE" => "",
        "COUNTRY_CODE" => "",
        "LAT_DEG" => "",
        "LAT_MIN" => "",
        "LAT_SEC" => "",
        "LAT_HEMIS" => "",
        "LAT_DECIMAL" => "",
        "LONG_DEG" => "",
        "LONG_MIN" => "",
        "LONG_SEC" => "",
        "LONG_HEMIS" => "",
        "LONG_DECIMAL" => "",
        "OPR_HOURS" => "",
        "FAC_STATUS" => "",
        "ALTERNATE_FSS" => "",
        "WEA_RADAR_FLAG" => "",
        "PHONE_NO" => "",
        "TOLL_FREE_NO" => ""
      }

      fss = FlightServiceStation.new(raw_data)

      assert fss.effective_date == nil
      assert fss.fss_id == "TEST"
      assert fss.name == "TEST FSS"
      assert fss.update_date == nil
      assert fss.facility_type == nil
      assert fss.latitude_degrees == nil
      assert fss.latitude_minutes == nil
      assert fss.latitude_seconds == nil
      assert fss.latitude == nil
      assert fss.longitude_degrees == nil
      assert fss.longitude_minutes == nil
      assert fss.longitude_seconds == nil
      assert fss.longitude == nil
      assert fss.facility_status == nil
      assert fss.weather_radar_flag == nil
    end

    test "handles Y/N weather radar flag" do
      raw_data_with_radar = Map.put(create_sample_data(), "WEA_RADAR_FLAG", "Y")
      fss = FlightServiceStation.new(raw_data_with_radar)
      assert fss.weather_radar_flag == true

      raw_data_no_radar = Map.put(create_sample_data(), "WEA_RADAR_FLAG", "N")
      fss = FlightServiceStation.new(raw_data_no_radar)
      assert fss.weather_radar_flag == false
    end

    test "handles inactive facility status" do
      raw_data = Map.put(create_sample_data(), "FAC_STATUS", "I")
      fss = FlightServiceStation.new(raw_data)
      assert fss.facility_status == :inactive
    end

    test "preserves unknown facility types and statuses" do
      raw_data = create_sample_data()
        |> Map.put("FSS_FAC_TYPE", "UNKNOWN_TYPE")
        |> Map.put("FAC_STATUS", "X")

      fss = FlightServiceStation.new(raw_data)

      assert fss.facility_type == "UNKNOWN_TYPE"
      assert fss.facility_status == "X"
    end
  end

  describe "type/0" do
    test "returns the correct CSV type" do
      assert FlightServiceStation.type() == "FSS_BASE"
    end
  end

  # Helper functions for creating test data
  defp create_sample_data do
    %{
      "EFF_DATE" => "2025/08/07",
      "FSS_ID" => "ABQ",
      "NAME" => "ALBUQUERQUE",
      "UPDATE_DATE" => "2024/11/27",
      "FSS_FAC_TYPE" => "RADIO",
      "VOICE_CALL" => "ALBUQUERQUE",
      "CITY" => "ALBUQUERQUE",
      "STATE_CODE" => "NM",
      "COUNTRY_CODE" => "US",
      "LAT_DEG" => "35",
      "LAT_MIN" => "2",
      "LAT_SEC" => "20.1536",
      "LAT_HEMIS" => "N",
      "LAT_DECIMAL" => "35.03893155",
      "LONG_DEG" => "106",
      "LONG_MIN" => "36",
      "LONG_SEC" => "29.7438",
      "LONG_HEMIS" => "W",
      "LONG_DECIMAL" => "-106.60826216",
      "OPR_HOURS" => "24",
      "FAC_STATUS" => "A",
      "ALTERNATE_FSS" => "",
      "WEA_RADAR_FLAG" => "N",
      "PHONE_NO" => "",
      "TOLL_FREE_NO" => "1-800-WX-BRIEF"
    }
  end

  defp create_sample_data_fss do
    %{
      "EFF_DATE" => "2025/08/07",
      "FSS_ID" => "BRW",
      "NAME" => "BARROW",
      "UPDATE_DATE" => "2024/11/26",
      "FSS_FAC_TYPE" => "FSS",
      "VOICE_CALL" => "BARROW",
      "CITY" => "UTQIAGVIK",
      "STATE_CODE" => "AK",
      "COUNTRY_CODE" => "US",
      "LAT_DEG" => "71",
      "LAT_MIN" => "17",
      "LAT_SEC" => "5.5",
      "LAT_HEMIS" => "N",
      "LAT_DECIMAL" => "71.28486111",
      "LONG_DEG" => "156",
      "LONG_MIN" => "46",
      "LONG_SEC" => "6.9",
      "LONG_HEMIS" => "W",
      "LONG_DECIMAL" => "-156.76858333",
      "OPR_HOURS" => "0600-2200; OT CTC FAIRBANKS FSS.",
      "FAC_STATUS" => "A",
      "ALTERNATE_FSS" => "FAI",
      "WEA_RADAR_FLAG" => "N",
      "PHONE_NO" => "907-852-2511",
      "TOLL_FREE_NO" => "LC852-2511"
    }
  end

  defp create_sample_data_hub do
    %{
      "EFF_DATE" => "2025/08/07",
      "FSS_ID" => "DCA",
      "NAME" => "LEESBURG",
      "UPDATE_DATE" => "2023/04/17",
      "FSS_FAC_TYPE" => "HUB",
      "VOICE_CALL" => "LEESBURG",
      "CITY" => "WASHINGTON",
      "STATE_CODE" => "DC",
      "COUNTRY_CODE" => "US",
      "LAT_DEG" => "39",
      "LAT_MIN" => "0",
      "LAT_SEC" => "13.75",
      "LAT_HEMIS" => "N",
      "LAT_DECIMAL" => "39.00381944",
      "LONG_DEG" => "77",
      "LONG_MIN" => "29",
      "LONG_SEC" => "13.84",
      "LONG_HEMIS" => "W",
      "LONG_DECIMAL" => "-77.48717777",
      "OPR_HOURS" => "24",
      "FAC_STATUS" => "A",
      "ALTERNATE_FSS" => "",
      "WEA_RADAR_FLAG" => "N",
      "PHONE_NO" => "",
      "TOLL_FREE_NO" => "1-800-WX-BRIEF"
    }
  end
end