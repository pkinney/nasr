defmodule NASR.Entities.Airway.SegmentAltitudeTest do
  use ExUnit.Case
  alias NASR.Entities.Airway.SegmentAltitude

  describe "new/1" do
    test "creates SegmentAltitude struct from AWY_SEG_ALT sample data" do
      sample_data = create_sample_data(%{})

      result = SegmentAltitude.new(sample_data)

      assert result.effective_date == ~D[2025-08-07]
      assert result.regulatory == false
      assert result.airway_location == :contiguous_us
      assert result.airway_id == "A216"
      assert result.point_sequence == 10
      assert result.from_point == "MONPI"
      assert result.from_point_type == "WP   "
      assert result.nav_name == ""
      assert result.nav_city == ""
      assert result.artcc == "ZAK"
      assert result.icao_region_code == "P"
      assert result.state_code == "OP"
      assert result.country_code == "US"
      assert result.to_point == "OATSS"
      assert result.magnetic_course == 163.32
      assert result.opposite_magnetic_course == 342.18
      assert result.magnetic_course_distance == 269.2
      assert result.changeover_point == ""
      assert result.changeover_point_name == ""
      assert result.changeover_point_distance == nil
      assert result.airway_segment_gap_flag == false
      assert result.signal_gap_flag == false
      assert result.dogleg == false
      assert result.next_mea_point == "OATSS"
      assert result.minimum_enroute_altitude == 18000
      assert result.minimum_enroute_altitude_direction == ""
      assert result.minimum_enroute_altitude_opposite == nil
      assert result.minimum_enroute_altitude_opposite_direction == ""
      assert result.gps_minimum_enroute_altitude == nil
      assert result.gps_minimum_enroute_altitude_direction == ""
      assert result.gps_minimum_enroute_altitude_opposite == nil
      assert result.gps_mea_opposite_direction == ""
      assert result.dd_iru_mea == nil
      assert result.dd_iru_mea_direction == ""
      assert result.dd_i_mea_opposite == nil
      assert result.dd_i_mea_opposite_direction == ""
      assert result.minimum_obstruction_clearance_altitude == nil
      assert result.minimum_crossing_altitude == nil
      assert result.minimum_crossing_altitude_direction == ""
      assert result.minimum_crossing_altitude_nav_point == ""
      assert result.minimum_crossing_altitude_opposite == nil
      assert result.minimum_crossing_altitude_opposite_direction == ""
      assert result.minimum_reception_altitude == nil
      assert result.maximum_authorized_altitude == 60000
      assert result.mea_gap == ""
      assert result.required_navigation_performance == ""
      assert result.remark == ""
    end

    test "handles airway location conversions" do
      test_cases = [
        {"A", :alaska},
        {"H", :hawaii},
        {"C", :contiguous_us},
        {"OTHER", "OTHER"}
      ]

      for {input, expected} <- test_cases do
        sample_data = create_sample_data(%{"AWY_LOCATION" => input})
        result = SegmentAltitude.new(sample_data)
        assert result.airway_location == expected
      end
    end

    test "handles boolean flag conversions" do
      test_data = create_sample_data(%{
        "REGULATORY" => "Y",
        "AWY_SEG_GAP_FLAG" => "Y",
        "SIGNAL_GAP_FLAG" => "Y",
        "DOGLEG" => "Y"
      })

      result = SegmentAltitude.new(test_data)

      assert result.regulatory == true
      assert result.airway_segment_gap_flag == true
      assert result.signal_gap_flag == true
      assert result.dogleg == true
    end

    test "handles numeric conversions" do
      test_data = create_sample_data(%{
        "POINT_SEQ" => "25",
        "MAG_COURSE" => "180.5",
        "OPP_MAG_COURSE" => "0.5",
        "MAG_COURSE_DIST" => "45.75",
        "MIN_ENROUTE_ALT" => "8000",
        "GPS_MIN_ENROUTE_ALT" => "9000",
        "MAX_AUTH_ALT" => "45000"
      })

      result = SegmentAltitude.new(test_data)

      assert result.point_sequence == 25
      assert result.magnetic_course == 180.5
      assert result.opposite_magnetic_course == 0.5
      assert result.magnetic_course_distance == 45.75
      assert result.minimum_enroute_altitude == 8000
      assert result.gps_minimum_enroute_altitude == 9000
      assert result.maximum_authorized_altitude == 45000
    end

    test "handles empty/nil numeric values correctly" do
      sample_data = create_sample_data(%{
        "POINT_SEQ" => "",
        "MAG_COURSE" => "",
        "MIN_ENROUTE_ALT" => "",
        "MAX_AUTH_ALT" => ""
      })

      result = SegmentAltitude.new(sample_data)

      assert result.point_sequence == nil
      assert result.magnetic_course == nil
      assert result.minimum_enroute_altitude == nil
      assert result.maximum_authorized_altitude == nil
    end

    test "handles changeover point information" do
      test_data = create_sample_data(%{
        "CHGOVR_PT" => "WAYPOINT",
        "CHGOVR_PT_NAME" => "Changeover Point",
        "CHGOVR_PT_DIST" => "15.5"
      })

      result = SegmentAltitude.new(test_data)

      assert result.changeover_point == "WAYPOINT"
      assert result.changeover_point_name == "Changeover Point"
      assert result.changeover_point_distance == 15.5
    end

    test "handles all altitude types" do
      test_data = create_sample_data(%{
        "MIN_ENROUTE_ALT" => "8000",
        "MIN_ENROUTE_ALT_OPPOSITE" => "9000",
        "GPS_MIN_ENROUTE_ALT" => "8500",
        "GPS_MIN_ENROUTE_ALT_OPPOSITE" => "9500",
        "DD_IRU_MEA" => "10000",
        "DD_I_MEA_OPPOSITE" => "11000",
        "MIN_OBSTN_CLNC_ALT" => "7000",
        "MIN_CROSS_ALT" => "12000",
        "MIN_CROSS_ALT_OPPOSITE" => "13000",
        "MIN_RECEP_ALT" => "6000",
        "MAX_AUTH_ALT" => "60000"
      })

      result = SegmentAltitude.new(test_data)

      assert result.minimum_enroute_altitude == 8000
      assert result.minimum_enroute_altitude_opposite == 9000
      assert result.gps_minimum_enroute_altitude == 8500
      assert result.gps_minimum_enroute_altitude_opposite == 9500
      assert result.dd_iru_mea == 10000
      assert result.dd_i_mea_opposite == 11000
      assert result.minimum_obstruction_clearance_altitude == 7000
      assert result.minimum_crossing_altitude == 12000
      assert result.minimum_crossing_altitude_opposite == 13000
      assert result.minimum_reception_altitude == 6000
      assert result.maximum_authorized_altitude == 60000
    end

    test "handles navigation information" do
      test_data = create_sample_data(%{
        "FROM_POINT" => "ATL",
        "FROM_PT_TYPE" => "VOR",
        "NAV_NAME" => "ATLANTA",
        "NAV_CITY" => "ATLANTA",
        "TO_POINT" => "MCN"
      })

      result = SegmentAltitude.new(test_data)

      assert result.from_point == "ATL"
      assert result.from_point_type == "VOR"
      assert result.nav_name == "ATLANTA"
      assert result.nav_city == "ATLANTA"
      assert result.to_point == "MCN"
    end
  end

  describe "type/0" do
    test "returns correct type string" do
      assert SegmentAltitude.type() == "AWY_SEG_ALT"
    end
  end

  # Helper function to create sample data with default values
  defp create_sample_data(overrides) do
    Map.merge(%{
      "EFF_DATE" => "2025/08/07",
      "REGULATORY" => "N",
      "AWY_LOCATION" => "C",
      "AWY_ID" => "A216",
      "POINT_SEQ" => "10",
      "FROM_POINT" => "MONPI",
      "FROM_PT_TYPE" => "WP   ",
      "NAV_NAME" => "",
      "NAV_CITY" => "",
      "ARTCC" => "ZAK",
      "ICAO_REGION_CODE" => "P",
      "STATE_CODE" => "OP",
      "COUNTRY_CODE" => "US",
      "TO_POINT" => "OATSS",
      "MAG_COURSE" => "163.32",
      "OPP_MAG_COURSE" => "342.18",
      "MAG_COURSE_DIST" => "269.2",
      "CHGOVR_PT" => "",
      "CHGOVR_PT_NAME" => "",
      "CHGOVR_PT_DIST" => "",
      "AWY_SEG_GAP_FLAG" => "N",
      "SIGNAL_GAP_FLAG" => "N",
      "DOGLEG" => "N",
      "NEXT_MEA_PT" => "OATSS",
      "MIN_ENROUTE_ALT" => "18000",
      "MIN_ENROUTE_ALT_DIR" => "",
      "MIN_ENROUTE_ALT_OPPOSITE" => "",
      "MIN_ENROUTE_ALT_OPPOSITE_DIR" => "",
      "GPS_MIN_ENROUTE_ALT" => "",
      "GPS_MIN_ENROUTE_ALT_DIR" => "",
      "GPS_MIN_ENROUTE_ALT_OPPOSITE" => "",
      "GPS_MEA_OPPOSITE_DIR" => "",
      "DD_IRU_MEA" => "",
      "DD_IRU_MEA_DIR" => "",
      "DD_I_MEA_OPPOSITE" => "",
      "DD_I_MEA_OPPOSITE_DIR" => "",
      "MIN_OBSTN_CLNC_ALT" => "",
      "MIN_CROSS_ALT" => "",
      "MIN_CROSS_ALT_DIR" => "",
      "MIN_CROSS_ALT_NAV_PT" => "",
      "MIN_CROSS_ALT_OPPOSITE" => "",
      "MIN_CROSS_ALT_OPPOSITE_DIR" => "",
      "MIN_RECEP_ALT" => "",
      "MAX_AUTH_ALT" => "60000",
      "MEA_GAP" => "",
      "REQD_NAV_PERFORMANCE" => "",
      "REMARK" => ""
    }, overrides)
  end
end