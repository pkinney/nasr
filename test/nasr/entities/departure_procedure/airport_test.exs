defmodule NASR.Entities.DepartureProcedure.AirportTest do
  use ExUnit.Case
  alias NASR.Entities.DepartureProcedure.Airport

  describe "new/1" do
    test "creates Airport struct from DP_APT sample data" do
      sample_data = create_sample_data(%{})

      result = Airport.new(sample_data)

      assert result.effective_date == ~D[2025-08-07]
      assert result.departure_procedure_name == "ACCRA"
      assert result.artcc == "ZAU"
      assert result.departure_procedure_computer_code == "ACCRA5.ACCRA"
      assert result.body_name == "FANZI-ACCRA"
      assert result.body_sequence == 1
      assert result.airport_id == "57C"
      assert result.runway_end_id == "ALL"
    end

    test "handles different airports for same procedure" do
      airport1 = create_sample_data(%{
        "ARPT_ID" => "57C"
      })

      airport2 = create_sample_data(%{
        "ARPT_ID" => "BUU"
      })

      result1 = Airport.new(airport1)
      result2 = Airport.new(airport2)

      assert result1.airport_id == "57C"
      assert result2.airport_id == "BUU"
      assert result1.departure_procedure_name == result2.departure_procedure_name
      assert result1.departure_procedure_computer_code == result2.departure_procedure_computer_code
    end

    test "handles specific runway assignments" do
      all_runways = create_sample_data(%{
        "RWY_END_ID" => "ALL"
      })

      specific_runway = create_sample_data(%{
        "RWY_END_ID" => "09R",
        "ARPT_ID" => "ATL"
      })

      all_result = Airport.new(all_runways)
      specific_result = Airport.new(specific_runway)

      assert all_result.runway_end_id == "ALL"
      assert specific_result.runway_end_id == "09R"
      assert specific_result.airport_id == "ATL"
    end

    test "handles different body sequences" do
      body1 = create_sample_data(%{
        "BODY_SEQ" => "1",
        "BODY_NAME" => "FANZI-ACCRA"
      })

      body2 = create_sample_data(%{
        "BODY_SEQ" => "2",
        "BODY_NAME" => "RADAR-ACCRA"
      })

      result1 = Airport.new(body1)
      result2 = Airport.new(body2)

      assert result1.body_sequence == 1
      assert result1.body_name == "FANZI-ACCRA"
      assert result2.body_sequence == 2
      assert result2.body_name == "RADAR-ACCRA"
    end

    test "handles different body names" do
      body_names = [
        "FANZI-ACCRA",
        "RADAR-VECTOR",
        "TEXTUAL-CLIMB",
        "OBSTACLE-DP"
      ]

      for body_name <- body_names do
        sample_data = create_sample_data(%{"BODY_NAME" => body_name})
        result = Airport.new(sample_data)
        assert result.body_name == body_name
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
      assert Airport.type() == "DP_APT"
    end
  end

  # Helper function to create sample data with default values
  defp create_sample_data(overrides) do
    Map.merge(%{
      "EFF_DATE" => "2025/08/07",
      "DP_NAME" => "ACCRA",
      "ARTCC" => "ZAU",
      "DP_COMPUTER_CODE" => "ACCRA5.ACCRA",
      "BODY_NAME" => "FANZI-ACCRA",
      "BODY_SEQ" => "1",
      "ARPT_ID" => "57C",
      "RWY_END_ID" => "ALL"
    }, overrides)
  end
end