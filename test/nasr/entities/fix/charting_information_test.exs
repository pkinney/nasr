defmodule NASR.Entities.Fix.ChartingInformationTest do
  use ExUnit.Case

  describe "new/1" do
    test "creates struct from real-world FIX_CHRT sample data" do
      sample_data = %{
        "EFF_DATE" => "2025/08/07",
        "FIX_ID" => "SASIE",
        "ICAO_REGION_CODE" => "K4",
        "STATE_CODE" => "TX",
        "COUNTRY_CODE" => "US",
        "CHARTING_TYPE_DESC" => "CONTROLLER LOW"
      }

      result = NASR.Entities.Fix.ChartingInformation.new(sample_data)

      assert result.fix_id == "SASIE"
      assert result.icao_region_code == "K4"
      assert result.state_code == "TX"
      assert result.country_code == "US"
      assert result.charting_type_desc == "CONTROLLER LOW"
      assert result.effective_date == ~D[2025-08-07]
    end

    test "handles various chart types" do
      chart_types = [
        "CONTROLLER LOW",
        "ENROUTE LOW",
        "IAP",
        "STAR",
        "DP",
        "ENROUTE HIGH"
      ]

      for chart_type <- chart_types do
        sample_data = %{
          "EFF_DATE" => "2025/08/07",
          "FIX_ID" => "TEST",
          "ICAO_REGION_CODE" => "K1",
          "STATE_CODE" => "CA",
          "COUNTRY_CODE" => "US",
          "CHARTING_TYPE_DESC" => chart_type
        }

        result = NASR.Entities.Fix.ChartingInformation.new(sample_data)
        assert result.charting_type_desc == chart_type
      end
    end

    test "handles empty date field" do
      sample_data = %{
        "EFF_DATE" => "",
        "FIX_ID" => "TEST",
        "ICAO_REGION_CODE" => "K1",
        "STATE_CODE" => "CA",
        "COUNTRY_CODE" => "US",
        "CHARTING_TYPE_DESC" => "IAP"
      }

      result = NASR.Entities.Fix.ChartingInformation.new(sample_data)
      assert result.effective_date == nil
    end

    test "type/0 returns correct type string" do
      assert NASR.Entities.Fix.ChartingInformation.type() == "FIX_CHRT"
    end
  end
end