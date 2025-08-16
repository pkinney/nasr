defmodule NASR.Entities.HoldingPattern.RemarksTest do
  use ExUnit.Case
  alias NASR.Entities.HoldingPattern.Remarks

  describe "new/1" do
    test "creates Remarks struct from HPF_RMK sample data" do
      sample_data = create_sample_data(%{})

      result = Remarks.new(sample_data)

      assert result.effective_date == ~D[2025-08-07]
      assert result.hp_name == "ALWYZ INT*VA*K6"
      assert result.hp_no == 1
      assert result.state_code == "VA"
      assert result.country_code == "US"
      assert result.table_name == "HOLDING_PATTERN"
      assert result.reference_column_name == "GENERAL_REMARK"
      assert result.reference_column_sequence_no == 1
      assert result.remark_text == "CHART 210K ICON"
    end

    test "handles different remark types" do
      specific_remark = create_sample_data(%{
        "TAB_NAME" => "HOLDING_PATTERN",
        "REF_COL_NAME" => "SPEED_RANGE",
        "REF_COL_SEQ_NO" => "2",
        "REMARK" => "SPEED RESTRICTION APPLIES ABOVE FL180"
      })

      result = Remarks.new(specific_remark)
      assert result.table_name == "HOLDING_PATTERN"
      assert result.reference_column_name == "SPEED_RANGE"
      assert result.reference_column_sequence_no == 2
      assert result.remark_text == "SPEED RESTRICTION APPLIES ABOVE FL180"
    end

    test "handles chart icon remarks" do
      chart_icon_remark = create_sample_data(%{
        "HP_NAME" => "BILIT WP*MD*K6",
        "HP_NO" => "2",
        "REMARK" => "CHART 210K ICON"
      })

      result = Remarks.new(chart_icon_remark)
      assert result.hp_name == "BILIT WP*MD*K6"
      assert result.hp_no == 2
      assert result.remark_text == "CHART 210K ICON"
    end

    test "handles pattern-specific remarks" do
      pattern_remark = create_sample_data(%{
        "HP_NAME" => "BIG DELTA VORTAC*AK",
        "REMARK" => "CHART PAT 1 WITH 210K ICON"
      })

      result = Remarks.new(pattern_remark)
      assert result.hp_name == "BIG DELTA VORTAC*AK"
      assert result.remark_text == "CHART PAT 1 WITH 210K ICON"
    end

    test "handles different chart scale icons" do
      test_cases = [
        "CHART 100K ICON",
        "CHART 200K ICON",
        "CHART 210K ICON"
      ]

      for chart_remark <- test_cases do
        sample_data = create_sample_data(%{"REMARK" => chart_remark})
        result = Remarks.new(sample_data)
        assert result.remark_text == chart_remark
      end
    end

    test "handles empty/nil values correctly" do
      sample_data = create_sample_data(%{
        "HP_NO" => "",
        "REF_COL_SEQ_NO" => "",
        "REMARK" => ""
      })

      result = Remarks.new(sample_data)

      assert result.hp_no == nil
      assert result.reference_column_sequence_no == nil
      assert result.remark_text == ""
    end

    test "handles multiple remarks for same holding pattern" do
      remark1 = create_sample_data(%{
        "HP_NAME" => "BILIT WP*MD*K6",
        "HP_NO" => "1",
        "REF_COL_SEQ_NO" => "1",
        "REMARK" => "CHART 210K ICON"
      })

      remark2 = create_sample_data(%{
        "HP_NAME" => "BILIT WP*MD*K6",
        "HP_NO" => "2",
        "REF_COL_SEQ_NO" => "1",
        "REMARK" => "CHART 210K ICON"
      })

      remark3 = create_sample_data(%{
        "HP_NAME" => "BILIT WP*MD*K6",
        "HP_NO" => "3",
        "REF_COL_SEQ_NO" => "1",
        "REMARK" => "CHART 210K ICON"
      })

      result1 = Remarks.new(remark1)
      result2 = Remarks.new(remark2)
      result3 = Remarks.new(remark3)

      assert result1.hp_name == result2.hp_name
      assert result2.hp_name == result3.hp_name
      assert result1.hp_no == 1
      assert result2.hp_no == 2
      assert result3.hp_no == 3
      assert result1.remark_text == result2.remark_text
      assert result2.remark_text == result3.remark_text
    end

    test "handles mixed holding pattern and waypoint names" do
      # Test NDB-based holding pattern
      ndb_pattern = create_sample_data(%{
        "HP_NAME" => "BELLGROVE NDB*PA",
        "HP_NO" => "1",
        "REMARK" => "CHART 100K ICON"
      })

      # Test VORTAC-based holding pattern
      vortac_pattern = create_sample_data(%{
        "HP_NAME" => "BIG DELTA VORTAC*AK",
        "HP_NO" => "1",
        "REMARK" => "CHART PAT 1 WITH 210K ICON"
      })

      ndb_result = Remarks.new(ndb_pattern)
      vortac_result = Remarks.new(vortac_pattern)

      assert ndb_result.hp_name == "BELLGROVE NDB*PA"
      assert ndb_result.remark_text == "CHART 100K ICON"
      assert vortac_result.hp_name == "BIG DELTA VORTAC*AK"
      assert vortac_result.remark_text == "CHART PAT 1 WITH 210K ICON"
    end
  end

  describe "type/0" do
    test "returns correct type string" do
      assert Remarks.type() == "HPF_RMK"
    end
  end

  # Helper function to create sample data with default values
  defp create_sample_data(overrides) do
    Map.merge(%{
      "EFF_DATE" => "2025/08/07",
      "HP_NAME" => "ALWYZ INT*VA*K6",
      "HP_NO" => "1",
      "STATE_CODE" => "VA",
      "COUNTRY_CODE" => "US",
      "TAB_NAME" => "HOLDING_PATTERN",
      "REF_COL_NAME" => "GENERAL_REMARK",
      "REF_COL_SEQ_NO" => "1",
      "REMARK" => "CHART 210K ICON"
    }, overrides)
  end
end