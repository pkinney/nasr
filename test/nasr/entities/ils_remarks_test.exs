defmodule NASR.Entities.ILSRemarksTest do
  use ExUnit.Case

  describe "new/1" do
    test "creates struct from real-world ILS6 sample data" do
      sample_data = %{
        type: :ils6,
        record_type_indicator: "ILS6",
        airport_site_number_identifier: "00128.*A",
        ils_runway_end_identifier: "05",
        ils_system_type_see_ils1_record_for_description: "ILS",
        ils_remarks_free_form_text: "ILS CLASSIFICATION CODE IA"
      }

      result = NASR.Entities.ILSRemarks.new(sample_data)

      assert result.record_type_indicator == "ILS6"
      assert result.airport_site_number == "00128.*A"
      assert result.ils_runway_end_identifier == "05"
      assert result.ils_system_type == :ils
      assert result.remarks_text == "ILS CLASSIFICATION CODE IA"
    end

    test "handles empty remarks text" do
      sample_data = %{
        type: :ils6,
        record_type_indicator: "ILS6",
        airport_site_number_identifier: "00128.*A",
        ils_runway_end_identifier: "05",
        ils_system_type_see_ils1_record_for_description: "ILS",
        ils_remarks_free_form_text: ""
      }

      result = NASR.Entities.ILSRemarks.new(sample_data)

      assert result.remarks_text == ""
    end

    test "converts ILS system types to atoms" do
      test_cases = [
        {"ILS", :ils},
        {"SDF", :sdf},
        {"LOCALIZER", :localizer},
        {"LDA", :lda},
        {"ILS/DME", :ils_dme}
      ]

      for {input, expected} <- test_cases do
        sample_data = %{
          type: :ils6,
          record_type_indicator: "ILS6",
          airport_site_number_identifier: "00128.*A",
          ils_runway_end_identifier: "05",
          ils_system_type_see_ils1_record_for_description: input,
          ils_remarks_free_form_text: "TEST REMARK"
        }

        result = NASR.Entities.ILSRemarks.new(sample_data)
        assert result.ils_system_type == expected
      end
    end
  end
end