defmodule NASR.Entities.MaximumAuthorizedAltitude.RemarksTest do
  use ExUnit.Case
  alias NASR.Entities.MaximumAuthorizedAltitude.Remarks

  describe "new/1" do
    test "creates Remarks struct from MAA_RMK sample data" do
      sample_data = create_sample_data(%{})

      result = Remarks.new(sample_data)

      assert result.effective_date == ~D[2025-08-07]
      assert result.maa_id == "AAR002"
      assert result.table_name == "MISC_ACTIVITY_AREA"
      assert result.reference_column_name == "GENERAL_REMARK"
      assert result.reference_column_sequence_no == 1
      assert result.remark_text == "THIS APA WOULD BE USED ON AVERAGE OF EIGHT HOURS PER MONTH, DURING DAYLIGHT"
    end

    test "handles multi-part remarks" do
      # Test sequential remarks that form complete sentences
      part1 = create_sample_data(%{
        "REF_COL_SEQ_NO" => "1",
        "REMARK" => "THIS APA WOULD BE USED ON AVERAGE OF EIGHT HOURS PER MONTH, DURING DAYLIGHT"
      })

      part2 = create_sample_data(%{
        "REF_COL_SEQ_NO" => "2", 
        "REMARK" => "HOURS, MONDAY THROUGH SUNDAY OF EACH MONTH. USE WOULD BE BY LIGHT,"
      })

      part3 = create_sample_data(%{
        "REF_COL_SEQ_NO" => "3",
        "REMARK" => "SINGLE-ENGINE, PROPELLER-DRIVEN, AEROBATIC AIRCRAFT."
      })

      result1 = Remarks.new(part1)
      result2 = Remarks.new(part2)
      result3 = Remarks.new(part3)

      assert result1.reference_column_sequence_no == 1
      assert result2.reference_column_sequence_no == 2
      assert result3.reference_column_sequence_no == 3
      assert result1.maa_id == result2.maa_id
      assert result2.maa_id == result3.maa_id
    end

    test "handles long-term aerobatic practice area remarks" do
      long_term_remark = create_sample_data(%{
        "MAA_ID" => "AIA002",
        "REMARK" => "LONG TERM AEROBATIC PRACTICE AREA - FROM AUGUST 14, 2022, THROUGH AUGUST 13, 2025"
      })

      result = Remarks.new(long_term_remark)
      
      assert result.maa_id == "AIA002"
      assert result.remark_text == "LONG TERM AEROBATIC PRACTICE AREA - FROM AUGUST 14, 2022, THROUGH AUGUST 13, 2025"
    end

    test "handles NOTAM activation remarks" do
      notam_remarks = [
        "AEROBATIC PRACTICE AREA LOCATED OVER TOP AIRPORT SFC-8500 ACTIVATED BY NOTAM.",
        "AEROBATIC PRACTICE AREA LOCATED OVER TOP AIRPORT SFC-8500 ACTIVATED BY NOTAM."
      ]

      for remark_text <- notam_remarks do
        sample_data = create_sample_data(%{"REMARK" => remark_text})
        result = Remarks.new(sample_data)
        assert result.remark_text == remark_text
        assert String.contains?(result.remark_text, "ACTIVATED BY NOTAM")
      end
    end

    test "handles usage hours and aircraft type remarks" do
      usage_remark = create_sample_data(%{
        "MAA_ID" => "AIL003",
        "REF_COL_SEQ_NO" => "1",
        "REMARK" => "THIS APA WOULD BE USED ON AVERAGE OF EIGHT HOURS PER MONTH"
      })

      time_remark = create_sample_data(%{
        "MAA_ID" => "AIL003",
        "REF_COL_SEQ_NO" => "2",
        "REMARK" => "DURING DAYLIGHT HOURS, MONDAY THROUGH SUNDAY OF EACH MONTH."
      })

      aircraft_remark = create_sample_data(%{
        "MAA_ID" => "AIL003",
        "REF_COL_SEQ_NO" => "3",
        "REMARK" => "USE WOULD BE BY LIGHT, SINGLE-ENGINE, PROPELLER-DRIVEN, AEROBATIC AIRCRAFT."
      })

      usage_result = Remarks.new(usage_remark)
      time_result = Remarks.new(time_remark)
      aircraft_result = Remarks.new(aircraft_remark)

      assert usage_result.maa_id == "AIL003"
      assert time_result.maa_id == "AIL003"
      assert aircraft_result.maa_id == "AIL003"
      assert usage_result.reference_column_sequence_no == 1
      assert time_result.reference_column_sequence_no == 2
      assert aircraft_result.reference_column_sequence_no == 3
      assert String.contains?(aircraft_result.remark_text, "AEROBATIC AIRCRAFT")
    end

    test "handles different MAA ID patterns" do
      maa_patterns = [
        "AAR002",  # Arkansas aerobatic practice
        "AIA002",  # Iowa practice area
        "AIA008",  # Another Iowa area
        "AIA009",  # Another Iowa area  
        "AIL003"   # Illinois practice area
      ]

      for maa_id <- maa_patterns do
        sample_data = create_sample_data(%{"MAA_ID" => maa_id})
        result = Remarks.new(sample_data)
        assert result.maa_id == maa_id
      end
    end

    test "handles different table names" do
      table_names = [
        "MISC_ACTIVITY_AREA",
        "AEROBATIC_PRACTICE_AREA",
        "SPECIAL_USE_AIRSPACE"
      ]

      for table_name <- table_names do
        sample_data = create_sample_data(%{"TAB_NAME" => table_name})
        result = Remarks.new(sample_data)
        assert result.table_name == table_name
      end
    end

    test "handles different reference column types" do
      reference_columns = [
        "GENERAL_REMARK",
        "DESCRIPTION", 
        "TIME_OF_USE",
        "ALTITUDE_RESTRICTION",
        "OPERATING_HOURS"
      ]

      for ref_col <- reference_columns do
        sample_data = create_sample_data(%{"REF_COL_NAME" => ref_col})
        result = Remarks.new(sample_data)
        assert result.reference_column_name == ref_col
      end
    end

    test "handles detailed operational descriptions" do
      detailed_remarks = [
        "THIS APA WOULD BE USED ON AVERAGE OF EIGHT HOURS PER MONTH, DURING DAYLIGHT",
        "HOURS, MONDAY THROUGH SUNDAY OF EACH MONTH. USE WOULD BE BY LIGHT,",
        "SINGLE-ENGINE, PROPELLER-DRIVEN, AEROBATIC AIRCRAFT.",
        "AEROBATIC PRACTICE AREA LOCATED OVER TOP AIRPORT SFC-8500 ACTIVATED BY NOTAM.",
        "LONG TERM AEROBATIC PRACTICE AREA - FROM AUGUST 14, 2022, THROUGH AUGUST 13, 2025"
      ]

      for remark_text <- detailed_remarks do
        sample_data = create_sample_data(%{"REMARK" => remark_text})
        result = Remarks.new(sample_data)
        assert result.remark_text == remark_text
      end
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

    test "handles remarks with aircraft operational details" do
      aircraft_detail_remarks = [
        "USE WOULD BE BY LIGHT, SINGLE-ENGINE, PROPELLER-DRIVEN, AEROBATIC AIRCRAFT.",
        "THIS APA WOULD BE USED ON AVERAGE OF EIGHT HOURS PER MONTH",
        "DURING DAYLIGHT HOURS, MONDAY THROUGH SUNDAY OF EACH MONTH."
      ]

      for remark_text <- aircraft_detail_remarks do
        sample_data = create_sample_data(%{"REMARK" => remark_text})
        result = Remarks.new(sample_data)
        assert result.remark_text == remark_text
      end
    end

    test "handles altitude and surface references" do
      altitude_remarks = [
        "AEROBATIC PRACTICE AREA LOCATED OVER TOP AIRPORT SFC-8500 ACTIVATED BY NOTAM.",
        "AREA FROM SURFACE TO 8500 FEET ABOVE GROUND LEVEL",
        "OPERATIONS BETWEEN 1000 AGL AND 5000 AGL"
      ]

      for remark_text <- altitude_remarks do
        sample_data = create_sample_data(%{"REMARK" => remark_text})
        result = Remarks.new(sample_data)
        assert result.remark_text == remark_text
      end
    end

    test "handles temporal restrictions and dates" do
      temporal_remarks = [
        "LONG TERM AEROBATIC PRACTICE AREA - FROM AUGUST 14, 2022, THROUGH AUGUST 13, 2025",
        "DURING DAYLIGHT HOURS, MONDAY THROUGH SUNDAY OF EACH MONTH.",
        "THIS APA WOULD BE USED ON AVERAGE OF EIGHT HOURS PER MONTH"
      ]

      for remark_text <- temporal_remarks do
        sample_data = create_sample_data(%{"REMARK" => remark_text})
        result = Remarks.new(sample_data)
        assert result.remark_text == remark_text
      end
    end
  end

  describe "type/0" do
    test "returns correct type string" do
      assert Remarks.type() == "MAA_RMK"
    end
  end

  # Helper function to create sample data with default values
  defp create_sample_data(overrides) do
    Map.merge(%{
      "EFF_DATE" => "2025/08/07",
      "MAA_ID" => "AAR002",
      "TAB_NAME" => "MISC_ACTIVITY_AREA",
      "REF_COL_NAME" => "GENERAL_REMARK",
      "REF_COL_SEQ_NO" => "1",
      "REMARK" => "THIS APA WOULD BE USED ON AVERAGE OF EIGHT HOURS PER MONTH, DURING DAYLIGHT"
    }, overrides)
  end
end