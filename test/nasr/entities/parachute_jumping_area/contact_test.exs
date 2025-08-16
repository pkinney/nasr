defmodule NASR.Entities.ParachuteJumpingArea.ContactTest do
  use ExUnit.Case
  alias NASR.Entities.ParachuteJumpingArea.Contact

  describe "new/1" do
    test "creates Contact struct from PJA_CON sample data" do
      sample_data = create_sample_data(%{})

      result = Contact.new(sample_data)

      assert result.effective_date == ~D[2025-08-07]
      assert result.pja_id == "PAK002"
      assert result.facility_id == "FAI"
      assert result.facility_name == "FAIRBANKS INTL"
      assert result.location_id == "FAI"
      assert result.commercial_frequency == 126.5
      assert result.commercial_chart_flag == true
      assert result.military_frequency == nil
      assert result.military_chart_flag == nil
      assert result.sector == ""
      assert result.contact_frequency_altitude == ""
    end

    test "handles different air traffic control facilities" do
      # Test Anchorage International
      anc_data = create_sample_data(%{
        "PJA_ID" => "PAK006",
        "FAC_ID" => "ANC",
        "FAC_NAME" => "TED STEVENS ANCHORAGE INTL",
        "LOC_ID" => "ANC",
        "COMMERCIAL_FREQ" => "126.4",
        "COMMERCIAL_CHART_FLAG" => "N"
      })

      result = Contact.new(anc_data)
      assert result.pja_id == "PAK006"
      assert result.facility_id == "ANC"
      assert result.facility_name == "TED STEVENS ANCHORAGE INTL"
      assert result.location_id == "ANC"
      assert result.commercial_frequency == 126.4
      assert result.commercial_chart_flag == false

      # Test ARTCC facility
      artcc_data = create_sample_data(%{
        "PJA_ID" => "PAZ001",
        "FAC_ID" => "ZAB",
        "FAC_NAME" => "ALBUQUERQUE",
        "LOC_ID" => "ZAB",
        "COMMERCIAL_FREQ" => "125.25",
        "COMMERCIAL_CHART_FLAG" => "Y"
      })

      result = Contact.new(artcc_data)
      assert result.pja_id == "PAZ001"
      assert result.facility_id == "ZAB"
      assert result.facility_name == "ALBUQUERQUE"
      assert result.location_id == "ZAB"
      assert result.commercial_frequency == 125.25
      assert result.commercial_chart_flag == true
    end

    test "handles TRACON facilities" do
      tracon_data = create_sample_data(%{
        "PJA_ID" => "PAL036",
        "FAC_ID" => "P31",
        "FAC_NAME" => "PENSACOLA TRACON",
        "LOC_ID" => "P31",
        "COMMERCIAL_FREQ" => "122",
        "COMMERCIAL_CHART_FLAG" => "N"
      })

      result = Contact.new(tracon_data)
      assert result.pja_id == "PAL036"
      assert result.facility_id == "P31"
      assert result.facility_name == "PENSACOLA TRACON"
      assert result.location_id == "P31"
      assert result.commercial_frequency == 122.0
      assert result.commercial_chart_flag == false
    end

    test "handles approach control facilities" do
      approach_data = create_sample_data(%{
        "PJA_ID" => "PAK027",
        "FAC_ID" => "A11",
        "FAC_NAME" => "ANCHORAGE APPROACH CONTROL",
        "LOC_ID" => "I90",
        "COMMERCIAL_FREQ" => "118.6",
        "COMMERCIAL_CHART_FLAG" => "Y"
      })

      result = Contact.new(approach_data)
      assert result.pja_id == "PAK027"
      assert result.facility_id == "A11"
      assert result.facility_name == "ANCHORAGE APPROACH CONTROL"
      assert result.location_id == "I90"
      assert result.commercial_frequency == 118.6
      assert result.commercial_chart_flag == true
    end

    test "handles regional airports" do
      regional_data = create_sample_data(%{
        "PJA_ID" => "PAL032",
        "FAC_ID" => "MGM",
        "FAC_NAME" => "MONTGOMERY RGNL (DANNELLY FLD)",
        "LOC_ID" => "MGM",
        "COMMERCIAL_FREQ" => "121.2",
        "COMMERCIAL_CHART_FLAG" => "Y"
      })

      result = Contact.new(regional_data)
      assert result.pja_id == "PAL032"
      assert result.facility_id == "MGM"
      assert result.facility_name == "MONTGOMERY RGNL (DANNELLY FLD)"
      assert result.location_id == "MGM"
      assert result.commercial_frequency == 121.2
      assert result.commercial_chart_flag == true
    end

    test "handles chart flag conversions" do
      test_cases = [
        {"Y", true},
        {"N", false},
        {"", nil}
      ]

      for {input, expected} <- test_cases do
        sample_data = create_sample_data(%{
          "COMMERCIAL_CHART_FLAG" => input,
          "MIL_CHART_FLAG" => input
        })
        result = Contact.new(sample_data)
        assert result.commercial_chart_flag == expected
        assert result.military_chart_flag == expected
      end
    end

    test "handles frequency conversions" do
      # Test decimal frequencies
      decimal_freq = create_sample_data(%{
        "COMMERCIAL_FREQ" => "118.6",
        "MIL_FREQ" => ""
      })

      result = Contact.new(decimal_freq)
      assert result.commercial_frequency == 118.6
      assert result.military_frequency == nil

      # Test integer frequencies
      integer_freq = create_sample_data(%{
        "COMMERCIAL_FREQ" => "122",
        "MIL_FREQ" => "243"
      })

      result = Contact.new(integer_freq)
      assert result.commercial_frequency == 122.0
      assert result.military_frequency == 243.0
    end

    test "handles military frequencies" do
      military_data = create_sample_data(%{
        "COMMERCIAL_FREQ" => "121.5",
        "COMMERCIAL_CHART_FLAG" => "Y",
        "MIL_FREQ" => "243.0",
        "MIL_CHART_FLAG" => "Y"
      })

      result = Contact.new(military_data)
      assert result.commercial_frequency == 121.5
      assert result.commercial_chart_flag == true
      assert result.military_frequency == 243.0
      assert result.military_chart_flag == true
    end

    test "handles sector designations" do
      sector_data = create_sample_data(%{
        "SECTOR" => "A"
      })

      result = Contact.new(sector_data)
      assert result.sector == "A"
    end

    test "handles contact frequency altitude restrictions" do
      altitude_data = create_sample_data(%{
        "CONTACT_FREQ_ALTITUDE" => "BELOW 10000 FT"
      })

      result = Contact.new(altitude_data)
      assert result.contact_frequency_altitude == "BELOW 10000 FT"
    end

    test "handles empty/nil values correctly" do
      sample_data = create_sample_data(%{
        "EFF_DATE" => "",
        "COMMERCIAL_FREQ" => "",
        "COMMERCIAL_CHART_FLAG" => "",
        "MIL_FREQ" => "",
        "MIL_CHART_FLAG" => "",
        "SECTOR" => "",
        "CONTACT_FREQ_ALTITUDE" => ""
      })

      result = Contact.new(sample_data)

      assert result.effective_date == nil
      assert result.commercial_frequency == nil
      assert result.commercial_chart_flag == nil
      assert result.military_frequency == nil
      assert result.military_chart_flag == nil
      assert result.sector == ""
      assert result.contact_frequency_altitude == ""
    end

    test "handles multiple frequencies for same PJA" do
      # Different frequencies for the same PJA from different facilities
      pja_freq1 = create_sample_data(%{
        "PJA_ID" => "PAK013",
        "FAC_ID" => "ANC",
        "COMMERCIAL_FREQ" => "126.4"
      })

      pja_freq2 = create_sample_data(%{
        "PJA_ID" => "PAK019",
        "FAC_ID" => "ANC",
        "COMMERCIAL_FREQ" => "118.6"
      })

      result1 = Contact.new(pja_freq1)
      result2 = Contact.new(pja_freq2)

      assert result1.pja_id == "PAK013"
      assert result1.commercial_frequency == 126.4
      assert result2.pja_id == "PAK019"
      assert result2.commercial_frequency == 118.6
    end

    test "handles different facility types for same airport" do
      # Multiple facilities at same location
      tower_data = create_sample_data(%{
        "FAC_ID" => "TUS",
        "FAC_NAME" => "TUCSON INTL",
        "LOC_ID" => "TUS",
        "COMMERCIAL_FREQ" => "125.1"
      })

      result = Contact.new(tower_data)
      assert result.facility_id == "TUS"
      assert result.facility_name == "TUCSON INTL"
      assert result.location_id == "TUS"
      assert result.commercial_frequency == 125.1
    end
  end

  describe "type/0" do
    test "returns correct type string" do
      assert Contact.type() == "PJA_CON"
    end
  end

  # Helper function to create sample data with default values
  defp create_sample_data(overrides) do
    Map.merge(%{
      "EFF_DATE" => "2025/08/07",
      "PJA_ID" => "PAK002",
      "FAC_ID" => "FAI",
      "FAC_NAME" => "FAIRBANKS INTL",
      "LOC_ID" => "FAI",
      "COMMERCIAL_FREQ" => "126.5",
      "COMMERCIAL_CHART_FLAG" => "Y",
      "MIL_FREQ" => "",
      "MIL_CHART_FLAG" => "",
      "SECTOR" => "",
      "CONTACT_FREQ_ALTITUDE" => ""
    }, overrides)
  end
end