defmodule NASR.Entities.MilitaryTrainingRoute.PointTest do
  use ExUnit.Case
  alias NASR.Entities.MilitaryTrainingRoute.Point

  describe "new/1" do
    test "creates Point struct from MTR_PT sample data" do
      sample_data = create_sample_data(%{})

      result = Point.new(sample_data)

      assert result.effective_date == ~D[2025-08-07]
      assert result.route_type_code == :instrument_route
      assert result.route_id == "002"
      assert result.artcc == "ZTL"
      assert result.route_point_sequence == 10
      assert result.route_point_id == "A"
      assert result.next_route_point_id == "B"
      assert result.segment_text == "(1) CROSS AT 60 MSL TO"
      assert result.latitude_degrees == 36
      assert result.latitude_minutes == 4
      assert result.latitude_seconds == 0.0
      assert result.latitude_hemisphere == "N"
      assert result.latitude == 36.06666666
      assert result.longitude_degrees == 84
      assert result.longitude_minutes == 39
      assert result.longitude_seconds == 0.0
      assert result.longitude_hemisphere == "W"
      assert result.longitude == -84.65
      assert result.navaid_id == "VXV"
      assert result.navaid_bearing == 288
      assert result.navaid_distance == 38
    end

    test "handles different route type codes" do
      route_types = [
        {"IR", :instrument_route},
        {"VR", :visual_route}
      ]

      for {input, expected} <- route_types do
        sample_data = create_sample_data(%{"ROUTE_TYPE_CODE" => input})
        result = Point.new(sample_data)
        assert result.route_type_code == expected
      end
    end

    test "handles altitude restrictions in segment text" do
      altitude_data = create_sample_data(%{
        "ROUTE_PT_SEQ" => "20",
        "ROUTE_PT_ID" => "B",
        "NEXT_ROUTE_PT_ID" => "C",
        "SEGMENT_TEXT" => "(1) 05 AGL B 60 MSL TO",
        "LAT_DECIMAL" => "36.5",
        "LONG_DECIMAL" => "-84.33333333"
      })

      result = Point.new(altitude_data)
      assert result.route_point_sequence == 20
      assert result.route_point_id == "B"
      assert result.next_route_point_id == "C"
      assert result.segment_text == "(1) 05 AGL B 60 MSL TO"
      assert result.latitude == 36.5
      assert result.longitude == -84.33333333
    end

    test "handles final point with exit instructions" do
      final_point_data = create_sample_data(%{
        "ROUTE_PT_SEQ" => "80",
        "ROUTE_PT_ID" => "H",
        "NEXT_ROUTE_PT_ID" => "",
        "SEGMENT_TEXT" => "(1) 03 AGL B 90 MSL TO (2) EXIT AT 90 MSL",
        "LAT_DECIMAL" => "35.55",
        "LONG_DECIMAL" => "-83.16666666"
      })

      result = Point.new(final_point_data)
      assert result.route_point_sequence == 80
      assert result.route_point_id == "H"
      assert result.next_route_point_id == ""
      assert result.segment_text == "(1) 03 AGL B 90 MSL TO (2) EXIT AT 90 MSL"
      assert result.latitude == 35.55
      assert result.longitude == -83.16666666
    end

    test "handles alternate exit points" do
      alternate_data = create_sample_data(%{
        "ROUTE_PT_SEQ" => "80",
        "ROUTE_PT_ID" => "H",
        "NEXT_ROUTE_PT_ID" => "E1",
        "SEGMENT_TEXT" => "(1) 20 MSL TO (2) ALTERNATE EXIT FROM E (3) TO R-5306A",
        "LAT_DECIMAL" => "35.68333333",
        "LONG_DECIMAL" => "-76.275",
        "NAV_ID" => "NKT",
        "NAVAID_BEARING" => "41",
        "NAVAID_DIST" => "55"
      })

      result = Point.new(alternate_data)
      assert result.route_point_sequence == 80
      assert result.route_point_id == "H"
      assert result.next_route_point_id == "E1"
      assert result.segment_text == "(1) 20 MSL TO (2) ALTERNATE EXIT FROM E (3) TO R-5306A"
      assert result.latitude == 35.68333333
      assert result.longitude == -76.275
      assert result.navaid_id == "NKT"
      assert result.navaid_bearing == 41
      assert result.navaid_distance == 55
    end

    test "handles precise latitude/longitude coordinates" do
      precise_data = create_sample_data(%{
        "LAT_DEG" => "31",
        "LAT_MIN" => "37",
        "LAT_SEC" => "31.2",
        "LAT_HEMIS" => "N",
        "LAT_DECIMAL" => "31.62533333",
        "LONG_DEG" => "83",
        "LONG_MIN" => "20",
        "LONG_SEC" => "0",
        "LONG_HEMIS" => "W",
        "LONG_DECIMAL" => "-83.33333333"
      })

      result = Point.new(precise_data)
      assert result.latitude_degrees == 31
      assert result.latitude_minutes == 37
      assert result.latitude_seconds == 31.2
      assert result.latitude_hemisphere == "N"
      assert result.latitude == 31.62533333
      assert result.longitude_degrees == 83
      assert result.longitude_minutes == 20
      assert result.longitude_seconds == 0.0
      assert result.longitude_hemisphere == "W"
      assert result.longitude == -83.33333333
    end

    test "handles crossing altitude restrictions" do
      crossing_data = create_sample_data(%{
        "ROUTE_PT_ID" => "A",
        "NEXT_ROUTE_PT_ID" => "B",
        "SEGMENT_TEXT" => "(1) CROSS AT 20 MSL TO",
        "NAV_ID" => "VAD",
        "NAVAID_BEARING" => "353",
        "NAVAID_DIST" => "40"
      })

      result = Point.new(crossing_data)
      assert result.route_point_id == "A"
      assert result.next_route_point_id == "B"
      assert result.segment_text == "(1) CROSS AT 20 MSL TO"
      assert result.navaid_id == "VAD"
      assert result.navaid_bearing == 353
      assert result.navaid_distance == 40
    end

    test "handles multiple ARTCC coordination" do
      multi_artcc_data = create_sample_data(%{
        "ARTCC" => "ZJX ZTL",
        "ROUTE_ID" => "017"
      })

      result = Point.new(multi_artcc_data)
      assert result.artcc == "ZJX ZTL"
      assert result.route_id == "017"
    end

    test "handles Visual Route points" do
      vr_data = create_sample_data(%{
        "ROUTE_TYPE_CODE" => "VR",
        "ROUTE_ID" => "1234",
        "ROUTE_PT_ID" => "START",
        "SEGMENT_TEXT" => "(1) VFR ENTRY POINT"
      })

      result = Point.new(vr_data)
      assert result.route_type_code == :visual_route
      assert result.route_id == "1234"
      assert result.route_point_id == "START"
      assert result.segment_text == "(1) VFR ENTRY POINT"
    end

    test "handles points without NAVAID reference" do
      no_navaid_data = create_sample_data(%{
        "NAV_ID" => "",
        "NAVAID_BEARING" => "",
        "NAVAID_DIST" => ""
      })

      result = Point.new(no_navaid_data)
      assert result.navaid_id == ""
      assert result.navaid_bearing == nil
      assert result.navaid_distance == nil
    end

    test "handles different NAVAID types" do
      vor_data = create_sample_data(%{
        "NAV_ID" => "ILM",
        "NAVAID_BEARING" => "277",
        "NAVAID_DIST" => "20",
        "SEGMENT_TEXT" => "(1) AS ASSIGNED TO"
      })

      result = Point.new(vor_data)
      assert result.navaid_id == "ILM"
      assert result.navaid_bearing == 277
      assert result.navaid_distance == 20
      assert result.segment_text == "(1) AS ASSIGNED TO"
    end

    test "handles Southern hemisphere coordinates" do
      # Note: This is theoretical as MTRs are US-based, but tests the parser
      south_data = create_sample_data(%{
        "LAT_HEMIS" => "S",
        "LAT_DECIMAL" => "-25.5",
        "LONG_HEMIS" => "E",
        "LONG_DECIMAL" => "135.75"
      })

      result = Point.new(south_data)
      assert result.latitude_hemisphere == "S"
      assert result.latitude == -25.5
      assert result.longitude_hemisphere == "E"
      assert result.longitude == 135.75
    end

    test "handles three-digit sequence numbers" do
      high_seq_data = create_sample_data(%{
        "ROUTE_PT_SEQ" => "100",
        "ROUTE_PT_ID" => "FA",
        "SEGMENT_TEXT" => "(1) 15 AGL B 30 MSL TO"
      })

      result = Point.new(high_seq_data)
      assert result.route_point_sequence == 100
      assert result.route_point_id == "FA"
      assert result.segment_text == "(1) 15 AGL B 30 MSL TO"
    end

    test "handles empty/nil values correctly" do
      empty_data = create_sample_data(%{
        "NEXT_ROUTE_PT_ID" => "",
        "NAV_ID" => "",
        "NAVAID_BEARING" => "",
        "NAVAID_DIST" => "",
        "LAT_DEG" => "",
        "LAT_MIN" => "",
        "LAT_SEC" => "",
        "LONG_DEG" => "",
        "LONG_MIN" => "",
        "LONG_SEC" => "",
        "LAT_DECIMAL" => "",
        "LONG_DECIMAL" => "",
        "ROUTE_PT_SEQ" => "",
        "ROUTE_TYPE_CODE" => ""
      })

      result = Point.new(empty_data)

      assert result.next_route_point_id == ""
      assert result.navaid_id == ""
      assert result.navaid_bearing == nil
      assert result.navaid_distance == nil
      assert result.latitude_degrees == nil
      assert result.latitude_minutes == nil
      assert result.latitude_seconds == nil
      assert result.longitude_degrees == nil
      assert result.longitude_minutes == nil
      assert result.longitude_seconds == nil
      assert result.latitude == nil
      assert result.longitude == nil
      assert result.route_point_sequence == nil
      assert result.route_type_code == nil
    end

    test "handles unknown route type codes as strings" do
      unknown_data = create_sample_data(%{
        "ROUTE_TYPE_CODE" => "XR"
      })

      result = Point.new(unknown_data)
      assert result.route_type_code == "XR"
    end
  end

  describe "type/0" do
    test "returns correct type string" do
      assert Point.type() == "MTR_PT"
    end
  end

  # Helper function to create sample data with default values
  defp create_sample_data(overrides) do
    Map.merge(%{
      "EFF_DATE" => "2025/08/07",
      "ROUTE_TYPE_CODE" => "IR",
      "ROUTE_ID" => "002",
      "ARTCC" => "ZTL",
      "ROUTE_PT_SEQ" => "10",
      "ROUTE_PT_ID" => "A",
      "NEXT_ROUTE_PT_ID" => "B",
      "SEGMENT_TEXT" => "(1) CROSS AT 60 MSL TO",
      "LAT_DEG" => "36",
      "LAT_MIN" => "4",
      "LAT_SEC" => "0",
      "LAT_HEMIS" => "N",
      "LAT_DECIMAL" => "36.06666666",
      "LONG_DEG" => "84",
      "LONG_MIN" => "39",
      "LONG_SEC" => "0",
      "LONG_HEMIS" => "W",
      "LONG_DECIMAL" => "-84.65",
      "NAV_ID" => "VXV",
      "NAVAID_BEARING" => "288",
      "NAVAID_DIST" => "38"
    }, overrides)
  end
end