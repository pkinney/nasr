defmodule NASR.Entities.Airport.RemarksTest do
  use ExUnit.Case

  describe "new/1" do
    test "creates struct from airport remarks data" do
      sample_data = %{
        "SITE_NO" => "04513.0*A",
        "SITE_TYPE_CODE" => "AIRPORT",
        "ARPT_ID" => "LAX",
        "CITY" => "LOS ANGELES",
        "STATE_CODE" => "CA",
        "COUNTRY_CODE" => "US",
        "LEGACY_ELEMENT_NUMBER" => "A81",
        "TAB_NAME" => "RUNWAY",
        "REF_COL_NAME" => "RWY_ID",
        "ELEMENT" => "07R/25L",
        "REF_COL_SEQ_NO" => "1",
        "REMARK" => "RUNWAY 07R/25L HAS GROOVED ASPHALT SURFACE.",
        "EFF_DATE" => "2025/08/07"
      }

      result = NASR.Entities.Airport.Remarks.new(sample_data)

      assert result.site_no == "04513.0*A"
      assert result.arpt_id == "LAX"
      assert result.city == "LOS ANGELES"
      assert result.state_code == "CA"
      assert result.country_code == "US"
      assert result.legacy_element_number == "A81"
      assert result.table_name == "RUNWAY"
      assert result.reference_column_name == "RWY_ID"
      assert result.element == "07R/25L"
      assert result.reference_column_sequence_no == 1
      assert result.remark_text == "RUNWAY 07R/25L HAS GROOVED ASPHALT SURFACE."
      assert result.effective_date == ~D[2025-08-07]
    end

    test "handles various table names and reference columns" do
      test_cases = [
        {"AIRPORT ATTEND SCHED", "SKED SEQ NO", "1"},
        {"AIRPORT CONTACT", "TITLE", "MANAGER"},
        {"AIRPORT SERVICE", "SERVICE TYPE CODE", "FUEL"},
        {"ARRESTING DEVICE", "RWY END ID _ ARREST DEVICE CODE", "07R_BAK-12"},
        {"FUEL TYPE", "FUEL TYPE", "100LL"},
        {"RUNWAY", "RWY_ID", "07R/25L"},
        {"RUNWAY END", "RWY END ID", "07R"},
        {"RUNWAY END OBSTN", "RWY END ID", "25L"},
        {"RUNWAY SURFACE TYPE", "RWY ID", "07R/25L"}
      ]

      for {table, column, element} <- test_cases do
        sample_data = create_sample_data(%{
          "TAB_NAME" => table,
          "REF_COL_NAME" => column,
          "ELEMENT" => element
        })
        result = NASR.Entities.Airport.Remarks.new(sample_data)
        
        assert result.table_name == table
        assert result.reference_column_name == column
        assert result.element == element
      end
    end

    test "handles general remarks" do
      sample_data = create_sample_data(%{
        "TAB_NAME" => "AIRPORT",
        "REF_COL_NAME" => "GENERAL_REMARK",
        "ELEMENT" => "",
        "REMARK" => "AIRPORT IS LOCATED IN CLASS B AIRSPACE."
      })
      
      result = NASR.Entities.Airport.Remarks.new(sample_data)
      
      assert result.table_name == "AIRPORT"
      assert result.reference_column_name == "GENERAL_REMARK"
      assert result.element == ""
      assert result.remark_text == "AIRPORT IS LOCATED IN CLASS B AIRSPACE."
    end

    test "handles sequence numbers correctly" do
      test_cases = [
        {"1", 1},
        {"2", 2},
        {"10", 10},
        {"", nil},
        {nil, nil}
      ]

      for {input, expected} <- test_cases do
        sample_data = create_sample_data(%{"REF_COL_SEQ_NO" => input})
        result = NASR.Entities.Airport.Remarks.new(sample_data)
        assert result.reference_column_sequence_no == expected
      end
    end

    test "handles various legacy element numbers" do
      test_cases = [
        "A81",
        "A14",
        "A25",
        "E147",
        "R20"
      ]

      for element_number <- test_cases do
        sample_data = create_sample_data(%{"LEGACY_ELEMENT_NUMBER" => element_number})
        result = NASR.Entities.Airport.Remarks.new(sample_data)
        assert result.legacy_element_number == element_number
      end
    end

    test "handles long remark text" do
      long_remark = "THIS IS A VERY LONG REMARK THAT CONTAINS DETAILED INFORMATION " <>
                   "ABOUT THE AIRPORT FACILITY, INCLUDING OPERATIONAL PROCEDURES, " <>
                   "SPECIAL CONDITIONS, AND OTHER IMPORTANT NOTES FOR PILOTS AND " <>
                   "AIRPORT OPERATIONS PERSONNEL."
      
      sample_data = create_sample_data(%{"REMARK" => long_remark})
      result = NASR.Entities.Airport.Remarks.new(sample_data)
      
      assert result.remark_text == long_remark
    end

    test "handles runway-specific remarks" do
      sample_data = create_sample_data(%{
        "TAB_NAME" => "RUNWAY",
        "REF_COL_NAME" => "RWY_ID",
        "ELEMENT" => "09/27",
        "REMARK" => "DISPLACED THRESHOLD ON RWY 09, 200 FT.",
        "REF_COL_SEQ_NO" => "1"
      })
      
      result = NASR.Entities.Airport.Remarks.new(sample_data)
      
      assert result.table_name == "RUNWAY"
      assert result.reference_column_name == "RWY_ID"
      assert result.element == "09/27"
      assert result.reference_column_sequence_no == 1
      assert result.remark_text == "DISPLACED THRESHOLD ON RWY 09, 200 FT."
    end

    test "parses dates correctly" do
      sample_data = create_sample_data(%{"EFF_DATE" => "2023/12/15"})
      result = NASR.Entities.Airport.Remarks.new(sample_data)
      assert result.effective_date == ~D[2023-12-15]
    end
  end

  test "type/0 returns correct CSV filename" do
    assert NASR.Entities.Airport.Remarks.type() == "APT_RMK"
  end

  # Helper function to create sample data with default values
  defp create_sample_data(overrides) do
    Map.merge(%{
      "SITE_NO" => "12345.*A",
      "SITE_TYPE_CODE" => "AIRPORT",
      "ARPT_ID" => "TEST",
      "CITY" => "TEST CITY",
      "STATE_CODE" => "TX",
      "COUNTRY_CODE" => "US",
      "LEGACY_ELEMENT_NUMBER" => "A81",
      "TAB_NAME" => "RUNWAY",
      "REF_COL_NAME" => "RWY_ID",
      "ELEMENT" => "01/19",
      "REF_COL_SEQ_NO" => "1",
      "REMARK" => "TEST REMARK TEXT.",
      "EFF_DATE" => "2025/08/07"
    }, overrides)
  end
end