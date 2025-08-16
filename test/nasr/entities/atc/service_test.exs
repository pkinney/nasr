defmodule NASR.Entities.ATC.ServiceTest do
  use ExUnit.Case
  alias NASR.Entities.ATC.Service

  describe "new/1" do
    test "creates Service struct from ATC_SVC sample data" do
      sample_data = create_sample_data(%{})

      result = Service.new(sample_data)

      assert result.effective_date == ~D[2025-08-07]
      assert result.site_number == ""
      assert result.site_type_code == nil
      assert result.facility_type == "TRACON"
      assert result.state_code == "GA"
      assert result.facility_id == "A80"
      assert result.city == "PEACHTREE CITY"
      assert result.country_code == "US"
      assert result.control_service == "ARTS-IIIE"
    end

    test "handles site type code conversions" do
      test_cases = [
        {"A", :airport},
        {"B", :balloonport},
        {"S", :seaplane_base},
        {"G", :gliderport},
        {"H", :heliport},
        {"U", :ultralight},
        {"", nil}
      ]

      for {input, expected} <- test_cases do
        sample_data = create_sample_data(%{"SITE_TYPE_CODE" => input})
        result = Service.new(sample_data)
        assert result.site_type_code == expected
      end
    end

    test "handles different control services" do
      arts_service = create_sample_data(%{
        "CTL_SVC" => "ARTS-IIIE"
      })

      class_b_service = create_sample_data(%{
        "CTL_SVC" => "CLASS B"
      })

      approach_service = create_sample_data(%{
        "CTL_SVC" => "APPROACH"
      })

      arts_result = Service.new(arts_service)
      class_b_result = Service.new(class_b_service)
      approach_result = Service.new(approach_service)

      assert arts_result.control_service == "ARTS-IIIE"
      assert class_b_result.control_service == "CLASS B"
      assert approach_result.control_service == "APPROACH"
    end

    test "handles different facility types" do
      tracon_data = create_sample_data(%{
        "FACILITY_TYPE" => "TRACON",
        "FACILITY_ID" => "A80",
        "CTL_SVC" => "ARTS-IIIE"
      })

      atct_data = create_sample_data(%{
        "FACILITY_TYPE" => "ATCT",
        "FACILITY_ID" => "ATL",
        "CTL_SVC" => "CLASS B"
      })

      tracon_result = Service.new(tracon_data)
      atct_result = Service.new(atct_data)

      assert tracon_result.facility_type == "TRACON"
      assert tracon_result.facility_id == "A80"
      assert tracon_result.control_service == "ARTS-IIIE"
      assert atct_result.facility_type == "ATCT"
      assert atct_result.facility_id == "ATL"
      assert atct_result.control_service == "CLASS B"
    end

    test "handles radar services" do
      radar_services = [
        "ARTS-IIIE",
        "ARTS-IIE",
        "ARTS-III",
        "STARS",
        "STANDARD TERMINAL AUTOMATION"
      ]

      for service <- radar_services do
        sample_data = create_sample_data(%{"CTL_SVC" => service})
        result = Service.new(sample_data)
        assert result.control_service == service
      end
    end

    test "handles airspace classifications" do
      airspace_classes = [
        "CLASS B",
        "CLASS C",
        "CLASS D",
        "CLASS E"
      ]

      for airspace_class <- airspace_classes do
        sample_data = create_sample_data(%{"CTL_SVC" => airspace_class})
        result = Service.new(sample_data)
        assert result.control_service == airspace_class
      end
    end

    test "handles empty/nil values correctly" do
      sample_data = create_sample_data(%{
        "EFF_DATE" => "",
        "SITE_NO" => "",
        "SITE_TYPE_CODE" => "",
        "CTL_SVC" => ""
      })

      result = Service.new(sample_data)

      assert result.effective_date == nil
      assert result.site_number == ""
      assert result.site_type_code == nil
      assert result.control_service == ""
    end
  end

  describe "type/0" do
    test "returns correct type string" do
      assert Service.type() == "ATC_SVC"
    end
  end

  # Helper function to create sample data with default values
  defp create_sample_data(overrides) do
    Map.merge(%{
      "EFF_DATE" => "2025/08/07",
      "SITE_NO" => "",
      "SITE_TYPE_CODE" => "",
      "FACILITY_TYPE" => "TRACON",
      "STATE_CODE" => "GA",
      "FACILITY_ID" => "A80",
      "CITY" => "PEACHTREE CITY",
      "COUNTRY_CODE" => "US",
      "CTL_SVC" => "ARTS-IIIE"
    }, overrides)
  end
end