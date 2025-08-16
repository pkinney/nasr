defmodule NASR.Entities.AirRouteBoundary.SegmentTest do
  use ExUnit.Case
  alias NASR.Entities.AirRouteBoundary.Segment

  describe "new/1" do
    test "creates Segment struct from ARB_SEG sample data" do
      sample_data = create_sample_data(%{})

      result = Segment.new(sample_data)

      assert result.effective_date == ~D[2025-08-07]
      assert result.record_id == "ZAB*H*53855"
      assert result.location_id == "ZAB"
      assert result.location_name == "ALBUQUERQUE"
      assert result.altitude == :high
      assert result.boundary_type == :artcc
      assert result.point_sequence == 10
      assert result.latitude_degrees == 35
      assert result.latitude_minutes == 46
      assert result.latitude_seconds == 0.0
      assert result.latitude_hemisphere == "N"
      assert result.latitude_decimal == 35.76666666
      assert result.longitude_degrees == 111
      assert result.longitude_minutes == 50
      assert result.longitude_seconds == 30.0
      assert result.longitude_hemisphere == "W"
      assert result.longitude_decimal == -111.84166666
      assert result.boundary_point_description == "/COMMON ZAB-ZDV-ZLA/TO"
      assert result.nas_description_flag == ""
    end

    test "handles altitude designations" do
      test_cases = [
        {"HIGH", :high},
        {"LOW", :low},
        {"OTHER", "OTHER"},
        {"", nil}
      ]

      for {input, expected} <- test_cases do
        sample_data = create_sample_data(%{"ALTITUDE" => input})
        result = Segment.new(sample_data)
        assert result.altitude == expected
      end
    end

    test "handles boundary type conversions" do
      test_cases = [
        {"ARTCC", :artcc},
        {"OTHER", "OTHER"},
        {"", nil}
      ]

      for {input, expected} <- test_cases do
        sample_data = create_sample_data(%{"TYPE" => input})
        result = Segment.new(sample_data)
        assert result.boundary_type == expected
      end
    end

    test "handles different boundary point sequences" do
      # Test sequential boundary points
      sequence_20 = create_sample_data(%{
        "REC_ID" => "ZAB*H*53866",
        "POINT_SEQ" => "20",
        "LAT_DEG" => "35",
        "LAT_MIN" => "42",
        "LAT_SEC" => "0",
        "LAT_DECIMAL" => "35.7",
        "LONG_DEG" => "110",
        "LONG_MIN" => "14",
        "LONG_SEC" => "0",
        "LONG_DECIMAL" => "-110.23333333",
        "BNDRY_PT_DESCRIP" => "/COMMON ZAB-ZDV/ TO"
      })

      result = Segment.new(sequence_20)
      assert result.record_id == "ZAB*H*53866"
      assert result.point_sequence == 20
      assert result.latitude_decimal == 35.7
      assert result.longitude_decimal == -110.23333333
      assert result.boundary_point_description == "/COMMON ZAB-ZDV/ TO"
    end

    test "handles common boundary descriptions" do
      common_boundary = create_sample_data(%{
        "REC_ID" => "ZAB*H*53640",
        "POINT_SEQ" => "70",
        "LAT_DEG" => "37",
        "LAT_MIN" => "30",
        "LAT_SEC" => "0",
        "LAT_DECIMAL" => "37.5",
        "LONG_DEG" => "102",
        "LONG_MIN" => "33",
        "LONG_SEC" => "0",
        "LONG_DECIMAL" => "-102.55",
        "BNDRY_PT_DESCRIP" => "/COMMON ZKC-ZAB-ZDV/TO"
      })

      result = Segment.new(common_boundary)
      assert result.record_id == "ZAB*H*53640"
      assert result.point_sequence == 70
      assert result.boundary_point_description == "/COMMON ZKC-ZAB-ZDV/TO"
    end

    test "handles simple boundary points" do
      simple_boundary = create_sample_data(%{
        "REC_ID" => "ZAB*H*53462",
        "POINT_SEQ" => "40",
        "LAT_DEG" => "36",
        "LAT_MIN" => "12",
        "LAT_SEC" => "0",
        "LAT_DECIMAL" => "36.2",
        "LONG_DEG" => "107",
        "LONG_MIN" => "28",
        "LONG_SEC" => "0",
        "LONG_DECIMAL" => "-107.46666666",
        "BNDRY_PT_DESCRIP" => "TO"
      })

      result = Segment.new(simple_boundary)
      assert result.record_id == "ZAB*H*53462"
      assert result.point_sequence == 40
      assert result.latitude_decimal == 36.2
      assert result.longitude_decimal == -107.46666666
      assert result.boundary_point_description == "TO"
    end

    test "handles coordinate precision" do
      # Test fractional seconds
      precise_coords = create_sample_data(%{
        "LAT_DEG" => "35",
        "LAT_MIN" => "49",
        "LAT_SEC" => "45",
        "LAT_DECIMAL" => "35.82916666",
        "LONG_DEG" => "100",
        "LONG_MIN" => "0",
        "LONG_SEC" => "0",
        "LONG_DECIMAL" => "-100"
      })

      result = Segment.new(precise_coords)
      assert result.latitude_degrees == 35
      assert result.latitude_minutes == 49
      assert result.latitude_seconds == 45.0
      assert result.latitude_decimal == 35.82916666
      assert result.longitude_degrees == 100
      assert result.longitude_minutes == 0
      assert result.longitude_seconds == 0.0
      assert result.longitude_decimal == -100.0
    end

    test "handles different ARTCCs" do
      # Test different ARTCC boundary segment
      other_artcc = create_sample_data(%{
        "LOCATION_ID" => "ZDV",
        "LOCATION_NAME" => "DENVER",
        "REC_ID" => "ZDV*H*12345",
        "ALTITUDE" => "LOW"
      })

      result = Segment.new(other_artcc)
      assert result.location_id == "ZDV"
      assert result.location_name == "DENVER"
      assert result.record_id == "ZDV*H*12345"
      assert result.altitude == :low
    end

    test "handles empty/nil values correctly" do
      sample_data = create_sample_data(%{
        "EFF_DATE" => "",
        "ALTITUDE" => "",
        "TYPE" => "",
        "POINT_SEQ" => "",
        "LAT_DEG" => "",
        "LAT_MIN" => "",
        "LAT_SEC" => "",
        "LAT_DECIMAL" => "",
        "LONG_DEG" => "",
        "LONG_MIN" => "",
        "LONG_SEC" => "",
        "LONG_DECIMAL" => "",
        "NAS_DESCRIP_FLAG" => ""
      })

      result = Segment.new(sample_data)

      assert result.effective_date == nil
      assert result.altitude == nil
      assert result.boundary_type == nil
      assert result.point_sequence == nil
      assert result.latitude_degrees == nil
      assert result.latitude_minutes == nil
      assert result.latitude_seconds == nil
      assert result.latitude_decimal == nil
      assert result.longitude_degrees == nil
      assert result.longitude_minutes == nil
      assert result.longitude_seconds == nil
      assert result.longitude_decimal == nil
      assert result.nas_description_flag == ""
    end

    test "handles complex boundary point descriptions" do
      complex_boundary = create_sample_data(%{
        "REC_ID" => "ZAB*H*53300",
        "POINT_SEQ" => "90",
        "BNDRY_PT_DESCRIP" => "/COMMON ZAB-ZKC-ZFW/ TO"
      })

      result = Segment.new(complex_boundary)
      assert result.record_id == "ZAB*H*53300"
      assert result.point_sequence == 90
      assert result.boundary_point_description == "/COMMON ZAB-ZKC-ZFW/ TO"
    end

    test "handles NAS description flag" do
      sample_data = create_sample_data(%{
        "NAS_DESCRIP_FLAG" => "Y"
      })

      result = Segment.new(sample_data)
      assert result.nas_description_flag == "Y"
    end
  end

  describe "type/0" do
    test "returns correct type string" do
      assert Segment.type() == "ARB_SEG"
    end
  end

  # Helper function to create sample data with default values
  defp create_sample_data(overrides) do
    Map.merge(%{
      "EFF_DATE" => "2025/08/07",
      "REC_ID" => "ZAB*H*53855",
      "LOCATION_ID" => "ZAB",
      "LOCATION_NAME" => "ALBUQUERQUE",
      "ALTITUDE" => "HIGH",
      "TYPE" => "ARTCC",
      "POINT_SEQ" => "10",
      "LAT_DEG" => "35",
      "LAT_MIN" => "46",
      "LAT_SEC" => "0",
      "LAT_HEMIS" => "N",
      "LAT_DECIMAL" => "35.76666666",
      "LONG_DEG" => "111",
      "LONG_MIN" => "50",
      "LONG_SEC" => "30",
      "LONG_HEMIS" => "W",
      "LONG_DECIMAL" => "-111.84166666",
      "BNDRY_PT_DESCRIP" => "/COMMON ZAB-ZDV-ZLA/TO",
      "NAS_DESCRIP_FLAG" => ""
    }, overrides)
  end
end