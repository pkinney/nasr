defmodule NASR.Entities.MaximumAuthorizedAltitude.ShapeTest do
  use ExUnit.Case
  alias NASR.Entities.MaximumAuthorizedAltitude.Shape

  describe "new/1" do
    test "creates Shape struct from MAA_SHP sample data" do
      sample_data = create_sample_data(%{})

      result = Shape.new(sample_data)

      assert result.effective_date == ~D[2025-08-07]
      assert result.maa_id == "AAL001"
      assert result.point_seq == 1
      assert_in_delta result.latitude, 33.903, 0.01
      assert_in_delta result.longitude, -87.331, 0.01
    end

    test "handles coordinate parsing in DMS format" do
      coordinate_test_cases = [
        {"33-54-12.8500N", "087-19-53.7600W", 33.903, -87.331},
        {"33-54-08.3500N", "087-19-27.2400W", 33.902, -87.324},
        {"33-54-11.2300N", "087-19-20.5600W", 33.903, -87.322},
        {"33-50-21.8100N", "086-13-03.5400W", 33.839, -86.218}
      ]

      for {lat_dms, lon_dms, expected_lat, expected_lon} <- coordinate_test_cases do
        sample_data = create_sample_data(%{
          "LATITUDE" => lat_dms,
          "LONGITUDE" => lon_dms
        })
        result = Shape.new(sample_data)
        assert_in_delta result.latitude, expected_lat, 0.01
        assert_in_delta result.longitude, expected_lon, 0.01
      end
    end

    test "handles sequential boundary points" do
      boundary_points = [
        {1, "33-54-12.8500N", "087-19-53.7600W"},
        {2, "33-54-08.3500N", "087-19-27.2400W"},
        {3, "33-54-11.2300N", "087-19-20.5600W"},
        {4, "33-54-09.3100N", "087-18-19.7200W"},
        {5, "33-54-05.6900N", "087-18-21.1200W"},
        {6, "33-54-06.6500N", "087-19-01.6800W"},
        {7, "33-53-56.4400N", "087-19-01.6800W"},
        {8, "33-53-56.1400N", "087-19-53.3700W"}
      ]

      for {seq, lat, lon} <- boundary_points do
        sample_data = create_sample_data(%{
          "POINT_SEQ" => Integer.to_string(seq),
          "LATITUDE" => lat,
          "LONGITUDE" => lon
        })
        result = Shape.new(sample_data)
        assert result.point_seq == seq
        assert result.latitude != nil
        assert result.longitude != nil
      end
    end

    test "handles different MAA area shapes" do
      maa_shapes = [
        {"AAL001", 8},  # 8-sided irregular shape
        {"AAL002", 4},  # 4-sided shape
      ]

      for {maa_id, _expected_points} <- maa_shapes do
        sample_data = create_sample_data(%{"MAA_ID" => maa_id})
        result = Shape.new(sample_data)
        assert result.maa_id == maa_id
      end
    end

    test "handles North and South latitude coordinates" do
      north_coord = create_sample_data(%{
        "LATITUDE" => "33-54-12.8500N"
      })

      # Test a southern coordinate (hypothetical)
      south_coord = create_sample_data(%{
        "LATITUDE" => "25-45-30.0000S"
      })

      north_result = Shape.new(north_coord)
      south_result = Shape.new(south_coord)

      assert north_result.latitude > 0  # Northern hemisphere
      assert south_result.latitude < 0  # Southern hemisphere
    end

    test "handles East and West longitude coordinates" do
      west_coord = create_sample_data(%{
        "LONGITUDE" => "087-19-53.7600W"
      })

      # Test an eastern coordinate (hypothetical)
      east_coord = create_sample_data(%{
        "LONGITUDE" => "087-19-53.7600E"
      })

      west_result = Shape.new(west_coord)
      east_result = Shape.new(east_coord)

      assert west_result.longitude < 0  # Western hemisphere
      assert east_result.longitude > 0  # Eastern hemisphere
    end

    test "handles precise coordinate parsing" do
      precise_coordinates = [
        {"33-54-12.8500N", 33.903569},
        {"33-54-08.3500N", 33.902319},
        {"33-54-11.2300N", 33.903119},
        {"087-19-53.7600W", -87.331600},
        {"087-19-27.2400W", -87.324233},
        {"087-19-20.5600W", -87.322378}
      ]

      for {coord_str, expected_decimal} <- precise_coordinates do
        sample_data = if String.ends_with?(coord_str, "N") or String.ends_with?(coord_str, "S") do
          create_sample_data(%{"LATITUDE" => coord_str})
        else
          create_sample_data(%{"LONGITUDE" => coord_str})
        end
        
        result = Shape.new(sample_data)
        
        actual_value = if String.ends_with?(coord_str, "N") or String.ends_with?(coord_str, "S") do
          result.latitude
        else
          result.longitude
        end
        
        assert_in_delta actual_value, expected_decimal, 0.01
      end
    end

    test "handles complex irregular shapes" do
      # Test data for AAL001 - an 8-sided irregular shape
      aal001_points = [
        {1, "33-54-12.8500N", "087-19-53.7600W"},
        {2, "33-54-08.3500N", "087-19-27.2400W"},
        {3, "33-54-11.2300N", "087-19-20.5600W"},
        {4, "33-54-09.3100N", "087-18-19.7200W"},
        {5, "33-54-05.6900N", "087-18-21.1200W"},
        {6, "33-54-06.6500N", "087-19-01.6800W"},
        {7, "33-53-56.4400N", "087-19-01.6800W"},
        {8, "33-53-56.1400N", "087-19-53.3700W"}
      ]

      results = Enum.map(aal001_points, fn {seq, lat, lon} ->
        sample_data = create_sample_data(%{
          "MAA_ID" => "AAL001",
          "POINT_SEQ" => Integer.to_string(seq),
          "LATITUDE" => lat,
          "LONGITUDE" => lon
        })
        Shape.new(sample_data)
      end)

      # Verify all points belong to same MAA
      assert Enum.all?(results, fn result -> result.maa_id == "AAL001" end)
      
      # Verify sequential ordering
      sequences = Enum.map(results, & &1.point_seq)
      assert sequences == [1, 2, 3, 4, 5, 6, 7, 8]
      
      # Verify all coordinates are in Alabama/Georgia region
      latitudes = Enum.map(results, & &1.latitude)
      longitudes = Enum.map(results, & &1.longitude)
      
      assert Enum.all?(latitudes, fn lat -> lat > 33.0 and lat < 35.0 end)  # Alabama latitude range
      assert Enum.all?(longitudes, fn lon -> lon > -89.0 and lon < -85.0 end)  # Alabama longitude range
    end

    test "handles different MAA area identifiers" do
      maa_identifiers = [
        "AAL001",  # Alabama area 1
        "AAL002",  # Alabama area 2
        "AAR001",  # Arkansas area 1
        "ACA001"   # California area 1
      ]

      for maa_id <- maa_identifiers do
        sample_data = create_sample_data(%{"MAA_ID" => maa_id})
        result = Shape.new(sample_data)
        assert result.maa_id == maa_id
      end
    end

    test "handles empty/nil values correctly" do
      sample_data = create_sample_data(%{
        "POINT_SEQ" => "",
        "LATITUDE" => "",
        "LONGITUDE" => ""
      })

      result = Shape.new(sample_data)

      assert result.point_seq == nil
      assert result.latitude == nil
      assert result.longitude == nil
    end

    test "handles decimal coordinate format" do
      decimal_data = create_sample_data(%{
        "LATITUDE" => "33.903569",
        "LONGITUDE" => "-87.331600"
      })

      result = Shape.new(decimal_data)
      
      assert_in_delta result.latitude, 33.903569, 0.000001
      assert_in_delta result.longitude, -87.331600, 0.000001
    end

    test "validates coordinate boundary limits" do
      # Test coordinates within valid ranges
      valid_data = create_sample_data(%{
        "LATITUDE" => "33-54-12.8500N",   # Valid US latitude
        "LONGITUDE" => "087-19-53.7600W"  # Valid US longitude
      })

      result = Shape.new(valid_data)
      
      # Verify coordinates are within continental US bounds
      assert result.latitude >= 24.0 and result.latitude <= 49.0  # Continental US latitude range
      assert result.longitude >= -125.0 and result.longitude <= -66.0  # Continental US longitude range
    end

    test "handles coordinate precision for aviation accuracy" do
      # Test high precision coordinates needed for aviation
      high_precision_data = create_sample_data(%{
        "LATITUDE" => "33-54-12.8500N",
        "LONGITUDE" => "087-19-53.7600W"
      })

      result = Shape.new(high_precision_data)
      
      # Verify precision is maintained (within 1 meter accuracy)
      assert_in_delta result.latitude, 33.903569, 0.00001
      assert_in_delta result.longitude, -87.331600, 0.00001
    end
  end

  describe "type/0" do
    test "returns correct type string" do
      assert Shape.type() == "MAA_SHP"
    end
  end

  # Helper function to create sample data with default values
  defp create_sample_data(overrides) do
    Map.merge(%{
      "EFF_DATE" => "2025/08/07",
      "MAA_ID" => "AAL001",
      "POINT_SEQ" => "1",
      "LATITUDE" => "33-54-12.8500N",
      "LONGITUDE" => "087-19-53.7600W"
    }, overrides)
  end
end