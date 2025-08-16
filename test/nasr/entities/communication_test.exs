defmodule NASR.Entities.CommunicationTest do
  use ExUnit.Case
  alias NASR.Entities.Communication

  describe "new/1" do
    test "creates Communication struct from CSV data" do
      raw_data = create_sample_data()

      comm = Communication.new(raw_data)

      assert comm.effective_date == ~D[2025-08-07]
      assert comm.comm_loc_id == "05U"
      assert comm.comm_type == "RCO"
      assert comm.nav_id == ""
      assert comm.nav_type == ""
      assert comm.city == "EUREKA"
      assert comm.state_code == "NV"
      assert comm.region_code == :awp
      assert comm.country_code == "US"
      assert comm.comm_outlet_name == "EUREKA"
      assert comm.lat_deg == 39
      assert comm.lat_min == 28
      assert comm.lat_sec == 46.7
      assert comm.lat_hemis == "N"
      assert comm.latitude == 39.47963888
      assert comm.long_deg == 115
      assert comm.long_min == 59
      assert comm.long_sec == 30.2
      assert comm.long_hemis == "W"
      assert comm.longitude == -115.99172222
      assert comm.facility_id == "RNO"
      assert comm.facility_name == "RENO"
      assert comm.alt_fss_id == ""
      assert comm.alt_fss_name == ""
      assert comm.oper_hours == "24"
      assert comm.comm_status_code == :active
      assert comm.comm_status_date == "2020/04/24"
      assert comm.remark == ""
    end

    test "handles all region codes" do
      region_codes = [
        {"AAL", :aal},
        {"ACE", :ace},
        {"AEA", :aea},
        {"AGL", :agl},
        {"ANE", :ane},
        {"ANM", :anm},
        {"ASO", :aso},
        {"ASW", :asw},
        {"AWP", :awp}
      ]

      for {code, expected_atom} <- region_codes do
        raw_data = create_sample_data(%{"REGION_CODE" => code})
        comm = Communication.new(raw_data)
        assert comm.region_code == expected_atom
      end
    end

    test "handles comm status codes" do
      status_codes = [
        {"A", :active},
        {"I", :inactive}
      ]

      for {code, expected_atom} <- status_codes do
        raw_data = create_sample_data(%{"COMM_STATUS_CODE" => code})
        comm = Communication.new(raw_data)
        assert comm.comm_status_code == expected_atom
      end
    end

    test "handles empty and nil values" do
      raw_data = create_sample_data(%{
        "NAV_ID" => "",
        "NAV_TYPE" => "",
        "LAT_DEG" => "",
        "LAT_MIN" => "",
        "LAT_SEC" => "",
        "LONG_DEG" => "",
        "LONG_MIN" => "",
        "LONG_SEC" => "",
        "ALT_FSS_ID" => "",
        "ALT_FSS_NAME" => "",
        "COMM_STATUS_CODE" => "",
        "COMM_STATUS_DATE" => "",
        "REMARK" => ""
      })

      comm = Communication.new(raw_data)

      assert comm.nav_id == ""
      assert comm.nav_type == ""
      assert comm.lat_deg == nil
      assert comm.lat_min == nil
      assert comm.lat_sec == nil
      assert comm.long_deg == nil
      assert comm.long_min == nil
      assert comm.long_sec == nil
      assert comm.alt_fss_id == ""
      assert comm.alt_fss_name == ""
      assert comm.comm_status_code == nil
      assert comm.comm_status_date == ""
      assert comm.remark == ""
    end

    test "handles data with remarks" do
      raw_data = create_sample_data(%{
        "COMM_LOC_ID" => "3AH",
        "REMARK" => "(COMM_LOC_ID) FREQ 122.5 ALSO AVBL AT CORDOVA MUNI & CORDOVA MUNI SEAPLANE."
      })

      comm = Communication.new(raw_data)

      assert comm.comm_loc_id == "3AH"
      assert comm.remark == "(COMM_LOC_ID) FREQ 122.5 ALSO AVBL AT CORDOVA MUNI & CORDOVA MUNI SEAPLANE."
    end

    test "handles data with alternate FSS information" do
      raw_data = create_sample_data(%{
        "ALT_FSS_ID" => "JNU",
        "ALT_FSS_NAME" => "JUNEAU"
      })

      comm = Communication.new(raw_data)

      assert comm.alt_fss_id == "JNU"
      assert comm.alt_fss_name == "JUNEAU"
    end

    test "handles unknown region and status codes" do
      raw_data = create_sample_data(%{
        "REGION_CODE" => "XYZ",
        "COMM_STATUS_CODE" => "X"
      })

      comm = Communication.new(raw_data)

      assert comm.region_code == "XYZ"
      assert comm.comm_status_code == "X"
    end

    test "handles fractional seconds in coordinates" do
      raw_data = create_sample_data(%{
        "LAT_SEC" => "46.7",
        "LONG_SEC" => "30.2"
      })

      comm = Communication.new(raw_data)

      assert comm.lat_sec == 46.7
      assert comm.long_sec == 30.2
    end
  end

  describe "type/0" do
    test "returns correct type string" do
      assert Communication.type() == "COM"
    end
  end

  defp create_sample_data(overrides \\ %{}) do
    %{
      "EFF_DATE" => "2025/08/07",
      "COMM_LOC_ID" => "05U",
      "COMM_TYPE" => "RCO",
      "NAV_ID" => "",
      "NAV_TYPE" => "",
      "CITY" => "EUREKA",
      "STATE_CODE" => "NV",
      "REGION_CODE" => "AWP",
      "COUNTRY_CODE" => "US",
      "COMM_OUTLET_NAME" => "EUREKA",
      "LAT_DEG" => "39",
      "LAT_MIN" => "28",
      "LAT_SEC" => "46.7",
      "LAT_HEMIS" => "N",
      "LAT_DECIMAL" => "39.47963888",
      "LONG_DEG" => "115",
      "LONG_MIN" => "59",
      "LONG_SEC" => "30.2",
      "LONG_HEMIS" => "W",
      "LONG_DECIMAL" => "-115.99172222",
      "FACILITY_ID" => "RNO",
      "FACILITY_NAME" => "RENO",
      "ALT_FSS_ID" => "",
      "ALT_FSS_NAME" => "",
      "OPR_HRS" => "24",
      "COMM_STATUS_CODE" => "A",
      "COMM_STATUS_DATE" => "2020/04/24",
      "REMARK" => ""
    }
    |> Map.merge(overrides)
  end
end