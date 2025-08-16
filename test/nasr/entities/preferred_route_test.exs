defmodule NASR.Entities.PreferredRouteTest do
  use ExUnit.Case

  alias NASR.Entities.PreferredRoute

  describe "new/1" do
    test "creates struct from preferred route base data sample" do
      sample_data = create_sample_data(%{})

      result = PreferredRoute.new(sample_data)

      assert result.eff_date == ~D[2025-08-07]
      assert result.origin_id == "ABE"
      assert result.origin_city == "ALLENTOWN"
      assert result.origin_state_code == "PA"
      assert result.origin_country_code == "US"
      assert result.dstn_id == "ACY"
      assert result.dstn_city == "ATLANTIC CITY"
      assert result.dstn_state_code == "NJ"
      assert result.dstn_country_code == "US"
      assert result.pfr_type_code == :tec
      assert result.route_no == 1
      assert result.special_area_descrip == nil
      assert result.alt_descrip == "5000"
      assert result.aircraft == nil
      assert result.hours == nil
      assert result.route_dir_descrip == nil
      assert result.designator == nil
      assert result.nar_type == nil
      assert result.inland_fac_fix == nil
      assert result.coastal_fix == nil
      assert result.destination == nil
      assert result.route_string == "FJC ARD CYN"
    end

    test "handles route type codes correctly" do
      test_cases = [
        {"TEC", :tec},
        {"NAR", :nar},
        {"PREF", :pref},
        {"HIGH", :high},
        {"LOW", :low},
        {"RNAV", :rnav},
        {"", nil},
        {nil, nil}
      ]

      for {input, expected} <- test_cases do
        sample_data = create_sample_data(%{"PFR_TYPE_CODE" => input})
        result = PreferredRoute.new(sample_data)
        assert result.pfr_type_code == expected
      end
    end

    test "handles numeric fields correctly" do
      sample_data =
        create_sample_data(%{
          "ROUTE_NO" => "3"
        })

      result = PreferredRoute.new(sample_data)

      assert result.route_no == 3
    end

    test "handles empty and nil string values correctly" do
      sample_data =
        create_sample_data(%{
          "SPECIAL_AREA_DESCRIP" => "",
          "ALT_DESCRIP" => nil,
          "AIRCRAFT" => "",
          "HOURS" => nil,
          "ROUTE_DIR_DESCRIP" => "",
          "DESIGNATOR" => nil
        })

      result = PreferredRoute.new(sample_data)

      assert result.special_area_descrip == nil
      assert result.alt_descrip == nil
      assert result.aircraft == nil
      assert result.hours == nil
      assert result.route_dir_descrip == nil
      assert result.designator == nil
    end

    test "parses dates correctly" do
      sample_data =
        create_sample_data(%{
          "EFF_DATE" => "2024/03/15"
        })

      result = PreferredRoute.new(sample_data)

      assert result.eff_date == ~D[2024-03-15]
    end

    test "handles TEC route with aircraft restrictions" do
      sample_data =
        create_sample_data(%{
          "ORIGIN_ID" => "ABE",
          "DSTN_ID" => "HPN",
          "AIRCRAFT" => "PROPS LESS THAN 210 KTS IAS",
          "ALT_DESCRIP" => "5000",
          "ROUTE_STRING" => "FJC T299 HUO IGN V157 HAARP"
        })

      result = PreferredRoute.new(sample_data)

      assert result.origin_id == "ABE"
      assert result.dstn_id == "HPN"
      assert result.aircraft == "PROPS LESS THAN 210 KTS IAS"
      assert result.alt_descrip == "5000"
      assert result.route_string == "FJC T299 HUO IGN V157 HAARP"
    end

    test "handles complex route with special area description" do
      sample_data =
        create_sample_data(%{
          "ORIGIN_ID" => "ABE",
          "DSTN_ID" => "ALB",
          "SPECIAL_AREA_DESCRIP" => "TO ALB,SCH",
          "ALT_DESCRIP" => "7000",
          "ROUTE_STRING" => "FJC LAAYK"
        })

      result = PreferredRoute.new(sample_data)

      assert result.origin_id == "ABE"
      assert result.dstn_id == "ALB"
      assert result.special_area_descrip == "TO ALB,SCH"
      assert result.alt_descrip == "7000"
      assert result.route_string == "FJC LAAYK"
    end

    test "handles high altitude route" do
      sample_data =
        create_sample_data(%{
          "PFR_TYPE_CODE" => "HIGH",
          "ALT_DESCRIP" => "FL390",
          "ROUTE_STRING" => "J230 ENO J145 IRK"
        })

      result = PreferredRoute.new(sample_data)

      assert result.pfr_type_code == :high
      assert result.alt_descrip == "FL390"
      assert result.route_string == "J230 ENO J145 IRK"
    end

    test "handles RNAV route" do
      sample_data =
        create_sample_data(%{
          "PFR_TYPE_CODE" => "RNAV",
          "ALT_DESCRIP" => "FL240",
          "ROUTE_STRING" => "RNAV Q145 FIXME Q87 THERE"
        })

      result = PreferredRoute.new(sample_data)

      assert result.pfr_type_code == :rnav
      assert result.alt_descrip == "FL240"
      assert result.route_string == "RNAV Q145 FIXME Q87 THERE"
    end
  end

  describe "type/0" do
    test "returns correct CSV filename" do
      assert PreferredRoute.type() == "PFR_BASE"
    end
  end

  # Helper function to create comprehensive sample data with sensible defaults
  defp create_sample_data(overrides) do
    Map.merge(
      %{
        "EFF_DATE" => "2025/08/07",
        "ORIGIN_ID" => "ABE",
        "ORIGIN_CITY" => "ALLENTOWN",
        "ORIGIN_STATE_CODE" => "PA",
        "ORIGIN_COUNTRY_CODE" => "US",
        "DSTN_ID" => "ACY",
        "DSTN_CITY" => "ATLANTIC CITY",
        "DSTN_STATE_CODE" => "NJ",
        "DSTN_COUNTRY_CODE" => "US",
        "PFR_TYPE_CODE" => "TEC",
        "ROUTE_NO" => "1",
        "SPECIAL_AREA_DESCRIP" => "",
        "ALT_DESCRIP" => "5000",
        "AIRCRAFT" => "",
        "HOURS" => "",
        "ROUTE_DIR_DESCRIP" => "",
        "DESIGNATOR" => "",
        "NAR_TYPE" => "",
        "INLAND_FAC_FIX" => "",
        "COASTAL_FIX" => "",
        "DESTINATION" => "",
        "ROUTE_STRING" => "FJC ARD CYN"
      },
      overrides
    )
  end
end
