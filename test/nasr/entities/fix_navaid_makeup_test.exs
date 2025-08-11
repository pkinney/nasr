defmodule NASR.Entities.FixNavaidMakeupTest do
  use ExUnit.Case

  describe "new/1" do
    test "creates struct from real-world FIX_NAV sample data" do
      sample_data = %{
        "EFF_DATE" => "2025/08/07",
        "FIX_ID" => "SASIE",
        "ICAO_REGION_CODE" => "K4",
        "STATE_CODE" => "TX",
        "COUNTRY_CODE" => "US",
        "NAV_ID" => "BYP",
        "NAV_TYPE" => "VOR",
        "BEARING" => "334",
        "DISTANCE" => "20.3"
      }

      result = NASR.Entities.FixNavaidMakeup.new(sample_data)

      assert result.fix_id == "SASIE"
      assert result.icao_region_code == "K4"
      assert result.state_code == "TX"
      assert result.country_code == "US"
      assert result.nav_id == "BYP"
      assert result.nav_type == "VOR"
      assert result.bearing == 334.0
      assert result.distance == 20.3
      assert result.eff_date == ~D[2025-08-07]
    end

    test "handles various NAVAID types" do
      nav_types = [
        "VOR",
        "VORTAC",
        "TACAN",
        "NDB",
        "VOR/DME",
        "DME"
      ]

      for nav_type <- nav_types do
        sample_data = %{
          "EFF_DATE" => "2025/08/07",
          "FIX_ID" => "TEST",
          "ICAO_REGION_CODE" => "K1",
          "STATE_CODE" => "CA",
          "COUNTRY_CODE" => "US",
          "NAV_ID" => "TST",
          "NAV_TYPE" => nav_type,
          "BEARING" => "090",
          "DISTANCE" => "10.5"
        }

        result = NASR.Entities.FixNavaidMakeup.new(sample_data)
        assert result.nav_type == nav_type
      end
    end

    test "handles empty numeric fields" do
      sample_data = %{
        "EFF_DATE" => "2025/08/07",
        "FIX_ID" => "TEST",
        "ICAO_REGION_CODE" => "K1",
        "STATE_CODE" => "CA",
        "COUNTRY_CODE" => "US",
        "NAV_ID" => "TST",
        "NAV_TYPE" => "VOR",
        "BEARING" => "",
        "DISTANCE" => ""
      }

      result = NASR.Entities.FixNavaidMakeup.new(sample_data)
      assert result.bearing == nil
      assert result.distance == nil
    end

    test "correctly parses decimal values" do
      sample_data = %{
        "EFF_DATE" => "2025/08/07",
        "FIX_ID" => "TEST",
        "ICAO_REGION_CODE" => "K1",
        "STATE_CODE" => "CA",
        "COUNTRY_CODE" => "US",
        "NAV_ID" => "TST",
        "NAV_TYPE" => "VOR",
        "BEARING" => "359.5",
        "DISTANCE" => "100.25"
      }

      result = NASR.Entities.FixNavaidMakeup.new(sample_data)
      assert result.bearing == 359.5
      assert result.distance == 100.25
    end

    test "type/0 returns correct type string" do
      assert NASR.Entities.FixNavaidMakeup.type() == "FIX_NAV"
    end
  end
end