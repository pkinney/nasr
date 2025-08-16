defmodule NASR.Entities.HoldingPattern.ChartingTest do
  use ExUnit.Case
  alias NASR.Entities.HoldingPattern.Charting

  describe "new/1" do
    test "creates Charting struct from HPF_CHRT sample data" do
      sample_data = create_sample_data(%{})

      result = Charting.new(sample_data)

      assert result.effective_date == ~D[2025-08-07]
      assert result.hp_name == "AABEE INT*GA*K7"
      assert result.hp_no == 1
      assert result.state_code == "GA"
      assert result.country_code == "US"
      assert result.charting_type_desc == :approach
    end

    test "handles different chart types" do
      test_cases = [
        {"IAP", :approach},
        {"DP", :departure},
        {"ENROUTE HIGH", :enroute_high},
        {"ENROUTE LOW", :enroute_low},
        {"MILITARY IAP", :military_approach},
        {"STAR", :star},
        {"AREA CHART", :area_chart}
      ]

      for {chart_type, expected_atom} <- test_cases do
        sample_data = create_sample_data(%{"CHARTING_TYPE_DESC" => chart_type})
        result = Charting.new(sample_data)
        assert result.charting_type_desc == expected_atom, "Failed for CHARTING_TYPE_DESC: #{chart_type}"
      end
    end

    test "handles STAR charting" do
      star_data = create_sample_data(%{
        "HP_NAME" => "AADEN WP*GA*K7",
        "CHARTING_TYPE_DESC" => "STAR"
      })

      result = Charting.new(star_data)
      
      assert result.hp_name == "AADEN WP*GA*K7"
      assert result.charting_type_desc == :star
    end

    test "handles enroute high altitude charting" do
      enroute_data = create_sample_data(%{
        "HP_NAME" => "AADEN WP*GA*K7",
        "CHARTING_TYPE_DESC" => "ENROUTE HIGH"
      })

      result = Charting.new(enroute_data)
      
      assert result.hp_name == "AADEN WP*GA*K7"
      assert result.charting_type_desc == :enroute_high
    end

    test "handles military approach procedures" do
      military_data = create_sample_data(%{
        "HP_NAME" => "AAMMO WP*NC*K7",
        "CHARTING_TYPE_DESC" => "MILITARY IAP"
      })

      result = Charting.new(military_data)
      
      assert result.hp_name == "AAMMO WP*NC*K7"
      assert result.charting_type_desc == :military_approach
    end

    test "handles empty/nil values correctly" do
      sample_data = create_sample_data(%{
        "HP_NO" => "",
        "CHARTING_TYPE_DESC" => ""
      })

      result = Charting.new(sample_data)

      assert result.hp_no == nil
      assert result.charting_type_desc == nil
    end

    test "handles unknown chart types" do
      sample_data = create_sample_data(%{
        "CHARTING_TYPE_DESC" => "UNKNOWN_CHART_TYPE"
      })

      result = Charting.new(sample_data)

      assert result.charting_type_desc == "UNKNOWN_CHART_TYPE"
    end

    test "handles multiple chart entries for same holding pattern" do
      # Test that same holding pattern can appear on multiple chart types
      chart1 = create_sample_data(%{
        "HP_NAME" => "AADEN WP*GA*K7",
        "CHARTING_TYPE_DESC" => "ENROUTE HIGH"
      })
      
      chart2 = create_sample_data(%{
        "HP_NAME" => "AADEN WP*GA*K7",
        "CHARTING_TYPE_DESC" => "STAR"
      })

      result1 = Charting.new(chart1)
      result2 = Charting.new(chart2)

      assert result1.hp_name == result2.hp_name
      assert result1.charting_type_desc == :enroute_high
      assert result2.charting_type_desc == :star
    end

    test "handles numeric conversion for holding pattern number" do
      sample_data = create_sample_data(%{
        "HP_NO" => "2"
      })

      result = Charting.new(sample_data)
      assert result.hp_no == 2
    end
  end

  describe "type/0" do
    test "returns correct type string" do
      assert Charting.type() == "HPF_CHRT"
    end
  end

  # Helper function to create sample data with default values
  defp create_sample_data(overrides) do
    Map.merge(%{
      "EFF_DATE" => "2025/08/07",
      "HP_NAME" => "AABEE INT*GA*K7",
      "HP_NO" => "1",
      "STATE_CODE" => "GA",
      "COUNTRY_CODE" => "US",
      "CHARTING_TYPE_DESC" => "IAP"
    }, overrides)
  end
end