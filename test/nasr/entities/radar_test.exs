defmodule NASR.Entities.RadarTest do
  use ExUnit.Case

  alias NASR.Entities.Radar

  describe "new/1" do
    test "creates struct from real-world RDR sample data - ASR radar" do
      sample_data = %{
        "EFF_DATE" => "2025/08/07",
        "FACILITY_ID" => "ABE",
        "FACILITY_TYPE" => "AIRPORT",
        "STATE_CODE" => "PA",
        "COUNTRY_CODE" => "US",
        "RADAR_TYPE" => "ASR",
        "RADAR_NO" => "1",
        "RADAR_HRS" => "24",
        "REMARK" => ""
      }

      result = Radar.new(sample_data)

      assert result.facility_id == "ABE"
      assert result.facility_type == :airport
      assert result.state_code == "PA"
      assert result.country_code == "US"
      assert result.radar_type == :asr
      assert result.radar_number == 1
      assert result.radar_hours == "24"
      assert result.remark == ""
      assert result.effective_date == ~D[2025-08-07]
    end

    test "creates struct from PAR radar with remarks" do
      sample_data = %{
        "EFF_DATE" => "2025/08/07",
        "FACILITY_ID" => "BAB",
        "FACILITY_TYPE" => "AIRPORT",
        "STATE_CODE" => "CA",
        "COUNTRY_CODE" => "US",
        "RADAR_TYPE" => "PAR",
        "RADAR_NO" => "3",
        "RADAR_HRS" => "1800-2200Z++TUE-THUR.",
        "REMARK" => "(RADAR_TYPE) RADAR - PAR - NO NOTAM MP: 1500-1730Z++ MON-FRI."
      }

      result = Radar.new(sample_data)

      assert result.facility_id == "BAB"
      assert result.facility_type == :airport
      assert result.radar_type == :par
      assert result.radar_number == 3
      assert result.radar_hours == "1800-2200Z++TUE-THUR."
      assert result.remark == "(RADAR_TYPE) RADAR - PAR - NO NOTAM MP: 1500-1730Z++ MON-FRI."
    end

    test "handles TRACON facility" do
      sample_data = create_sample_data(%{
        "FACILITY_ID" => "SCT",
        "FACILITY_TYPE" => "TRACON",
        "RADAR_TYPE" => "ASR"
      })

      result = Radar.new(sample_data)

      assert result.facility_id == "SCT"
      assert result.facility_type == :tracon
      assert result.radar_type == :asr
    end

    test "handles various radar types" do
      radar_types = [
        {"ASR", :asr},
        {"PAR", :par},
        {"ARSR", :arsr},
        {"BCN", :bcn}
      ]

      for {input, expected} <- radar_types do
        sample_data = create_sample_data(%{"RADAR_TYPE" => input})
        result = Radar.new(sample_data)
        assert result.radar_type == expected
      end
    end

    test "handles various facility types" do
      facility_types = [
        {"AIRPORT", :airport},
        {"TRACON", :tracon}
      ]

      for {input, expected} <- facility_types do
        sample_data = create_sample_data(%{"FACILITY_TYPE" => input})
        result = Radar.new(sample_data)
        assert result.facility_type == expected
      end
    end

    test "handles unknown radar type as string" do
      sample_data = create_sample_data(%{"RADAR_TYPE" => "UNKNOWN"})
      result = Radar.new(sample_data)
      assert result.radar_type == "UNKNOWN"
    end

    test "handles unknown facility type as string" do
      sample_data = create_sample_data(%{"FACILITY_TYPE" => "UNKNOWN"})
      result = Radar.new(sample_data)
      assert result.facility_type == "UNKNOWN"
    end

    test "handles various operating hours formats" do
      hours_formats = [
        "24",                              # 24-hour operation
        "0600-2300",                       # Simple time range
        "0600-0000",                       # Overnight operation
        "0800-1600 WKDAYS; EXCP HOLS",     # Weekdays except holidays
        "1800-2200Z++TUE-THUR.",           # Specific days with Z time
        "0700-2000"                        # Standard day hours
      ]

      for hours <- hours_formats do
        sample_data = create_sample_data(%{"RADAR_HRS" => hours})
        result = Radar.new(sample_data)
        assert result.radar_hours == hours
      end
    end

    test "handles multiple radars at same facility" do
      # First radar
      sample_data1 = create_sample_data(%{
        "FACILITY_ID" => "LAX",
        "RADAR_NO" => "1",
        "RADAR_TYPE" => "ASR"
      })

      result1 = Radar.new(sample_data1)
      assert result1.facility_id == "LAX"
      assert result1.radar_number == 1
      assert result1.radar_type == :asr

      # Second radar at same facility
      sample_data2 = create_sample_data(%{
        "FACILITY_ID" => "LAX",
        "RADAR_NO" => "2",
        "RADAR_TYPE" => "PAR"
      })

      result2 = Radar.new(sample_data2)
      assert result2.facility_id == "LAX"
      assert result2.radar_number == 2
      assert result2.radar_type == :par
    end

    test "handles empty/nil values correctly" do
      sample_data = create_sample_data(%{
        "RADAR_TYPE" => "",
        "FACILITY_TYPE" => "",
        "RADAR_NO" => "",
        "REMARK" => "",
        "EFF_DATE" => ""
      })

      result = Radar.new(sample_data)

      assert result.radar_type == nil
      assert result.facility_type == nil
      assert result.radar_number == nil
      assert result.remark == ""
      assert result.effective_date == nil
    end

    test "handles case insensitive radar type parsing" do
      sample_data = create_sample_data(%{"RADAR_TYPE" => "asr"})
      result = Radar.new(sample_data)
      assert result.radar_type == :asr

      sample_data = create_sample_data(%{"RADAR_TYPE" => "Par"})
      result = Radar.new(sample_data)
      assert result.radar_type == :par
    end

    test "handles case insensitive facility type parsing" do
      sample_data = create_sample_data(%{"FACILITY_TYPE" => "airport"})
      result = Radar.new(sample_data)
      assert result.facility_type == :airport

      sample_data = create_sample_data(%{"FACILITY_TYPE" => "Tracon"})
      result = Radar.new(sample_data)
      assert result.facility_type == :tracon
    end

    test "handles beacon radar type" do
      sample_data = create_sample_data(%{
        "FACILITY_ID" => "ASE",
        "RADAR_TYPE" => "BCN",
        "RADAR_HRS" => "0700-2000"
      })

      result = Radar.new(sample_data)

      assert result.facility_id == "ASE"
      assert result.radar_type == :bcn
      assert result.radar_hours == "0700-2000"
    end

    test "type/0 returns correct type string" do
      assert Radar.type() == "RDR"
    end
  end

  # Helper function to create sample data with default values
  defp create_sample_data(overrides) do
    Map.merge(
      %{
        "EFF_DATE" => "2025/08/07",
        "FACILITY_ID" => "TEST",
        "FACILITY_TYPE" => "AIRPORT",
        "STATE_CODE" => "CA",
        "COUNTRY_CODE" => "US",
        "RADAR_TYPE" => "ASR",
        "RADAR_NO" => "1",
        "RADAR_HRS" => "24",
        "REMARK" => ""
      },
      overrides
    )
  end
end