defmodule NASR.Entities.Nav.RemarksTest do
  use ExUnit.Case
  alias NASR.Entities.Nav.Remarks

  describe "new/1" do
    test "creates Remarks struct from NAV_RMK sample data" do
      sample_data = create_sample_data(%{})

      result = Remarks.new(sample_data)

      assert result.effective_date == ~D[2025-08-07]
      assert result.nav_id == "AA"
      assert result.nav_type == "NDB"
      assert result.state_code == "GA"
      assert result.city == "THOMSON"
      assert result.country_code == "US"
      assert result.table_name == "NAVIGATION_AID"
      assert result.reference_column_name == "GENERAL_REMARK"
      assert result.reference_column_sequence_no == 1
      assert result.remark_text == "NDB UNUSBL BYD 15 NM."
    end

    test "handles different remark types" do
      specific_remark = create_sample_data(%{
        "TAB_NAME" => "NAVIGATION_AID",
        "REF_COL_NAME" => "FREQ",
        "REF_COL_SEQ_NO" => "2",
        "REMARK" => "FREQ SUBJECT TO CHANGE NOTAM"
      })

      result = Remarks.new(specific_remark)
      assert result.table_name == "NAVIGATION_AID"
      assert result.reference_column_name == "FREQ"
      assert result.reference_column_sequence_no == 2
      assert result.remark_text == "FREQ SUBJECT TO CHANGE NOTAM"
    end

    test "handles empty/nil values correctly" do
      sample_data = create_sample_data(%{
        "REF_COL_SEQ_NO" => "",
        "REMARK" => ""
      })

      result = Remarks.new(sample_data)

      assert result.reference_column_sequence_no == nil
      assert result.remark_text == ""
    end

    test "handles multiple remarks for same navaid" do
      remark1 = create_sample_data(%{
        "REF_COL_NAME" => "GENERAL_REMARK",
        "REF_COL_SEQ_NO" => "1",
        "REMARK" => "FIRST GENERAL REMARK"
      })

      remark2 = create_sample_data(%{
        "REF_COL_NAME" => "GENERAL_REMARK",
        "REF_COL_SEQ_NO" => "2",
        "REMARK" => "SECOND GENERAL REMARK"
      })

      result1 = Remarks.new(remark1)
      result2 = Remarks.new(remark2)

      assert result1.reference_column_sequence_no == 1
      assert result1.remark_text == "FIRST GENERAL REMARK"
      assert result2.reference_column_sequence_no == 2
      assert result2.remark_text == "SECOND GENERAL REMARK"
    end
  end

  describe "type/0" do
    test "returns correct type string" do
      assert Remarks.type() == "NAV_RMK"
    end
  end

  # Helper function to create sample data with default values
  defp create_sample_data(overrides) do
    Map.merge(%{
      "EFF_DATE" => "2025/08/07",
      "NAV_ID" => "AA",
      "NAV_TYPE" => "NDB",
      "STATE_CODE" => "GA",
      "CITY" => "THOMSON",
      "COUNTRY_CODE" => "US",
      "TAB_NAME" => "NAVIGATION_AID",
      "REF_COL_NAME" => "GENERAL_REMARK",
      "REF_COL_SEQ_NO" => "1",
      "REMARK" => "NDB UNUSBL BYD 15 NM."
    }, overrides)
  end
end