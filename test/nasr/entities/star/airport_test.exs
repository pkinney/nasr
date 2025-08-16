defmodule NASR.Entities.STAR.AirportTest do
  use ExUnit.Case
  alias NASR.Entities.STAR.Airport

  describe "new/1" do
    test "creates Airport struct from STAR_APT sample data" do
      sample_data = create_sample_data(%{})

      result = Airport.new(sample_data)

      assert result.effective_date == ~D[2025-08-07]
      assert result.star_computer_code == "AALAN.BLAID2"
      assert result.artcc == "ZLA"
      assert result.body_name == "AALAN-BLAID"
      assert result.body_sequence == 1
      assert result.airport_id == "LAS"
      assert result.runway_end_id == "ALL"
    end

    test "handles different STAR computer codes" do
      las_star = create_sample_data(%{
        "STAR_COMPUTER_CODE" => "AALAN.BLAID2"
      })

      den_star = create_sample_data(%{
        "STAR_COMPUTER_CODE" => "AALLE.AALLE4",
        "ARTCC" => "ZDV",
        "AIRPORT_ID" => "DEN"
      })

      las_result = Airport.new(las_star)
      den_result = Airport.new(den_star)

      assert las_result.star_computer_code == "AALAN.BLAID2"
      assert den_result.star_computer_code == "AALLE.AALLE4"
      assert den_result.artcc == "ZDV"
    end

    test "handles specific runway assignments" do
      all_runways = create_sample_data(%{
        "RWY_END_ID" => "ALL"
      })

      specific_runway = create_sample_data(%{
        "RWY_END_ID" => "25",
        "STAR_COMPUTER_CODE" => "AALLE.AALLE4",
        "ARPT_ID" => "DEN"
      })

      all_result = Airport.new(all_runways)
      specific_result = Airport.new(specific_runway)

      assert all_result.runway_end_id == "ALL"
      assert specific_result.runway_end_id == "25"
      assert specific_result.star_computer_code == "AALLE.AALLE4"
      assert specific_result.airport_id == "DEN"
    end

    test "handles different body sequences" do
      body1 = create_sample_data(%{
        "BODY_SEQ" => "1",
        "BODY_NAME" => "AALAN-BLAID"
      })

      body2 = create_sample_data(%{
        "BODY_SEQ" => "2",
        "BODY_NAME" => "RADAR-VECTOR"
      })

      result1 = Airport.new(body1)
      result2 = Airport.new(body2)

      assert result1.body_sequence == 1
      assert result1.body_name == "AALAN-BLAID"
      assert result2.body_sequence == 2
      assert result2.body_name == "RADAR-VECTOR"
    end

    test "handles different body names" do
      body_names = [
        "AALAN-BLAID",
        "AALLE-CRUNK",
        "RADAR-VECTOR",
        "VISUAL-APPROACH"
      ]

      for body_name <- body_names do
        sample_data = create_sample_data(%{"BODY_NAME" => body_name})
        result = Airport.new(sample_data)
        assert result.body_name == body_name
      end
    end

    test "handles multiple runway designations" do
      runway_designations = ["ALL", "07L", "07R", "25L", "25R", "16L", "16R", "34L", "34R"]

      for runway <- runway_designations do
        sample_data = create_sample_data(%{"RWY_END_ID" => runway})
        result = Airport.new(sample_data)
        assert result.runway_end_id == runway
      end
    end

    test "handles empty/nil values correctly" do
      sample_data = create_sample_data(%{
        "EFF_DATE" => "",
        "BODY_SEQ" => ""
      })

      result = Airport.new(sample_data)

      assert result.effective_date == nil
      assert result.body_sequence == nil
    end
  end

  describe "type/0" do
    test "returns correct type string" do
      assert Airport.type() == "STAR_APT"
    end
  end

  # Helper function to create sample data with default values
  defp create_sample_data(overrides) do
    Map.merge(%{
      "EFF_DATE" => "2025/08/07",
      "STAR_COMPUTER_CODE" => "AALAN.BLAID2",
      "ARTCC" => "ZLA",
      "BODY_NAME" => "AALAN-BLAID",
      "BODY_SEQ" => "1",
      "ARPT_ID" => "LAS",
      "RWY_END_ID" => "ALL"
    }, overrides)
  end
end