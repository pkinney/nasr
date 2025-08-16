defmodule NASR.Entities.MaximumAuthorizedAltitude.ControlTest do
  use ExUnit.Case
  alias NASR.Entities.MaximumAuthorizedAltitude.Control

  describe "new/1" do
    test "creates Control struct from MAA_CON sample data" do
      sample_data = create_sample_data(%{})

      result = Control.new(sample_data)

      assert result.effective_date == ~D[2025-08-07]
      assert result.maa_id == "ACO001"
      assert result.freq_seq == 1
      assert result.fac_id == "ZDV"
      assert result.fac_name == "DENVER"
      assert result.commercial_freq == 128.37
      assert result.commercial_chart_flag == :no
      assert result.mil_freq == 379.95
      assert result.mil_chart_flag == :no
    end

    test "handles different ARTCC facilities" do
      denver_data = create_sample_data(%{
        "FAC_ID" => "ZDV",
        "FAC_NAME" => "DENVER",
        "COMMERCIAL_FREQ" => "133.4",
        "MIL_FREQ" => "387.15"
      })

      result = Control.new(denver_data)
      
      assert result.fac_id == "ZDV"
      assert result.fac_name == "DENVER"
      assert result.commercial_freq == 133.4
      assert result.mil_freq == 387.15
    end

    test "handles FSS facilities" do
      fss_data = create_sample_data(%{
        "MAA_ID" => "APA001",
        "FAC_ID" => "",
        "FAC_NAME" => "WASHINGTON HUB FSS",
        "COMMERCIAL_FREQ" => "123.6",
        "COMMERCIAL_CHART_FLAG" => "N",
        "MIL_FREQ" => "",
        "MIL_CHART_FLAG" => ""
      })

      result = Control.new(fss_data)
      
      assert result.maa_id == "APA001"
      assert result.fac_id == ""
      assert result.fac_name == "WASHINGTON HUB FSS"
      assert result.commercial_freq == 123.6
      assert result.commercial_chart_flag == :no
      assert result.mil_freq == nil
      assert result.mil_chart_flag == nil
    end

    test "handles chart flag values" do
      test_cases = [
        {"Y", :yes},
        {"N", :no}
      ]

      for {flag_value, expected_atom} <- test_cases do
        commercial_data = create_sample_data(%{"COMMERCIAL_CHART_FLAG" => flag_value})
        military_data = create_sample_data(%{"MIL_CHART_FLAG" => flag_value})
        
        commercial_result = Control.new(commercial_data)
        military_result = Control.new(military_data)
        
        assert commercial_result.commercial_chart_flag == expected_atom, "Failed for COMMERCIAL_CHART_FLAG: #{flag_value}"
        assert military_result.mil_chart_flag == expected_atom, "Failed for MIL_CHART_FLAG: #{flag_value}"
      end
    end

    test "handles multiple frequency sequences" do
      freq1_data = create_sample_data(%{
        "FREQ_SEQ" => "1",
        "COMMERCIAL_FREQ" => "128.37",
        "MIL_FREQ" => "379.95"
      })

      freq2_data = create_sample_data(%{
        "FREQ_SEQ" => "2",
        "COMMERCIAL_FREQ" => "133.4", 
        "MIL_FREQ" => "387.15"
      })

      result1 = Control.new(freq1_data)
      result2 = Control.new(freq2_data)

      assert result1.freq_seq == 1
      assert result2.freq_seq == 2
      assert result1.commercial_freq == 128.37
      assert result2.commercial_freq == 133.4
      assert result1.mil_freq == 379.95
      assert result2.mil_freq == 387.15
    end

    test "handles VHF commercial frequencies" do
      vhf_frequencies = [
        "118.0",
        "121.5",
        "123.6",
        "128.37",
        "133.4",
        "135.95"
      ]

      for freq_str <- vhf_frequencies do
        sample_data = create_sample_data(%{"COMMERCIAL_FREQ" => freq_str})
        result = Control.new(sample_data)
        freq_value = String.to_float(freq_str)
        assert result.commercial_freq == freq_value
        assert result.commercial_freq >= 118.0  # VHF airband lower limit
        assert result.commercial_freq <= 137.0  # VHF airband upper limit
      end
    end

    test "handles UHF military frequencies" do
      uhf_frequencies = [
        "225.0",
        "250.5",
        "300.25",
        "350.75",
        "379.95",
        "387.15",
        "399.95"
      ]

      for freq_str <- uhf_frequencies do
        sample_data = create_sample_data(%{"MIL_FREQ" => freq_str})
        result = Control.new(sample_data)
        freq_value = String.to_float(freq_str)
        assert result.mil_freq == freq_value
        assert result.mil_freq >= 225.0  # UHF airband lower limit
        assert result.mil_freq <= 400.0  # UHF airband upper limit
      end
    end

    test "handles different MAA area types" do
      maa_ids = [
        "ACO001",  # Colorado area
        "ACO002",  # Another Colorado area
        "APA001"   # Practice area
      ]

      for maa_id <- maa_ids do
        sample_data = create_sample_data(%{"MAA_ID" => maa_id})
        result = Control.new(sample_data)
        assert result.maa_id == maa_id
      end
    end

    test "handles facilities without military frequencies" do
      civilian_only = create_sample_data(%{
        "FAC_NAME" => "WASHINGTON HUB FSS",
        "COMMERCIAL_FREQ" => "123.6",
        "MIL_FREQ" => ""
      })

      result = Control.new(civilian_only)
      
      assert result.fac_name == "WASHINGTON HUB FSS"
      assert result.commercial_freq == 123.6
      assert result.mil_freq == nil
    end

    test "handles facilities without commercial frequencies" do
      military_only = create_sample_data(%{
        "COMMERCIAL_FREQ" => "",
        "MIL_FREQ" => "379.95"
      })

      result = Control.new(military_only)
      
      assert result.commercial_freq == nil
      assert result.mil_freq == 379.95
    end

    test "handles empty/nil values correctly" do
      sample_data = create_sample_data(%{
        "FREQ_SEQ" => "",
        "COMMERCIAL_FREQ" => "",
        "COMMERCIAL_CHART_FLAG" => "",
        "MIL_FREQ" => "",
        "MIL_CHART_FLAG" => ""
      })

      result = Control.new(sample_data)

      assert result.freq_seq == nil
      assert result.commercial_freq == nil
      assert result.commercial_chart_flag == nil
      assert result.mil_freq == nil
      assert result.mil_chart_flag == nil
    end

    test "handles unknown chart flag values" do
      sample_data = create_sample_data(%{
        "COMMERCIAL_CHART_FLAG" => "UNKNOWN",
        "MIL_CHART_FLAG" => "INVALID"
      })

      result = Control.new(sample_data)

      assert result.commercial_chart_flag == "UNKNOWN"
      assert result.mil_chart_flag == "INVALID"
    end

    test "handles different ARTCC identifiers" do
      artcc_facilities = [
        {"ZDV", "DENVER"},
        {"ZOB", "CLEVELAND"},
        {"ZNY", "NEW YORK"},
        {"ZLA", "LOS ANGELES"},
        {"ZAU", "CHICAGO"}
      ]

      for {fac_id, fac_name} <- artcc_facilities do
        sample_data = create_sample_data(%{
          "FAC_ID" => fac_id,
          "FAC_NAME" => fac_name
        })
        result = Control.new(sample_data)
        assert result.fac_id == fac_id
        assert result.fac_name == fac_name
      end
    end
  end

  describe "type/0" do
    test "returns correct type string" do
      assert Control.type() == "MAA_CON"
    end
  end

  # Helper function to create sample data with default values
  defp create_sample_data(overrides) do
    Map.merge(%{
      "EFF_DATE" => "2025/08/07",
      "MAA_ID" => "ACO001",
      "FREQ_SEQ" => "1",
      "FAC_ID" => "ZDV",
      "FAC_NAME" => "DENVER",
      "COMMERCIAL_FREQ" => "128.37",
      "COMMERCIAL_CHART_FLAG" => "N",
      "MIL_FREQ" => "379.95",
      "MIL_CHART_FLAG" => "N"
    }, overrides)
  end
end