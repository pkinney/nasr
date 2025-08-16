defmodule NASR.Entities.HoldingPattern.SpeedAltitudeTest do
  use ExUnit.Case
  alias NASR.Entities.HoldingPattern.SpeedAltitude

  describe "new/1" do
    test "creates SpeedAltitude struct from HPF_SPD_ALT sample data" do
      sample_data = create_sample_data(%{})

      result = SpeedAltitude.new(sample_data)

      assert result.effective_date == ~D[2025-08-07]
      assert result.hp_name == "AABEE INT*GA*K7"
      assert result.hp_no == 1
      assert result.state_code == "GA"
      assert result.country_code == "US"
      assert result.speed_range == 200
      assert result.altitude == "30/54"
    end

    test "handles different speed restrictions" do
      test_cases = [
        {"200", 200},
        {"230", 230},
        {"265", 265},
        {"280", 280}
      ]

      for {speed_str, expected_speed} <- test_cases do
        sample_data = create_sample_data(%{"SPEED_RANGE" => speed_str})
        result = SpeedAltitude.new(sample_data)
        assert result.speed_range == expected_speed, "Failed for SPEED_RANGE: #{speed_str}"
      end
    end

    test "handles different altitude ranges" do
      test_cases = [
        {"30/54", "30/54"},
        {"180/450", "180/450"}, 
        {"170/240", "170/240"},
        {"160/220", "160/220"},
        {"24/60", "24/60"},
        {"59/70", "59/70"},
        {"29/60", "29/60"},
        {"100/175", "100/175"},
        {"36/60", "36/60"}
      ]

      for {altitude_str, expected_altitude} <- test_cases do
        sample_data = create_sample_data(%{"ALTITUDE" => altitude_str})
        result = SpeedAltitude.new(sample_data)
        assert result.altitude == expected_altitude, "Failed for ALTITUDE: #{altitude_str}"
      end
    end

    test "handles high altitude patterns" do
      high_alt_data = create_sample_data(%{
        "HP_NAME" => "AADEN WP*GA*K7",
        "SPEED_RANGE" => "265",
        "ALTITUDE" => "180/450"
      })

      result = SpeedAltitude.new(high_alt_data)
      
      assert result.hp_name == "AADEN WP*GA*K7"
      assert result.speed_range == 265
      assert result.altitude == "180/450"
    end

    test "handles low altitude patterns" do
      low_alt_data = create_sample_data(%{
        "HP_NAME" => "AAMMO WP*NC*K7",
        "SPEED_RANGE" => "230",
        "ALTITUDE" => "24/60"
      })

      result = SpeedAltitude.new(low_alt_data)
      
      assert result.hp_name == "AAMMO WP*NC*K7"
      assert result.speed_range == 230
      assert result.altitude == "24/60"
    end

    test "handles intermediate altitude patterns" do
      mid_alt_data = create_sample_data(%{
        "HP_NAME" => "AARCH WP*IL*K5",
        "SPEED_RANGE" => "280",
        "ALTITUDE" => "100/175"
      })

      result = SpeedAltitude.new(mid_alt_data)
      
      assert result.hp_name == "AARCH WP*IL*K5"
      assert result.speed_range == 280
      assert result.altitude == "100/175"
    end

    test "handles various waypoint naming patterns" do
      waypoint_patterns = [
        "AABEE INT*GA*K7",  # Intersection
        "AADEN WP*GA*K7",   # Waypoint
        "AALAN WP*AZ*K2",   # Different region
        "AALLE WP*CO*K2",   # Different state
        "AAMMO WP*NC*K7"    # Different combinations
      ]

      for hp_name <- waypoint_patterns do
        sample_data = create_sample_data(%{"HP_NAME" => hp_name})
        result = SpeedAltitude.new(sample_data)
        assert result.hp_name == hp_name
      end
    end

    test "handles empty/nil values correctly" do
      sample_data = create_sample_data(%{
        "HP_NO" => "",
        "SPEED_RANGE" => "",
        "ALTITUDE" => ""
      })

      result = SpeedAltitude.new(sample_data)

      assert result.hp_no == nil
      assert result.speed_range == nil
      assert result.altitude == ""
    end

    test "handles numeric conversion edge cases" do
      sample_data = create_sample_data(%{
        "HP_NO" => "2",
        "SPEED_RANGE" => "0",  # Edge case: zero speed
        "ALTITUDE" => "0/0"    # Edge case: zero altitude range
      })

      result = SpeedAltitude.new(sample_data)

      assert result.hp_no == 2
      assert result.speed_range == 0
      assert result.altitude == "0/0"
    end

    test "validates speed ranges are within realistic aviation limits" do
      # Test common holding pattern speeds
      realistic_speeds = [200, 230, 250, 265, 280]
      
      for speed <- realistic_speeds do
        sample_data = create_sample_data(%{"SPEED_RANGE" => Integer.to_string(speed)})
        result = SpeedAltitude.new(sample_data)
        assert result.speed_range == speed
        assert result.speed_range >= 200  # Minimum typical holding speed
        assert result.speed_range <= 280  # Maximum typical holding speed
      end
    end

    test "handles different ICAO region codes in pattern names" do
      region_patterns = [
        {"K7", "AABEE INT*GA*K7"},
        {"K2", "AALAN WP*AZ*K2"},
        {"K3", "AANZA WP*MN*K3"},
        {"K4", "AARGH WP*OK*K4"},
        {"K5", "AARCH WP*IL*K5"}
      ]

      for {region, hp_name} <- region_patterns do
        sample_data = create_sample_data(%{"HP_NAME" => hp_name})
        result = SpeedAltitude.new(sample_data)
        assert String.contains?(result.hp_name, region)
      end
    end
  end

  describe "type/0" do
    test "returns correct type string" do
      assert SpeedAltitude.type() == "HPF_SPD_ALT"
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
      "SPEED_RANGE" => "200",
      "ALTITUDE" => "30/54"
    }, overrides)
  end
end