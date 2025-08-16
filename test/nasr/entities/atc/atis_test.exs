defmodule NASR.Entities.ATC.ATISTest do
  use ExUnit.Case
  alias NASR.Entities.ATC.ATIS

  describe "new/1" do
    test "creates ATIS struct from ATC_ATIS sample data" do
      sample_data = create_sample_data(%{})

      result = ATIS.new(sample_data)

      assert result.effective_date == ~D[2025-08-07]
      assert result.site_number == "00164."
      assert result.site_type_code == :airport
      assert result.facility_type == "ATCT-TRACON"
      assert result.state_code == "AL"
      assert result.facility_id == "BHM"
      assert result.city == "BIRMINGHAM"
      assert result.country_code == "US"
      assert result.atis_number == 1
      assert result.description == ""
      assert result.atis_hours == "24"
      assert result.atis_phone_number == ""
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
        result = ATIS.new(sample_data)
        assert result.site_type_code == expected
      end
    end

    test "handles different facility types" do
      atct_data = create_sample_data(%{
        "FACILITY_TYPE" => "ATCT",
        "FACILITY_ID" => "DHN"
      })

      tracon_data = create_sample_data(%{
        "FACILITY_TYPE" => "ATCT-TRACON",
        "FACILITY_ID" => "BHM"
      })

      atct_result = ATIS.new(atct_data)
      tracon_result = ATIS.new(tracon_data)

      assert atct_result.facility_type == "ATCT"
      assert atct_result.facility_id == "DHN"
      assert tracon_result.facility_type == "ATCT-TRACON"
      assert tracon_result.facility_id == "BHM"
    end

    test "handles multiple ATIS frequencies" do
      atis1 = create_sample_data(%{
        "ATIS_NO" => "1",
        "DESCRIPTION" => "Arrival ATIS"
      })

      atis2 = create_sample_data(%{
        "ATIS_NO" => "2", 
        "DESCRIPTION" => "Departure ATIS"
      })

      result1 = ATIS.new(atis1)
      result2 = ATIS.new(atis2)

      assert result1.atis_number == 1
      assert result1.description == "Arrival ATIS"
      assert result2.atis_number == 2
      assert result2.description == "Departure ATIS"
    end

    test "handles ATIS phone number" do
      phone_data = create_sample_data(%{
        "ATIS_PHONE_NO" => "205-555-0123",
        "DESCRIPTION" => "Birmingham ATIS"
      })

      result = ATIS.new(phone_data)

      assert result.atis_phone_number == "205-555-0123"
      assert result.description == "Birmingham ATIS"
    end

    test "handles empty/nil values correctly" do
      sample_data = create_sample_data(%{
        "EFF_DATE" => "",
        "ATIS_NO" => "",
        "DESCRIPTION" => "",
        "ATIS_PHONE_NO" => ""
      })

      result = ATIS.new(sample_data)

      assert result.effective_date == nil
      assert result.atis_number == nil
      assert result.description == ""
      assert result.atis_phone_number == ""
    end
  end

  describe "type/0" do
    test "returns correct type string" do
      assert ATIS.type() == "ATC_ATIS"
    end
  end

  # Helper function to create sample data with default values
  defp create_sample_data(overrides) do
    Map.merge(%{
      "EFF_DATE" => "2025/08/07",
      "SITE_NO" => "00164.",
      "SITE_TYPE_CODE" => "A",
      "FACILITY_TYPE" => "ATCT-TRACON",
      "STATE_CODE" => "AL",
      "FACILITY_ID" => "BHM",
      "CITY" => "BIRMINGHAM",
      "COUNTRY_CODE" => "US",
      "ATIS_NO" => "1",
      "DESCRIPTION" => "",
      "ATIS_HRS" => "24",
      "ATIS_PHONE_NO" => ""
    }, overrides)
  end
end