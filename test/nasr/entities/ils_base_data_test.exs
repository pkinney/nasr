defmodule NASR.Entities.ILSBaseDataTest do
  use ExUnit.Case

  describe "new/1" do
    test "creates struct from real-world ILS1 sample data" do
      sample_data = %{
        type: :ils1,
        record_type_indicator: "ILS1",
        blank: "",
        information_effective_date_mm_dd_yyyy: "08/07/2025",
        airport_site_number_identifier_ex_04508_a: "00128.*A",
        ils_runway_end_identifier_ex_18_36l: "05",
        ils_system_type: "ILS",
        identification_code_of_ils: "I-ANB",
        airport_name_ex_chicago_o_hare_intl: "ANNISTON RGNL",
        associated_city_ex_chicago: "ANNISTON",
        two_letter_post_office_code_for_the_state: "AL",
        state_name_ex_illinois: "ALABAMA",
        faa_region_code_example_ace_central: "ASO",
        airport_identifier: "ANB",
        ils_runway_length_in_whole_feet_ex_4000: "7000",
        ils_runway_width_in_whole_feet_ex_100: "150",
        category_of_the_ils_i_ii_iiia: "I",
        name_of_owner_of_the_facility_ex_u_s_navy: "FEDERAL AVIATION ADMIN.",
        name_of_the_ils_facility_operator: "FEDERAL AVIATION ADMIN.",
        ils_approach_bearing_in_degrees_magnetic: "052.45",
        the_magnetic_variation_at_the_ils_facility: "04W"
      }

      result = NASR.Entities.ILSBaseData.new(sample_data)

      assert result.record_type_indicator == "ILS1"
      assert result.airport_site_number == "00128.*A"
      assert result.ils_runway_end_identifier == "05"
      assert result.ils_system_type == :ils
      assert result.identification_code == "I-ANB"
      assert result.information_effective_date == ~D[2025-08-07]
      assert result.airport_name == "ANNISTON RGNL"
      assert result.associated_city == "ANNISTON"
      assert result.state_post_office_code == "AL"
      assert result.state_name == "ALABAMA"
      assert result.faa_region_code == "ASO"
      assert result.airport_identifier == "ANB"
      assert result.ils_runway_length == 7000
      assert result.ils_runway_width == 150
      assert result.ils_category == :i
      assert result.facility_owner_name == "FEDERAL AVIATION ADMIN."
      assert result.facility_operator_name == "FEDERAL AVIATION ADMIN."
      assert result.ils_approach_bearing == 52.45
      assert result.magnetic_variation == "04W"
    end

    test "handles empty effective date" do
      sample_data = %{
        type: :ils1,
        record_type_indicator: "ILS1",
        blank: "",
        information_effective_date_mm_dd_yyyy: "",
        airport_site_number_identifier_ex_04508_a: "00128.*A",
        ils_runway_end_identifier_ex_18_36l: "05",
        ils_system_type: "ILS",
        identification_code_of_ils: "I-ANB",
        airport_name_ex_chicago_o_hare_intl: "TEST AIRPORT",
        associated_city_ex_chicago: "TEST CITY",
        two_letter_post_office_code_for_the_state: "AL",
        state_name_ex_illinois: "ALABAMA",
        faa_region_code_example_ace_central: "ASO",
        airport_identifier: "TST",
        ils_runway_length_in_whole_feet_ex_4000: "7000",
        ils_runway_width_in_whole_feet_ex_100: "150",
        category_of_the_ils_i_ii_iiia: "I",
        name_of_owner_of_the_facility_ex_u_s_navy: "TEST OWNER",
        name_of_the_ils_facility_operator: "TEST OPERATOR",
        ils_approach_bearing_in_degrees_magnetic: "052.45",
        the_magnetic_variation_at_the_ils_facility: "04W"
      }

      result = NASR.Entities.ILSBaseData.new(sample_data)

      assert result.information_effective_date == nil
    end

    test "converts ILS system types to atoms" do
      test_cases = [
        {"ILS", :ils},
        {"SDF", :sdf},
        {"LOCALIZER", :localizer},
        {"LDA", :lda},
        {"ILS/DME", :ils_dme},
        {"SDF/DME", :sdf_dme},
        {"LOC/DME", :loc_dme},
        {"LOC/GS", :loc_gs},
        {"LDA/DME", :lda_dme}
      ]

      for {input, expected} <- test_cases do
        sample_data = %{
          type: :ils1,
          record_type_indicator: "ILS1",
          blank: "",
          information_effective_date_mm_dd_yyyy: "08/07/2025",
          airport_site_number_identifier_ex_04508_a: "00128.*A",
          ils_runway_end_identifier_ex_18_36l: "05",
          ils_system_type: input,
          identification_code_of_ils: "I-ANB",
          airport_name_ex_chicago_o_hare_intl: "TEST",
          associated_city_ex_chicago: "TEST",
          two_letter_post_office_code_for_the_state: "AL",
          state_name_ex_illinois: "ALABAMA",
          faa_region_code_example_ace_central: "ASO",
          airport_identifier: "TST",
          ils_runway_length_in_whole_feet_ex_4000: "7000",
          ils_runway_width_in_whole_feet_ex_100: "150",
          category_of_the_ils_i_ii_iiia: "I",
          name_of_owner_of_the_facility_ex_u_s_navy: "TEST",
          name_of_the_ils_facility_operator: "TEST",
          ils_approach_bearing_in_degrees_magnetic: "052.45",
          the_magnetic_variation_at_the_ils_facility: "04W"
        }

        result = NASR.Entities.ILSBaseData.new(sample_data)
        assert result.ils_system_type == expected
      end
    end

    test "converts ILS categories to atoms" do
      test_cases = [
        {"I", :i},
        {"II", :ii},
        {"IIIA", :iiia}
      ]

      for {input, expected} <- test_cases do
        sample_data = %{
          type: :ils1,
          record_type_indicator: "ILS1",
          blank: "",
          information_effective_date_mm_dd_yyyy: "08/07/2025",
          airport_site_number_identifier_ex_04508_a: "00128.*A",
          ils_runway_end_identifier_ex_18_36l: "05",
          ils_system_type: "ILS",
          identification_code_of_ils: "I-ANB",
          airport_name_ex_chicago_o_hare_intl: "TEST",
          associated_city_ex_chicago: "TEST",
          two_letter_post_office_code_for_the_state: "AL",
          state_name_ex_illinois: "ALABAMA",
          faa_region_code_example_ace_central: "ASO",
          airport_identifier: "TST",
          ils_runway_length_in_whole_feet_ex_4000: "7000",
          ils_runway_width_in_whole_feet_ex_100: "150",
          category_of_the_ils_i_ii_iiia: input,
          name_of_owner_of_the_facility_ex_u_s_navy: "TEST",
          name_of_the_ils_facility_operator: "TEST",
          ils_approach_bearing_in_degrees_magnetic: "052.45",
          the_magnetic_variation_at_the_ils_facility: "04W"
        }

        result = NASR.Entities.ILSBaseData.new(sample_data)
        assert result.ils_category == expected
      end
    end
  end
end