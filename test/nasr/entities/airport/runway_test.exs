defmodule NASR.Entities.Airport.RunwayTest do
  use ExUnit.Case

  describe "new/1" do
    test "creates struct from airport runway data" do
      sample_data = %{
        "SITE_NO" => "04513.0*A",
        "SITE_TYPE_CODE" => "AIRPORT",
        "ARPT_ID" => "LAX",
        "CITY" => "LOS ANGELES",
        "STATE_CODE" => "CA",
        "COUNTRY_CODE" => "US",
        "RWY_ID" => "07R/25L",
        "RWY_LEN" => "11095",
        "RWY_WIDTH" => "150",
        "SURFACE_TYPE_CODE" => "CONC",
        "COND" => "GOOD",
        "TREATMENT_CODE" => "GRVD",
        "PCN" => "100/R/B/W/T",
        "PAVEMENT_TYPE_CODE" => "R",
        "SUBGRADE_STRENGTH_CODE" => "B",
        "TIRE_PRES_CODE" => "W",
        "DTRM_METHOD_CODE" => "T",
        "RWY_LGT_CODE" => "HIGH",
        "RWY_LEN_SOURCE" => "OWNER",
        "LENGTH_SOURCE_DATE" => "2020/06/15",
        "GROSS_WT_SW" => "300000",
        "GROSS_WT_DW" => "450000",
        "GROSS_WT_DTW" => "700000",
        "GROSS_WT_DDTW" => "850000",
        "EFF_DATE" => "2025/08/07"
      }

      result = NASR.Entities.Airport.Runway.new(sample_data)

      assert result.site_no == "04513.0*A"
      assert result.arpt_id == "LAX"
      assert result.runway_id == "07R/25L"
      assert result.runway_length == 11095
      assert result.runway_width == 150
      assert result.surface_type_code == :concrete
      assert result.surface_condition == :good
      assert result.surface_treatment == :grooved
      assert result.pavement_type == :rigid
      assert result.determination_method == :technical
      assert result.runway_lights_edge_intensity == :high
      assert result.single_wheel_weight == 300000
      assert result.dual_wheel_weight == 450000
      assert result.dual_tandem_weight == 700000
      assert result.double_dual_tandem_weight == 850000
      assert result.effective_date == ~D[2025-08-07]
      assert result.runway_length_source_date == ~D[2020-06-15]
    end

    test "handles surface type codes correctly" do
      test_cases = [
        {"CONC", :concrete},
        {"ASPH", :asphalt},
        {"SNOW", :snow},
        {"ICE", :ice},
        {"MATS", :mats},
        {"TREATED", :treated},
        {"GRAVEL", :gravel},
        {"TURF", :turf},
        {"DIRT", :dirt},
        {"PEM", :pem},
        {"ROOF-TOP", :roof_top},
        {"WATER", :water},
        {"UNKNOWN", "UNKNOWN"}
      ]

      for {input, expected} <- test_cases do
        sample_data = create_sample_data(%{"SURFACE_TYPE_CODE" => input})
        result = NASR.Entities.Airport.Runway.new(sample_data)
        assert result.surface_type_code == expected
      end
    end

    test "handles surface conditions correctly" do
      test_cases = [
        {"EXCELLENT", :excellent},
        {"GOOD", :good},
        {"FAIR", :fair},
        {"POOR", :poor},
        {"FAILED", :failed},
        {"UNKNOWN", "UNKNOWN"}
      ]

      for {input, expected} <- test_cases do
        sample_data = create_sample_data(%{"COND" => input})
        result = NASR.Entities.Airport.Runway.new(sample_data)
        assert result.surface_condition == expected
      end
    end

    test "handles surface treatments correctly" do
      test_cases = [
        {"GRVD", :grooved},
        {"PFC", :porous_friction_course},
        {"AFSC", :aggregate_friction_seal_coat},
        {"RFSC", :rubberized_friction_seal_coat},
        {"WC", :wire_comb},
        {"NONE", :none},
        {"OTHER", "OTHER"}
      ]

      for {input, expected} <- test_cases do
        sample_data = create_sample_data(%{"TREATMENT_CODE" => input})
        result = NASR.Entities.Airport.Runway.new(sample_data)
        assert result.surface_treatment == expected
      end
    end

    test "handles pavement types correctly" do
      test_cases = [
        {"R", :rigid},
        {"F", :flexible},
        {"X", "X"}
      ]

      for {input, expected} <- test_cases do
        sample_data = create_sample_data(%{"PAVEMENT_TYPE_CODE" => input})
        result = NASR.Entities.Airport.Runway.new(sample_data)
        assert result.pavement_type == expected
      end
    end

    test "handles determination methods correctly" do
      test_cases = [
        {"T", :technical},
        {"U", :using_aircraft},
        {"X", "X"}
      ]

      for {input, expected} <- test_cases do
        sample_data = create_sample_data(%{"DTRM_METHOD_CODE" => input})
        result = NASR.Entities.Airport.Runway.new(sample_data)
        assert result.determination_method == expected
      end
    end

    test "handles runway light intensities correctly" do
      test_cases = [
        {"HIGH", :high},
        {"MED", :medium},
        {"LOW", :low},
        {"FLD", :flood},
        {"NSTD", :non_standard},
        {"PERI", :perimeter},
        {"STRB", :strobe},
        {"NONE", :none},
        {"OTHER", "OTHER"}
      ]

      for {input, expected} <- test_cases do
        sample_data = create_sample_data(%{"RWY_LGT_CODE" => input})
        result = NASR.Entities.Airport.Runway.new(sample_data)
        assert result.runway_lights_edge_intensity == expected
      end
    end

    test "handles nil and empty values correctly" do
      sample_data = create_sample_data(%{
        "SURFACE_TYPE_CODE" => "",
        "COND" => nil,
        "TREATMENT_CODE" => "",
        "PAVEMENT_TYPE_CODE" => nil,
        "DTRM_METHOD_CODE" => "",
        "RWY_LGT_CODE" => nil
      })
      
      result = NASR.Entities.Airport.Runway.new(sample_data)
      
      assert result.surface_type_code == nil
      assert result.surface_condition == nil
      assert result.surface_treatment == nil
      assert result.pavement_type == nil
      assert result.determination_method == nil
      assert result.runway_lights_edge_intensity == nil
    end

    test "converts numeric fields correctly" do
      sample_data = create_sample_data(%{
        "RWY_LEN" => "8000",
        "RWY_WIDTH" => "100",
        "GROSS_WT_SW" => "75000",
        "GROSS_WT_DW" => "100000",
        "GROSS_WT_DTW" => "150000",
        "GROSS_WT_DDTW" => "200000"
      })
      
      result = NASR.Entities.Airport.Runway.new(sample_data)
      
      assert result.runway_length == 8000
      assert result.runway_width == 100
      assert result.single_wheel_weight == 75000
      assert result.dual_wheel_weight == 100000
      assert result.dual_tandem_weight == 150000
      assert result.double_dual_tandem_weight == 200000
    end

    test "handles various runway identifiers" do
      test_cases = [
        "01/19",
        "07R/25L", 
        "10L/28R",
        "36",
        "H1",
        "N/S"
      ]

      for runway_id <- test_cases do
        sample_data = create_sample_data(%{"RWY_ID" => runway_id})
        result = NASR.Entities.Airport.Runway.new(sample_data)
        assert result.runway_id == runway_id
      end
    end

    test "handles PCN and other text fields" do
      sample_data = create_sample_data(%{
        "PCN" => "80/F/A/X/T",
        "SUBGRADE_STRENGTH_CODE" => "C",
        "TIRE_PRES_CODE" => "X",
        "RWY_LEN_SOURCE" => "ESTIMATED"
      })
      
      result = NASR.Entities.Airport.Runway.new(sample_data)
      
      assert result.pavement_classification_number == "80/F/A/X/T"
      assert result.subgrade_strength == "C"
      assert result.tire_pressure_code == "X"
      assert result.runway_length_source == "ESTIMATED"
    end

    test "parses dates correctly" do
      sample_data = create_sample_data(%{
        "LENGTH_SOURCE_DATE" => "2023/12/15",
        "EFF_DATE" => "2025/08/07"
      })
      
      result = NASR.Entities.Airport.Runway.new(sample_data)
      
      assert result.runway_length_source_date == ~D[2023-12-15]
      assert result.effective_date == ~D[2025-08-07]
    end

    test "handles empty weight values" do
      sample_data = create_sample_data(%{
        "GROSS_WT_SW" => "",
        "GROSS_WT_DW" => "",
        "GROSS_WT_DTW" => "",
        "GROSS_WT_DDTW" => ""
      })
      
      result = NASR.Entities.Airport.Runway.new(sample_data)
      
      assert result.single_wheel_weight == nil
      assert result.dual_wheel_weight == nil
      assert result.dual_tandem_weight == nil
      assert result.double_dual_tandem_weight == nil
    end
  end

  test "type/0 returns correct CSV filename" do
    assert NASR.Entities.Airport.Runway.type() == "APT_RWY"
  end

  # Helper function to create sample data with default values
  defp create_sample_data(overrides) do
    Map.merge(%{
      "SITE_NO" => "12345.*A",
      "SITE_TYPE_CODE" => "AIRPORT",
      "ARPT_ID" => "TEST",
      "CITY" => "TEST CITY",
      "STATE_CODE" => "TX",
      "COUNTRY_CODE" => "US",
      "RWY_ID" => "01/19",
      "RWY_LEN" => "5000",
      "RWY_WIDTH" => "75",
      "SURFACE_TYPE_CODE" => "ASPH",
      "COND" => "GOOD",
      "TREATMENT_CODE" => "NONE",
      "PCN" => "50/F/B/W/T",
      "PAVEMENT_TYPE_CODE" => "F",
      "SUBGRADE_STRENGTH_CODE" => "B",
      "TIRE_PRES_CODE" => "W",
      "DTRM_METHOD_CODE" => "T",
      "RWY_LGT_CODE" => "MED",
      "RWY_LEN_SOURCE" => "OWNER",
      "LENGTH_SOURCE_DATE" => "2020/01/01",
      "GROSS_WT_SW" => "12500",
      "GROSS_WT_DW" => "20000",
      "GROSS_WT_DTW" => "30000",
      "GROSS_WT_DDTW" => "40000",
      "EFF_DATE" => "2025/08/07"
    }, overrides)
  end
end