defmodule NASR.Entities.NavTest do
  use ExUnit.Case
  alias NASR.Entities.Nav

  describe "new/1" do
    test "creates Nav struct from NAV_BASE sample data" do
      sample_data = create_sample_data(%{})

      result = Nav.new(sample_data)

      assert result.effective_date == ~D[2025-08-07]
      assert result.nav_id == "AA"
      assert result.nav_type == :ndb
      assert result.state_code == "ND"
      assert result.city == "FARGO"
      assert result.country_code == "US"
      assert result.nav_status == "OPERATIONAL IFR"
      assert result.name == "KENIE"
      assert result.state_name == "NORTH DAKOTA"
      assert result.region_code == :agl
      assert result.country_name == "UNITED STATES"
      assert result.fan_marker == ""
      assert result.owner == "F-FEDERAL AVIATION ADMIN"
      assert result.operator == "F-FEDERAL AVIATION ADMIN"
      assert result.nas_use_flag == true
      assert result.public_use_flag == true
      assert result.ndb_class_code == "HW/LOM"
      assert result.oper_hours == "24"
      assert result.high_alt_artcc_id == "ZMP"
      assert result.high_artcc_name == "MINNEAPOLIS"
      assert result.low_alt_artcc_id == "ZMP"
      assert result.low_artcc_name == "MINNEAPOLIS"
      assert result.latitude == 47.00905216
      assert result.longitude == -96.8151835
      assert result.survey_accuracy_code == :nos
      assert result.tacan_dme_status == ""
      assert result.tacan_dme_latitude == nil
      assert result.tacan_dme_longitude == nil
      assert result.elevation == 890.6
      assert result.magnetic_variation == 4.0
      assert result.magnetic_hemisphere == "E"
      assert result.magnetic_variation_year == 2005
      assert result.simul_voice_flag == false
      assert result.power_output == 100
      assert result.auto_voice_id_flag == false
      assert result.mnt_cat_code == "1"
      assert result.voice_call == "NONE"
      assert result.channel == nil
      assert result.frequency == 365.0
      assert result.marker_ident == ""
      assert result.marker_shape == ""
      assert result.marker_bearing == ""
      assert result.alt_code == nil
      assert result.dme_ssv == nil
      assert result.low_nav_on_high_chart_flag == false
      assert result.z_marker_flag == false
      assert result.fss_id == "GFK"
      assert result.fss_name == "GRAND FORKS"
      assert result.fss_hours == "24"
      assert result.notam_id == "FAR"
      assert result.quad_ident == ""
      assert result.pitch_flag == false
      assert result.catch_flag == false
      assert result.sua_atcaa_flag == false
      assert result.restriction_flag == ""
      assert result.hiwas_flag == ""
    end

    test "handles different nav types" do
      nav_types = [
        {"CONSOLAN", :consolan},
        {"DME", :dme},
        {"FAN MARKER", :fan_marker},
        {"MARINE NDB", :marine_ndb},
        {"MARINE NDB/DME", :marine_ndb_dme},
        {"NDB", :ndb},
        {"NDB/DME", :ndb_dme},
        {"TACAN", :tacan},
        {"UHF/NDB", :uhf_ndb},
        {"VOR", :vor},
        {"VORTAC", :vortac},
        {"VOR/DME", :vor_dme},
        {"VOT", :vot}
      ]

      for {input, expected} <- nav_types do
        sample_data = create_sample_data(%{"NAV_TYPE" => input})
        result = Nav.new(sample_data)
        assert result.nav_type == expected
      end
    end

    test "handles region codes" do
      region_codes = [
        {"AAL", :aal},
        {"ACE", :ace},
        {"AEA", :aea},
        {"AGL", :agl},
        {"ANE", :ane},
        {"ANM", :anm},
        {"ASO", :aso},
        {"ASW", :asw},
        {"AWP", :awp}
      ]

      for {input, expected} <- region_codes do
        sample_data = create_sample_data(%{"REGION_CODE" => input})
        result = Nav.new(sample_data)
        assert result.region_code == expected
      end
    end

    test "handles survey accuracy codes" do
      survey_codes = [
        {"0", :unknown},
        {"1", :degree},
        {"2", :ten_minutes},
        {"3", :one_minute},
        {"4", :ten_seconds},
        {"5", :one_second_or_better},
        {"6", :nos},
        {"7", :third_order_triangulation}
      ]

      for {input, expected} <- survey_codes do
        sample_data = create_sample_data(%{"SURVEY_ACCURACY_CODE" => input})
        result = Nav.new(sample_data)
        assert result.survey_accuracy_code == expected
      end
    end

    test "handles altitude codes" do
      alt_codes = [
        {"H", :high},
        {"L", :low},
        {"T", :terminal},
        {"VH", :vor_high},
        {"VL", :vor_low}
      ]

      for {input, expected} <- alt_codes do
        sample_data = create_sample_data(%{"ALT_CODE" => input})
        result = Nav.new(sample_data)
        assert result.alt_code == expected
      end
    end

    test "handles DME SSV codes" do
      dme_codes = [
        {"H", :high},
        {"L", :low},
        {"T", :terminal},
        {"DH", :dme_high},
        {"DL", :dme_low}
      ]

      for {input, expected} <- dme_codes do
        sample_data = create_sample_data(%{"DME_SSV" => input})
        result = Nav.new(sample_data)
        assert result.dme_ssv == expected
      end
    end

    test "handles Y/N flags correctly" do
      # Test with Y values
      sample_data = create_sample_data(%{
        "NAS_USE_FLAG" => "Y",
        "PUBLIC_USE_FLAG" => "Y",
        "SIMUL_VOICE_FLAG" => "Y",
        "AUTO_VOICE_ID_FLAG" => "Y",
        "LOW_NAV_ON_HIGH_CHART_FLAG" => "Y",
        "Z_MKR_FLAG" => "Y",
        "PITCH_FLAG" => "Y",
        "CATCH_FLAG" => "Y",
        "SUA_ATCAA_FLAG" => "Y"
      })

      result = Nav.new(sample_data)
      assert result.nas_use_flag == true
      assert result.public_use_flag == true
      assert result.simul_voice_flag == true
      assert result.auto_voice_id_flag == true
      assert result.low_nav_on_high_chart_flag == true
      assert result.z_marker_flag == true
      assert result.pitch_flag == true
      assert result.catch_flag == true
      assert result.sua_atcaa_flag == true

      # Test with N values
      sample_data = create_sample_data(%{
        "NAS_USE_FLAG" => "N",
        "PUBLIC_USE_FLAG" => "N",
        "SIMUL_VOICE_FLAG" => "N",
        "AUTO_VOICE_ID_FLAG" => "N",
        "LOW_NAV_ON_HIGH_CHART_FLAG" => "N",
        "Z_MKR_FLAG" => "N",
        "PITCH_FLAG" => "N",
        "CATCH_FLAG" => "N",
        "SUA_ATCAA_FLAG" => "N"
      })

      result = Nav.new(sample_data)
      assert result.nas_use_flag == false
      assert result.public_use_flag == false
      assert result.simul_voice_flag == false
      assert result.auto_voice_id_flag == false
      assert result.low_nav_on_high_chart_flag == false
      assert result.z_marker_flag == false
      assert result.pitch_flag == false
      assert result.catch_flag == false
      assert result.sua_atcaa_flag == false
    end

    test "handles VOR navaid" do
      vor_data = create_sample_data(%{
        "NAV_ID" => "SEA",
        "NAV_TYPE" => "VOR",
        "NAME" => "SEATTLE",
        "FREQ" => "116.8",
        "ALT_CODE" => "H",
        "DME_SSV" => "",
        "VOICE_CALL" => "SEATTLE VOR"
      })

      result = Nav.new(vor_data)
      assert result.nav_id == "SEA"
      assert result.nav_type == :vor
      assert result.name == "SEATTLE"
      assert result.frequency == 116.8
      assert result.alt_code == :high
      assert result.dme_ssv == nil
      assert result.voice_call == "SEATTLE VOR"
    end

    test "handles VORTAC with separate TACAN location" do
      vortac_data = create_sample_data(%{
        "NAV_TYPE" => "VORTAC",
        "TACAN_DME_STATUS" => "OPERATIONAL",
        "TACAN_DME_LAT_DECIMAL" => "47.4397",
        "TACAN_DME_LONG_DECIMAL" => "-122.3094",
        "ALT_CODE" => "H",
        "DME_SSV" => "H",
        "CHAN" => "114"
      })

      result = Nav.new(vortac_data)
      assert result.nav_type == :vortac
      assert result.tacan_dme_status == "OPERATIONAL"
      assert result.tacan_dme_latitude == 47.4397
      assert result.tacan_dme_longitude == -122.3094
      assert result.alt_code == :high
      assert result.dme_ssv == :high
      assert result.channel == 114
    end

    test "handles empty/nil values correctly" do
      sample_data = create_sample_data(%{
        "FAN_MARKER" => "",
        "TACAN_DME_STATUS" => "",
        "TACAN_DME_LAT_DECIMAL" => "",
        "TACAN_DME_LONG_DECIMAL" => "",
        "ALT_CODE" => "",
        "DME_SSV" => "",
        "CHAN" => "",
        "FREQ" => "",
        "MKR_IDENT" => "",
        "MKR_SHAPE" => "",
        "MKR_BRG" => ""
      })

      result = Nav.new(sample_data)

      assert result.fan_marker == ""
      assert result.tacan_dme_status == ""
      assert result.tacan_dme_latitude == nil
      assert result.tacan_dme_longitude == nil
      assert result.alt_code == nil
      assert result.dme_ssv == nil
      assert result.channel == nil
      assert result.frequency == nil
      assert result.marker_ident == ""
      assert result.marker_shape == ""
      assert result.marker_bearing == ""
    end
  end

  describe "type/0" do
    test "returns correct type string" do
      assert Nav.type() == "NAV_BASE"
    end
  end

  # Helper function to create sample data with default values
  defp create_sample_data(overrides) do
    Map.merge(%{
      "EFF_DATE" => "2025/08/07",
      "NAV_ID" => "AA",
      "NAV_TYPE" => "NDB",
      "STATE_CODE" => "ND",
      "CITY" => "FARGO",
      "COUNTRY_CODE" => "US",
      "NAV_STATUS" => "OPERATIONAL IFR",
      "NAME" => "KENIE",
      "STATE_NAME" => "NORTH DAKOTA",
      "REGION_CODE" => "AGL",
      "COUNTRY_NAME" => "UNITED STATES",
      "FAN_MARKER" => "",
      "OWNER" => "F-FEDERAL AVIATION ADMIN",
      "OPERATOR" => "F-FEDERAL AVIATION ADMIN",
      "NAS_USE_FLAG" => "Y",
      "PUBLIC_USE_FLAG" => "Y",
      "NDB_CLASS_CODE" => "HW/LOM",
      "OPER_HOURS" => "24",
      "HIGH_ALT_ARTCC_ID" => "ZMP",
      "HIGH_ARTCC_NAME" => "MINNEAPOLIS",
      "LOW_ALT_ARTCC_ID" => "ZMP",
      "LOW_ARTCC_NAME" => "MINNEAPOLIS",
      "LAT_DEG" => "47",
      "LAT_MIN" => "0",
      "LAT_SEC" => "32.5878",
      "LAT_HEMIS" => "N",
      "LAT_DECIMAL" => "47.00905216",
      "LONG_DEG" => "96",
      "LONG_MIN" => "48",
      "LONG_SEC" => "54.6606",
      "LONG_HEMIS" => "W",
      "LONG_DECIMAL" => "-96.8151835",
      "SURVEY_ACCURACY_CODE" => "6",
      "TACAN_DME_STATUS" => "",
      "TACAN_DME_LAT_DEG" => "",
      "TACAN_DME_LAT_MIN" => "",
      "TACAN_DME_LAT_SEC" => "",
      "TACAN_DME_LAT_HEMIS" => "",
      "TACAN_DME_LAT_DECIMAL" => "",
      "TACAN_DME_LONG_DEG" => "",
      "TACAN_DME_LONG_MIN" => "",
      "TACAN_DME_LONG_SEC" => "",
      "TACAN_DME_LONG_HEMIS" => "",
      "TACAN_DME_LONG_DECIMAL" => "",
      "ELEV" => "890.6",
      "MAG_VARN" => "4",
      "MAG_VARN_HEMIS" => "E",
      "MAG_VARN_YEAR" => "2005",
      "SIMUL_VOICE_FLAG" => "N",
      "PWR_OUTPUT" => "100",
      "AUTO_VOICE_ID_FLAG" => "N",
      "MNT_CAT_CODE" => "1",
      "VOICE_CALL" => "NONE",
      "CHAN" => "",
      "FREQ" => "365",
      "MKR_IDENT" => "",
      "MKR_SHAPE" => "",
      "MKR_BRG" => "",
      "ALT_CODE" => "",
      "DME_SSV" => "",
      "LOW_NAV_ON_HIGH_CHART_FLAG" => "N",
      "Z_MKR_FLAG" => "N",
      "FSS_ID" => "GFK",
      "FSS_NAME" => "GRAND FORKS",
      "FSS_HOURS" => "24",
      "NOTAM_ID" => "FAR",
      "QUAD_IDENT" => "",
      "PITCH_FLAG" => "N",
      "CATCH_FLAG" => "N",
      "SUA_ATCAA_FLAG" => "N",
      "RESTRICTION_FLAG" => "",
      "HIWAS_FLAG" => ""
    }, overrides)
  end
end