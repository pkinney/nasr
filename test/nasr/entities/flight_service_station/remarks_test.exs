defmodule NASR.Entities.FlightServiceStation.RemarksTest do
  use ExUnit.Case
  alias NASR.Entities.FlightServiceStation.Remarks

  describe "new/1" do
    test "creates FlightServiceStation.Remarks struct from CSV data" do
      raw_data = create_sample_data()

      remarks = Remarks.new(raw_data)

      assert remarks.effective_date == ~D[2025-08-07]
      assert remarks.fss_id == "BRW"
      assert remarks.name == "BARROW"
      assert remarks.city == "UTQIAGVIK"
      assert remarks.state_code == "AK"
      assert remarks.country_code == "US"
      assert remarks.reference_column_name == "GENERAL_REMARK"
      assert remarks.reference_column_sequence == 1
      assert remarks.remark_text == "FREQ 121.9 USED FOR COMM WITH SNOW PLOWS."
    end

    test "handles phone number remarks" do
      raw_data = create_sample_phone_remark()

      remarks = Remarks.new(raw_data)

      assert remarks.fss_id == "DLG"
      assert remarks.name == "DILLINGHAM"
      assert remarks.reference_column_name == "PHONE_NO"
      assert remarks.reference_column_sequence == 1
      assert remarks.remark_text == "FOR A LONG DISTANCE CALL TO DILLINGHAM FSS DIAL 907-842-5275"
    end

    test "handles multiple general remarks with sequence numbers" do
      raw_data = create_sample_kenai_remark()

      remarks = Remarks.new(raw_data)

      assert remarks.fss_id == "ENA"
      assert remarks.name == "KENAI"
      assert remarks.reference_column_name == "GENERAL_REMARK"
      assert remarks.reference_column_sequence == 3
      assert remarks.remark_text == "DOPPLER VHF/DF AVAILABLE FOR KODIAK ARPT; DF LOCATED AT LAT 60-34-50.947N LONG 151-15-08.028W"
    end

    test "handles frequency information remarks" do
      raw_data = create_sample_frequency_remark()

      remarks = Remarks.new(raw_data)

      assert remarks.fss_id == "HNL"
      assert remarks.name == "HONOLULU"
      assert remarks.reference_column_name == "GENERAL_REMARK"
      assert remarks.reference_column_sequence == 8
      assert remarks.remark_text == "FREQ 8903 CENTRAL WEST PACIFIC FAMILY; 8951 NORTH PACIFIC FAMILY."
    end

    test "handles nil and empty values" do
      raw_data = %{
        "EFF_DATE" => "",
        "FSS_ID" => "TEST",
        "NAME" => "TEST FSS",
        "CITY" => "",
        "STATE_CODE" => "",
        "COUNTRY_CODE" => "",
        "REF_COL_NAME" => "",
        "REF_COL_SEQ_NO" => "",
        "REMARK" => ""
      }

      remarks = Remarks.new(raw_data)

      assert remarks.effective_date == nil
      assert remarks.fss_id == "TEST"
      assert remarks.name == "TEST FSS"
      assert remarks.city == ""
      assert remarks.state_code == ""
      assert remarks.country_code == ""
      assert remarks.reference_column_name == ""
      assert remarks.reference_column_sequence == nil
      assert remarks.remark_text == ""
    end

    test "handles zero sequence number" do
      raw_data = create_sample_data()
        |> Map.put("REF_COL_SEQ_NO", "0")

      remarks = Remarks.new(raw_data)

      assert remarks.reference_column_sequence == 0
    end

    test "handles large sequence numbers" do
      raw_data = create_sample_data()
        |> Map.put("REF_COL_SEQ_NO", "14")

      remarks = Remarks.new(raw_data)

      assert remarks.reference_column_sequence == 14
    end
  end

  describe "type/0" do
    test "returns the correct CSV type" do
      assert Remarks.type() == "FSS_RMK"
    end
  end

  # Helper functions for creating test data
  defp create_sample_data do
    %{
      "EFF_DATE" => "2025/08/07",
      "FSS_ID" => "BRW",
      "NAME" => "BARROW",
      "CITY" => "UTQIAGVIK",
      "STATE_CODE" => "AK",
      "COUNTRY_CODE" => "US",
      "REF_COL_NAME" => "GENERAL_REMARK",
      "REF_COL_SEQ_NO" => "1",
      "REMARK" => "FREQ 121.9 USED FOR COMM WITH SNOW PLOWS."
    }
  end

  defp create_sample_phone_remark do
    %{
      "EFF_DATE" => "2025/08/07",
      "FSS_ID" => "DLG",
      "NAME" => "DILLINGHAM",
      "CITY" => "DILLINGHAM",
      "STATE_CODE" => "AK",
      "COUNTRY_CODE" => "US",
      "REF_COL_NAME" => "PHONE_NO",
      "REF_COL_SEQ_NO" => "1",
      "REMARK" => "FOR A LONG DISTANCE CALL TO DILLINGHAM FSS DIAL 907-842-5275"
    }
  end

  defp create_sample_kenai_remark do
    %{
      "EFF_DATE" => "2025/08/07",
      "FSS_ID" => "ENA",
      "NAME" => "KENAI",
      "CITY" => "KENAI",
      "STATE_CODE" => "AK",
      "COUNTRY_CODE" => "US",
      "REF_COL_NAME" => "GENERAL_REMARK",
      "REF_COL_SEQ_NO" => "3",
      "REMARK" => "DOPPLER VHF/DF AVAILABLE FOR KODIAK ARPT; DF LOCATED AT LAT 60-34-50.947N LONG 151-15-08.028W"
    }
  end

  defp create_sample_frequency_remark do
    %{
      "EFF_DATE" => "2025/08/07",
      "FSS_ID" => "HNL",
      "NAME" => "HONOLULU",
      "CITY" => "HONOLULU",
      "STATE_CODE" => "HI",
      "COUNTRY_CODE" => "US",
      "REF_COL_NAME" => "GENERAL_REMARK",
      "REF_COL_SEQ_NO" => "8",
      "REMARK" => "FREQ 8903 CENTRAL WEST PACIFIC FAMILY; 8951 NORTH PACIFIC FAMILY."
    }
  end
end