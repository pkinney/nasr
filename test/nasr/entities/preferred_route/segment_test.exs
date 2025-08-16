defmodule NASR.Entities.PreferredRoute.SegmentTest do
  use ExUnit.Case

  describe "new/1" do
    test "creates struct from preferred route segment data sample" do
      sample_data = create_sample_data(%{})

      result = NASR.Entities.PreferredRoute.Segment.new(sample_data)

      assert result.eff_date == ~D[2025-08-07]
      assert result.origin_id == "ABE"
      assert result.dstn_id == "ACY"
      assert result.pfr_type_code == :tec
      assert result.route_no == 1
      assert result.segment_seq == 5
      assert result.seg_value == "FJC"
      assert result.seg_type == :navaid
      assert result.state_code == "PA"
      assert result.country_code == "US"
      assert result.icao_region_code == nil
      assert result.nav_type == :vortac
      assert result.next_seg == "ARD"
    end

    test "handles route type codes correctly" do
      test_cases = [
        {"TEC", :tec},
        {"NAR", :nar},
        {"PREF", :pref},
        {"HIGH", :high},
        {"LOW", :low},
        {"RNAV", :rnav},
        {"", nil},
        {nil, nil}
      ]

      for {input, expected} <- test_cases do
        sample_data = create_sample_data(%{"PFR_TYPE_CODE" => input})
        result = NASR.Entities.PreferredRoute.Segment.new(sample_data)
        assert result.pfr_type_code == expected
      end
    end

    test "handles segment type codes correctly" do
      test_cases = [
        {"NAVAID", :navaid},
        {"WAYPOINT", :waypoint},
        {"AIRWAY", :airway},
        {"PROCEDURE", :procedure},
        {"FIX", :fix},
        {"AIRPORT", :airport},
        {"", nil},
        {nil, nil}
      ]

      for {input, expected} <- test_cases do
        sample_data = create_sample_data(%{"SEG_TYPE" => input})
        result = NASR.Entities.PreferredRoute.Segment.new(sample_data)
        assert result.seg_type == expected
      end
    end

    test "handles navigation type codes correctly" do
      test_cases = [
        {"VOR", :vor},
        {"VORTAC", :vortac},
        {"VOR/DME", :vor_dme},
        {"NDB", :ndb},
        {"TACAN", :tacan},
        {"DME", :dme},
        {"GPS", :gps},
        {"RNAV", :rnav},
        {"ILS", :ils},
        {"LOC", :loc},
        {"LDA", :lda},
        {"SDF", :sdf},
        {"", nil},
        {nil, nil}
      ]

      for {input, expected} <- test_cases do
        sample_data = create_sample_data(%{"NAV_TYPE" => input})
        result = NASR.Entities.PreferredRoute.Segment.new(sample_data)
        assert result.nav_type == expected
      end
    end

    test "handles numeric fields correctly" do
      sample_data = create_sample_data(%{
        "ROUTE_NO" => "2",
        "SEGMENT_SEQ" => "10"
      })

      result = NASR.Entities.PreferredRoute.Segment.new(sample_data)

      assert result.route_no == 2
      assert result.segment_seq == 10
    end

    test "handles empty and nil string values correctly" do
      sample_data = create_sample_data(%{
        "ICAO_REGION_CODE" => "",
        "NEXT_SEG" => nil
      })

      result = NASR.Entities.PreferredRoute.Segment.new(sample_data)

      assert result.icao_region_code == nil
      assert result.next_seg == nil
    end

    test "parses dates correctly" do
      sample_data = create_sample_data(%{
        "EFF_DATE" => "2024/03/15"
      })

      result = NASR.Entities.PreferredRoute.Segment.new(sample_data)

      assert result.eff_date == ~D[2024-03-15]
    end

    test "handles VOR/DME navaid segment" do
      sample_data = create_sample_data(%{
        "SEG_VALUE" => "ARD",
        "SEG_TYPE" => "NAVAID",
        "NAV_TYPE" => "VOR/DME",
        "STATE_CODE" => "PA",
        "NEXT_SEG" => "CYN"
      })

      result = NASR.Entities.PreferredRoute.Segment.new(sample_data)

      assert result.seg_value == "ARD"
      assert result.seg_type == :navaid
      assert result.nav_type == :vor_dme
      assert result.state_code == "PA"
      assert result.next_seg == "CYN"
    end

    test "handles GPS waypoint segment" do
      sample_data = create_sample_data(%{
        "SEG_VALUE" => "LAAYK",
        "SEG_TYPE" => "WAYPOINT",
        "NAV_TYPE" => "GPS",
        "STATE_CODE" => "NY",
        "NEXT_SEG" => ""
      })

      result = NASR.Entities.PreferredRoute.Segment.new(sample_data)

      assert result.seg_value == "LAAYK"
      assert result.seg_type == :waypoint
      assert result.nav_type == :gps
      assert result.state_code == "NY"
      assert result.next_seg == nil
    end

    test "handles airway segment" do
      sample_data = create_sample_data(%{
        "SEG_VALUE" => "V39",
        "SEG_TYPE" => "AIRWAY",
        "NAV_TYPE" => "",
        "STATE_CODE" => "",
        "NEXT_SEG" => "LRP"
      })

      result = NASR.Entities.PreferredRoute.Segment.new(sample_data)

      assert result.seg_value == "V39"
      assert result.seg_type == :airway
      assert result.nav_type == nil
      assert result.state_code == nil
      assert result.next_seg == "LRP"
    end

    test "handles fix segment" do
      sample_data = create_sample_data(%{
        "SEG_VALUE" => "KITHE",
        "SEG_TYPE" => "FIX",
        "NAV_TYPE" => "RNAV",
        "STATE_CODE" => "MD",
        "NEXT_SEG" => ""
      })

      result = NASR.Entities.PreferredRoute.Segment.new(sample_data)

      assert result.seg_value == "KITHE"
      assert result.seg_type == :fix
      assert result.nav_type == :rnav
      assert result.state_code == "MD"
      assert result.next_seg == nil
    end

    test "handles high sequence numbers" do
      sample_data = create_sample_data(%{
        "SEGMENT_SEQ" => "25"
      })

      result = NASR.Entities.PreferredRoute.Segment.new(sample_data)

      assert result.segment_seq == 25
    end

    test "handles international segments" do
      sample_data = create_sample_data(%{
        "COUNTRY_CODE" => "CA",
        "ICAO_REGION_CODE" => "NAM",
        "STATE_CODE" => "ON"
      })

      result = NASR.Entities.PreferredRoute.Segment.new(sample_data)

      assert result.country_code == "CA"
      assert result.icao_region_code == "NAM"
      assert result.state_code == "ON"
    end
  end

  describe "type/0" do
    test "returns correct CSV filename" do
      assert NASR.Entities.PreferredRoute.Segment.type() == "PFR_SEG"
    end
  end

  # Helper function to create comprehensive sample data with sensible defaults
  defp create_sample_data(overrides) do
    Map.merge(%{
      "EFF_DATE" => "2025/08/07",
      "ORIGIN_ID" => "ABE",
      "DSTN_ID" => "ACY",
      "PFR_TYPE_CODE" => "TEC",
      "ROUTE_NO" => "1",
      "SEGMENT_SEQ" => "5",
      "SEG_VALUE" => "FJC",
      "SEG_TYPE" => "NAVAID",
      "STATE_CODE" => "PA",
      "COUNTRY_CODE" => "US",
      "ICAO_REGION_CODE" => "",
      "NAV_TYPE" => "VORTAC",
      "NEXT_SEG" => "ARD"
    }, overrides)
  end
end