defmodule NASR.Entities.FrequencyTest do
  use ExUnit.Case
  alias NASR.Entities.Frequency

  describe "new/1" do
    test "creates Frequency struct from CSV data" do
      raw_data = create_sample_data()

      freq = Frequency.new(raw_data)

      assert freq.effective_date == ~D[2025-08-07]
      assert freq.facility == "00A"
      assert freq.fac_name == "TOTAL RF"
      assert freq.facility_type == :non_atct
      assert freq.artcc_or_fss_id == ""
      assert freq.cpdlc == ""
      assert freq.tower_hrs == ""
      assert freq.serviced_facility == "00A"
      assert freq.serviced_fac_name == "TOTAL RF"
      assert freq.serviced_site_type == :heliport
      assert freq.latitude == 40.07083333
      assert freq.longitude == -74.93361111
      assert freq.serviced_city == "BENSALEM"
      assert freq.serviced_state == "PA"
      assert freq.serviced_country == "US"
      assert freq.tower_or_comm_call == ""
      assert freq.primary_approach_radio_call == ""
      assert freq.frequency == 122.9
      assert freq.sectorization == ""
      assert freq.freq_use == :ctaf
      assert freq.remark == ""
    end

    test "handles all facility types" do
      facility_types = [
        {"ATCT", :atct},
        {"NON-ATCT", :non_atct},
        {"ASOS_AWOS", :asos_awos}
      ]

      for {type, expected_atom} <- facility_types do
        raw_data = create_sample_data(%{"FACILITY_TYPE" => type})
        freq = Frequency.new(raw_data)
        assert freq.facility_type == expected_atom
      end
    end

    test "handles all serviced site types" do
      site_types = [
        {"AIRPORT", :airport},
        {"BALLOONPORT", :balloonport},
        {"SEAPLANE BASE", :seaplane_base},
        {"GLIDERPORT", :gliderport},
        {"HELIPORT", :heliport},
        {"ULTRALIGHT", :ultralight},
        {"AWOS-1", :awos_1},
        {"AWOS-2", :awos_2},
        {"AWOS-3", :awos_3},
        {"AWOS-A", :awos_a},
        {"AWOS-AV", :awos_av},
        {"ASOS", :asos}
      ]

      for {type, expected_atom} <- site_types do
        raw_data = create_sample_data(%{"SERVICED_SITE_TYPE" => type})
        freq = Frequency.new(raw_data)
        assert freq.serviced_site_type == expected_atom
      end
    end

    test "handles all frequency use types" do
      freq_uses = [
        {"APPROACH", :approach},
        {"ARRIVAL", :arrival},
        {"ATIS", :atis},
        {"CLEARANCE DELIVERY", :clearance_delivery},
        {"CD", :clearance_delivery},
        {"CTAF", :ctaf},
        {"DEPARTURE", :departure},
        {"EMERGENCY", :emergency},
        {"GND", :ground},
        {"GROUND", :ground},
        {"MULTICOM", :multicom},
        {"TOWER", :tower},
        {"TWR", :tower},
        {"UNICOM", :unicom}
      ]

      for {use, expected_atom} <- freq_uses do
        raw_data = create_sample_data(%{"FREQ_USE" => use})
        freq = Frequency.new(raw_data)
        assert freq.freq_use == expected_atom
      end
    end

    test "handles AWOS frequency use types" do
      awos_freq_uses = [
        {"00U AWOS-3", :awos},
        {"01G AWOS-2", :awos},
        {"AWOS-1", :awos}
      ]

      for {use, expected_atom} <- awos_freq_uses do
        raw_data = create_sample_data(%{"FREQ_USE" => use})
        freq = Frequency.new(raw_data)
        assert freq.freq_use == expected_atom
      end
    end

    test "handles ASOS frequency use types" do
      asos_freq_uses = [
        {"ASOS", :asos},
        {"ABC ASOS", :asos}
      ]

      for {use, expected_atom} <- asos_freq_uses do
        raw_data = create_sample_data(%{"FREQ_USE" => use})
        freq = Frequency.new(raw_data)
        assert freq.freq_use == expected_atom
      end
    end

    test "handles empty and nil values" do
      raw_data = create_sample_data(%{
        "ARTCC_OR_FSS_ID" => "",
        "CPDLC" => "",
        "TOWER_HRS" => "",
        "TOWER_OR_COMM_CALL" => "",
        "PRIMARY_APPROACH_RADIO_CALL" => "",
        "SECTORIZATION" => "",
        "FREQ_USE" => "",
        "REMARK" => ""
      })

      freq = Frequency.new(raw_data)

      assert freq.artcc_or_fss_id == ""
      assert freq.cpdlc == ""
      assert freq.tower_hrs == ""
      assert freq.tower_or_comm_call == ""
      assert freq.primary_approach_radio_call == ""
      assert freq.sectorization == ""
      assert freq.freq_use == nil
      assert freq.remark == ""
    end

    test "handles frequency with decimal values" do
      raw_data = create_sample_data(%{
        "FREQ" => "122.725"
      })

      freq = Frequency.new(raw_data)

      assert freq.frequency == 122.725
    end

    test "handles data with remarks" do
      raw_data = create_sample_data(%{
        "REMARK" => "PAPI RY 10 AND RY 28; MIRL RY 10/28 OPER DUSK-1000; AFTER 1000 ACTVT - CTAF."
      })

      freq = Frequency.new(raw_data)

      assert freq.remark == "PAPI RY 10 AND RY 28; MIRL RY 10/28 OPER DUSK-1000; AFTER 1000 ACTVT - CTAF."
    end

    test "handles ATCT facility with tower hours" do
      raw_data = create_sample_data(%{
        "FACILITY_TYPE" => "ATCT",
        "TOWER_HRS" => "0600-2200",
        "TOWER_OR_COMM_CALL" => "TOWER",
        "PRIMARY_APPROACH_RADIO_CALL" => "APPROACH"
      })

      freq = Frequency.new(raw_data)

      assert freq.facility_type == :atct
      assert freq.tower_hrs == "0600-2200"
      assert freq.tower_or_comm_call == "TOWER"
      assert freq.primary_approach_radio_call == "APPROACH"
    end

    test "handles AWOS facility data" do
      raw_data = create_sample_data(%{
        "FACILITY" => "00U",
        "FAC_NAME" => "",
        "FACILITY_TYPE" => "ASOS_AWOS",
        "SERVICED_FACILITY" => "00U",
        "SERVICED_FAC_NAME" => "",
        "SERVICED_SITE_TYPE" => "AWOS-3",
        "FREQ" => "118.325",
        "FREQ_USE" => "00U AWOS-3"
      })

      freq = Frequency.new(raw_data)

      assert freq.facility == "00U"
      assert freq.fac_name == ""
      assert freq.facility_type == :asos_awos
      assert freq.serviced_site_type == :awos_3
      assert freq.frequency == 118.325
      assert freq.freq_use == :awos
    end

    test "handles unknown facility type and site type" do
      raw_data = create_sample_data(%{
        "FACILITY_TYPE" => "UNKNOWN",
        "SERVICED_SITE_TYPE" => "UNKNOWN_TYPE",
        "FREQ_USE" => "UNKNOWN_USE"
      })

      freq = Frequency.new(raw_data)

      assert freq.facility_type == "UNKNOWN"
      assert freq.serviced_site_type == "UNKNOWN_TYPE"
      assert freq.freq_use == "UNKNOWN_USE"
    end

    test "handles case insensitive frequency use" do
      raw_data = create_sample_data(%{"FREQ_USE" => "ctaf"})
      freq = Frequency.new(raw_data)
      assert freq.freq_use == :ctaf

      raw_data = create_sample_data(%{"FREQ_USE" => "unicom"})
      freq = Frequency.new(raw_data)
      assert freq.freq_use == :unicom
    end
  end

  describe "type/0" do
    test "returns correct type string" do
      assert Frequency.type() == "FRQ"
    end
  end

  defp create_sample_data(overrides \\ %{}) do
    %{
      "EFF_DATE" => "2025/08/07",
      "FACILITY" => "00A",
      "FAC_NAME" => "TOTAL RF",
      "FACILITY_TYPE" => "NON-ATCT",
      "ARTCC_OR_FSS_ID" => "",
      "CPDLC" => "",
      "TOWER_HRS" => "",
      "SERVICED_FACILITY" => "00A",
      "SERVICED_FAC_NAME" => "TOTAL RF",
      "SERVICED_SITE_TYPE" => "HELIPORT",
      "LAT_DECIMAL" => "40.07083333",
      "LONG_DECIMAL" => "-74.93361111",
      "SERVICED_CITY" => "BENSALEM",
      "SERVICED_STATE" => "PA",
      "SERVICED_COUNTRY" => "US",
      "TOWER_OR_COMM_CALL" => "",
      "PRIMARY_APPROACH_RADIO_CALL" => "",
      "FREQ" => "122.9",
      "SECTORIZATION" => "",
      "FREQ_USE" => "CTAF",
      "REMARK" => ""
    }
    |> Map.merge(overrides)
  end
end