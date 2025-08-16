defmodule NASR.Entities.ClassAirspaceTest do
  use ExUnit.Case
  alias NASR.Entities.ClassAirspace

  describe "new/1" do
    test "creates ClassAirspace struct from CLS_ARSP sample data" do
      sample_data = create_sample_data(%{})

      result = ClassAirspace.new(sample_data)

      assert result.effective_date == ~D[2025-08-07]
      assert result.site_no == "00164."
      assert result.site_type_code == "A"
      assert result.state_code == "AL"
      assert result.arpt_id == "BHM"
      assert result.city == "BIRMINGHAM"
      assert result.country_code == "US"
      assert result.class_b_airspace == nil
      assert result.class_c_airspace == true
      assert result.class_d_airspace == nil
      assert result.class_e_airspace == nil
      assert result.airspace_hrs == ""
      assert result.remark == ""
    end

    test "handles all airspace class combinations" do
      # Test Class B airspace
      class_b_data = create_sample_data(%{
        "CLASS_B_AIRSPACE" => "Y",
        "CLASS_C_AIRSPACE" => "",
        "CLASS_D_AIRSPACE" => "",
        "CLASS_E_AIRSPACE" => ""
      })
      result = ClassAirspace.new(class_b_data)
      assert result.class_b_airspace == true
      assert result.class_c_airspace == nil
      assert result.class_d_airspace == nil
      assert result.class_e_airspace == nil

      # Test Class D + E combination
      class_de_data = create_sample_data(%{
        "CLASS_B_AIRSPACE" => "",
        "CLASS_C_AIRSPACE" => "",
        "CLASS_D_AIRSPACE" => "Y",
        "CLASS_E_AIRSPACE" => "Y"
      })
      result = ClassAirspace.new(class_de_data)
      assert result.class_b_airspace == nil
      assert result.class_c_airspace == nil
      assert result.class_d_airspace == true
      assert result.class_e_airspace == true
    end

    test "handles airspace hours and remarks" do
      sample_data = create_sample_data(%{
        "AIRSPACE_HRS" => "CLASS D SVC 0700-2100 MON-FRI; 0800-1700 SAT & SUN; OTHER TIMES CLASS G",
        "REMARK" => "SPECIAL OPERATIONS AREA"
      })

      result = ClassAirspace.new(sample_data)

      assert result.airspace_hrs == "CLASS D SVC 0700-2100 MON-FRI; 0800-1700 SAT & SUN; OTHER TIMES CLASS G"
      assert result.remark == "SPECIAL OPERATIONS AREA"
    end

    test "handles empty/nil values correctly" do
      sample_data = create_sample_data(%{
        "EFF_DATE" => "",
        "CLASS_B_AIRSPACE" => "",
        "CLASS_C_AIRSPACE" => "",
        "CLASS_D_AIRSPACE" => "",
        "CLASS_E_AIRSPACE" => "",
        "AIRSPACE_HRS" => "",
        "REMARK" => ""
      })

      result = ClassAirspace.new(sample_data)

      assert result.effective_date == nil
      assert result.class_b_airspace == nil
      assert result.class_c_airspace == nil
      assert result.class_d_airspace == nil
      assert result.class_e_airspace == nil
      assert result.airspace_hrs == ""
      assert result.remark == ""
    end

    test "handles Class C airspace operations" do
      class_c_data = create_sample_data(%{
        "ARPT_ID" => "HSV",
        "CITY" => "HUNTSVILLE",
        "CLASS_B_AIRSPACE" => "",
        "CLASS_C_AIRSPACE" => "Y",
        "CLASS_D_AIRSPACE" => "",
        "CLASS_E_AIRSPACE" => "Y",
        "AIRSPACE_HRS" => "CLASS C SVC 0600-0000; OTHER TIMES CLASS E"
      })

      result = ClassAirspace.new(class_c_data)
      assert result.arpt_id == "HSV"
      assert result.city == "HUNTSVILLE"
      assert result.class_c_airspace == true
      assert result.class_e_airspace == true
      assert result.airspace_hrs == "CLASS C SVC 0600-0000; OTHER TIMES CLASS E"
    end

    test "handles Class D service hours" do
      class_d_data = create_sample_data(%{
        "ARPT_ID" => "DHN",
        "CITY" => "DOTHAN",
        "CLASS_D_AIRSPACE" => "Y",
        "CLASS_E_AIRSPACE" => "Y",
        "AIRSPACE_HRS" => "CLASS D SVC 0600-2100 MON-FRI, 0800-2000 SAT-SUN; OTHER TIMES CLASS E"
      })

      result = ClassAirspace.new(class_d_data)
      assert result.arpt_id == "DHN"
      assert result.city == "DOTHAN"
      assert result.class_d_airspace == true
      assert result.class_e_airspace == true
      assert result.airspace_hrs == "CLASS D SVC 0600-2100 MON-FRI, 0800-2000 SAT-SUN; OTHER TIMES CLASS E"
    end

    test "handles different airport site numbers and types" do
      # Test airport with decimal site number
      airport_data = create_sample_data(%{
        "SITE_NO" => "00359.7",
        "SITE_TYPE_CODE" => "A",
        "ARPT_ID" => "JKA",
        "CITY" => "GULF SHORES"
      })

      result = ClassAirspace.new(airport_data)
      assert result.site_no == "00359.7"
      assert result.site_type_code == "A"
      assert result.arpt_id == "JKA"
      assert result.city == "GULF SHORES"
    end

    test "handles boolean conversions for airspace classes" do
      test_cases = [
        {"Y", true},
        {"N", false},
        {"", nil}
      ]

      for {input, expected} <- test_cases do
        sample_data = create_sample_data(%{
          "CLASS_B_AIRSPACE" => input,
          "CLASS_C_AIRSPACE" => input,
          "CLASS_D_AIRSPACE" => input,
          "CLASS_E_AIRSPACE" => input
        })
        result = ClassAirspace.new(sample_data)
        assert result.class_b_airspace == expected
        assert result.class_c_airspace == expected
        assert result.class_d_airspace == expected
        assert result.class_e_airspace == expected
      end
    end
  end

  describe "type/0" do
    test "returns correct type string" do
      assert ClassAirspace.type() == "CLS_ARSP"
    end
  end

  # Helper function to create sample data with default values
  defp create_sample_data(overrides) do
    Map.merge(%{
      "EFF_DATE" => "2025/08/07",
      "SITE_NO" => "00164.",
      "SITE_TYPE_CODE" => "A",
      "STATE_CODE" => "AL",
      "ARPT_ID" => "BHM",
      "CITY" => "BIRMINGHAM",
      "COUNTRY_CODE" => "US",
      "CLASS_B_AIRSPACE" => "",
      "CLASS_C_AIRSPACE" => "Y",
      "CLASS_D_AIRSPACE" => "",
      "CLASS_E_AIRSPACE" => "",
      "AIRSPACE_HRS" => "",
      "REMARK" => ""
    }, overrides)
  end
end