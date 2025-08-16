defmodule NASR.Entities.ILS.RemarksTest do
  use ExUnit.Case
  alias NASR.Entities.ILS.Remarks

  describe "new/1" do
    test "creates Remarks struct from ILS_RMK sample data" do
      sample_data = create_sample_data(%{})

      result = Remarks.new(sample_data)

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
      assert result.table_name == "ILS"
      assert result.ils_component_type_code == ""
      assert result.reference_column_name == "GENERAL_REMARK"
      assert result.reference_column_sequence_no == 2
      assert result.remark_text == "ILS CLASSIFICATION CODE IA"
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
        result = Remarks.new(sample_data)
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
        result = Remarks.new(sample_data)
        assert result.system_type_code == expected
      end
    end

    test "handles different remark types" do
      specific_remark = create_sample_data(%{
        "TAB_NAME" => "ILS",
        "ILS_COMP_TYPE_CODE" => "LOC",
        "REF_COL_NAME" => "FREQ",
        "REF_COL_SEQ_NO" => "1",
        "REMARK" => "LOC FREQUENCY SUBJECT TO CHANGE NOTAM"
      })

      result = Remarks.new(specific_remark)
      assert result.table_name == "ILS"
      assert result.ils_component_type_code == "LOC"
      assert result.reference_column_name == "FREQ"
      assert result.reference_column_sequence_no == 1
      assert result.remark_text == "LOC FREQUENCY SUBJECT TO CHANGE NOTAM"
    end

    test "handles localizer restrictions" do
      localizer_remark = create_sample_data(%{
        "REF_COL_NAME" => "GENERAL_REMARK",
        "REF_COL_SEQ_NO" => "3",
        "REMARK" => "LOC UNUSBL WI 0.6 NM; BYD 16 DEGS RIGHT OF CRS."
      })

      result = Remarks.new(localizer_remark)
      assert result.reference_column_name == "GENERAL_REMARK"
      assert result.reference_column_sequence_no == 3
      assert result.remark_text == "LOC UNUSBL WI 0.6 NM; BYD 16 DEGS RIGHT OF CRS."
    end

    test "handles empty/nil values correctly" do
      sample_data = create_sample_data(%{
        "REF_COL_SEQ_NO" => "",
        "REMARK" => "",
        "ILS_COMP_TYPE_CODE" => ""
      })

      result = Remarks.new(sample_data)

      assert result.reference_column_sequence_no == nil
      assert result.remark_text == ""
      assert result.ils_component_type_code == ""
    end

    test "handles multiple remarks for same ILS" do
      remark1 = create_sample_data(%{
        "REF_COL_NAME" => "GENERAL_REMARK",
        "REF_COL_SEQ_NO" => "2",
        "REMARK" => "ILS CLASSIFICATION CODE IA"
      })

      remark2 = create_sample_data(%{
        "REF_COL_NAME" => "GENERAL_REMARK",
        "REF_COL_SEQ_NO" => "3",
        "REMARK" => "LOC UNUSBL WI 0.6 NM; BYD 16 DEGS RIGHT OF CRS."
      })

      result1 = Remarks.new(remark1)
      result2 = Remarks.new(remark2)

      assert result1.reference_column_sequence_no == 2
      assert result1.remark_text == "ILS CLASSIFICATION CODE IA"
      assert result2.reference_column_sequence_no == 3
      assert result2.remark_text == "LOC UNUSBL WI 0.6 NM; BYD 16 DEGS RIGHT OF CRS."
    end
  end

  describe "type/0" do
    test "returns correct type string" do
      assert Remarks.type() == "ILS_RMK"
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
      "TAB_NAME" => "ILS",
      "ILS_COMP_TYPE_CODE" => "",
      "REF_COL_NAME" => "GENERAL_REMARK",
      "REF_COL_SEQ_NO" => "2",
      "REMARK" => "ILS CLASSIFICATION CODE IA"
    }, overrides)
  end
end