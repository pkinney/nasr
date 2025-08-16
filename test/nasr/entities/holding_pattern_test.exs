defmodule NASR.Entities.HoldingPatternTest do
  use ExUnit.Case
  alias NASR.Entities.HoldingPattern

  describe "new/1" do
    test "creates HoldingPattern struct from HPF_BASE sample data" do
      sample_data = create_sample_data(%{})

      result = HoldingPattern.new(sample_data)

      assert result.effective_date == ~D[2025-08-07]
      assert result.hp_name == "AABEE INT*GA*K7"
      assert result.hp_no == 1
      assert result.state_code == "GA"
      assert result.country_code == "US"
      assert result.fix_id == "AABEE"
      assert result.icao_region_code == "K7"
      assert result.nav_id == "PDK"
      assert result.nav_type == :localizer_dme
      assert result.hold_direction == :northeast
      assert result.hold_deg_or_crs == 26
      assert result.azimuth == :course
      assert result.course_inbound_deg == 206
      assert result.turn_direction == :left
      assert result.leg_length_dist == nil
    end

    test "handles RNAV-based holding patterns" do
      rnav_data = create_sample_data(%{
        "HP_NAME" => "AADEN WP*GA*K7",
        "NAV_ID" => "",
        "NAV_TYPE" => "",
        "HOLD_DIRECTION" => "S",
        "HOLD_DEG_OR_CRS" => "165",
        "AZIMUTH" => "RNAV",
        "COURSE_INBOUND_DEG" => "345",
        "TURN_DIRECTION" => "R",
        "LEG_LENGTH_DIST" => "15"
      })

      result = HoldingPattern.new(rnav_data)
      
      assert result.hp_name == "AADEN WP*GA*K7"
      assert result.nav_id == ""
      assert result.nav_type == nil
      assert result.hold_direction == :south
      assert result.hold_deg_or_crs == 165
      assert result.azimuth == :rnav
      assert result.course_inbound_deg == 345
      assert result.turn_direction == :right
      assert result.leg_length_dist == 15
    end

    test "handles different navigation aid types" do
      test_cases = [
        {"LD", :localizer_dme},
        {"LS", :localizer},
        {"NDB", :ndb},
        {"TACAN", :tacan},
        {"VOR", :vor},
        {"VORTAC", :vortac},
        {"VOR/DME", :vor_dme}
      ]

      for {nav_type, expected_atom} <- test_cases do
        sample_data = create_sample_data(%{"NAV_TYPE" => nav_type})
        result = HoldingPattern.new(sample_data)
        assert result.nav_type == expected_atom, "Failed for NAV_TYPE: #{nav_type}"
      end
    end

    test "handles all holding directions" do
      test_cases = [
        {"N", :north},
        {"NE", :northeast},
        {"E", :east},
        {"SE", :southeast},
        {"S", :south},
        {"SW", :southwest},
        {"W", :west},
        {"NW", :northwest}
      ]

      for {direction, expected_atom} <- test_cases do
        sample_data = create_sample_data(%{"HOLD_DIRECTION" => direction})
        result = HoldingPattern.new(sample_data)
        assert result.hold_direction == expected_atom, "Failed for HOLD_DIRECTION: #{direction}"
      end
    end

    test "handles all azimuth types" do
      test_cases = [
        {"BRG", :bearing},
        {"CRS", :course},
        {"RADIAL", :radial},
        {"RNAV", :rnav}
      ]

      for {azimuth, expected_atom} <- test_cases do
        sample_data = create_sample_data(%{"AZIMUTH" => azimuth})
        result = HoldingPattern.new(sample_data)
        assert result.azimuth == expected_atom, "Failed for AZIMUTH: #{azimuth}"
      end
    end

    test "handles turn directions" do
      left_data = create_sample_data(%{"TURN_DIRECTION" => "L"})
      right_data = create_sample_data(%{"TURN_DIRECTION" => "R"})

      left_result = HoldingPattern.new(left_data)
      right_result = HoldingPattern.new(right_data)

      assert left_result.turn_direction == :left
      assert right_result.turn_direction == :right
    end

    test "handles empty/nil values correctly" do
      sample_data = create_sample_data(%{
        "HP_NO" => "",
        "NAV_ID" => "",
        "NAV_TYPE" => "",
        "HOLD_DEG_OR_CRS" => "",
        "COURSE_INBOUND_DEG" => "",
        "LEG_LENGTH_DIST" => ""
      })

      result = HoldingPattern.new(sample_data)

      assert result.hp_no == nil
      assert result.nav_id == ""
      assert result.nav_type == nil
      assert result.hold_deg_or_crs == nil
      assert result.course_inbound_deg == nil
      assert result.leg_length_dist == nil
    end

    test "handles invalid/unknown values" do
      sample_data = create_sample_data(%{
        "NAV_TYPE" => "UNKNOWN_TYPE",
        "HOLD_DIRECTION" => "INVALID",
        "AZIMUTH" => "UNKNOWN",
        "TURN_DIRECTION" => "X"
      })

      result = HoldingPattern.new(sample_data)

      assert result.nav_type == "UNKNOWN_TYPE"
      assert result.hold_direction == "INVALID"
      assert result.azimuth == "UNKNOWN"
      assert result.turn_direction == "X"
    end

    test "handles numeric conversions for courses and distances" do
      sample_data = create_sample_data(%{
        "HP_NO" => "2",
        "HOLD_DEG_OR_CRS" => "090",
        "COURSE_INBOUND_DEG" => "270",
        "LEG_LENGTH_DIST" => "10"
      })

      result = HoldingPattern.new(sample_data)

      assert result.hp_no == 2
      assert result.hold_deg_or_crs == 90
      assert result.course_inbound_deg == 270
      assert result.leg_length_dist == 10
    end
  end

  describe "type/0" do
    test "returns correct type string" do
      assert HoldingPattern.type() == "HPF_BASE"
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
      "FIX_ID" => "AABEE",
      "ICAO_REGION_CODE" => "K7",
      "NAV_ID" => "PDK",
      "NAV_TYPE" => "LD",
      "HOLD_DIRECTION" => "NE",
      "HOLD_DEG_OR_CRS" => "26",
      "AZIMUTH" => "CRS",
      "COURSE_INBOUND_DEG" => "206",
      "TURN_DIRECTION" => "L",
      "LEG_LENGTH_DIST" => ""
    }, overrides)
  end
end