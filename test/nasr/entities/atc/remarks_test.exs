defmodule NASR.Entities.ATC.RemarksTest do
  use ExUnit.Case
  alias NASR.Entities.ATC.Remarks

  describe "new/1" do
    test "creates Remarks struct from ATC_RMK sample data" do
      sample_data = create_sample_data(%{})

      result = Remarks.new(sample_data)

      assert result.effective_date == ~D[2025-08-07]
      assert result.site_number == "24226.1"
      assert result.site_type_code == :airport
      assert result.facility_type == "NON-ATCT"
      assert result.state_code == "TX"
      assert result.facility_id == "00R"
      assert result.city == "LIVINGSTON"
      assert result.country_code == "US"
      assert result.legacy_element_number == "1"
      assert result.table_name == "ARPT_CTL_REMARK"
      assert result.reference_column_name == "ATC_REMARK"
      assert result.remark_number == 1
      assert result.remark_text == "APCH/DEP CTL SVC PRVDD BY HOUSTON ARTCC (ZHU) ON FREQS 125.175/285.575 (LUFKIN RCAG)."
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

    test "handles different facility types" do
      non_atct_data = create_sample_data(%{
        "FACILITY_TYPE" => "NON-ATCT",
        "REMARK" => "APCH/DEP CTL SVC PRVDD BY HOUSTON ARTCC (ZHU) ON FREQS 125.175/285.575 (LUFKIN RCAG)."
      })

      atct_data = create_sample_data(%{
        "FACILITY_TYPE" => "ATCT",
        "REMARK" => "TWR CTLD 24 HRS."
      })

      non_atct_result = Remarks.new(non_atct_data)
      atct_result = Remarks.new(atct_data)

      assert non_atct_result.facility_type == "NON-ATCT"
      assert non_atct_result.remark_text == "APCH/DEP CTL SVC PRVDD BY HOUSTON ARTCC (ZHU) ON FREQS 125.175/285.575 (LUFKIN RCAG)."
      assert atct_result.facility_type == "ATCT"
      assert atct_result.remark_text == "TWR CTLD 24 HRS."
    end

    test "handles frequency information remarks" do
      freq_remark = create_sample_data(%{
        "REMARK" => "APCH/DEP CTL SVC PRVDD BY SALT LAKE ARTCC (ZLC) ON 132.425/317.45 (MILES CITY RCAG)."
      })

      result = Remarks.new(freq_remark)
      assert result.remark_text == "APCH/DEP CTL SVC PRVDD BY SALT LAKE ARTCC (ZLC) ON 132.425/317.45 (MILES CITY RCAG)."
    end

    test "handles multiple remarks" do
      remark1 = create_sample_data(%{
        "REMARK_NO" => "1",
        "REMARK" => "APCH/DEP CTL SVC PRVDD BY HOUSTON ARTCC (ZHU) ON FREQS 125.175/285.575 (LUFKIN RCAG)."
      })

      remark2 = create_sample_data(%{
        "REMARK_NO" => "2",
        "REMARK" => "PPR FOR UNSCHD OPS WITH MORE THAN 30 PASSENGER SEATS; CALL ARPT MANAGER 936-555-0123."
      })

      result1 = Remarks.new(remark1)
      result2 = Remarks.new(remark2)

      assert result1.remark_number == 1
      assert result1.remark_text == "APCH/DEP CTL SVC PRVDD BY HOUSTON ARTCC (ZHU) ON FREQS 125.175/285.575 (LUFKIN RCAG)."
      assert result2.remark_number == 2
      assert result2.remark_text == "PPR FOR UNSCHD OPS WITH MORE THAN 30 PASSENGER SEATS; CALL ARPT MANAGER 936-555-0123."
    end

    test "handles empty/nil values correctly" do
      sample_data = create_sample_data(%{
        "EFF_DATE" => "",
        "REMARK_NO" => "",
        "REMARK" => ""
      })

      result = Remarks.new(sample_data)

      assert result.effective_date == nil
      assert result.remark_number == nil
      assert result.remark_text == ""
    end
  end

  describe "type/0" do
    test "returns correct type string" do
      assert Remarks.type() == "ATC_RMK"
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
      "LEGACY_ELEMENT_NUMBER" => "1",
      "TAB_NAME" => "ARPT_CTL_REMARK",
      "REF_COL_NAME" => "ATC_REMARK",
      "REMARK_NO" => "1",
      "REMARK" => "APCH/DEP CTL SVC PRVDD BY HOUSTON ARTCC (ZHU) ON FREQS 125.175/285.575 (LUFKIN RCAG)."
    }, overrides)
  end
end