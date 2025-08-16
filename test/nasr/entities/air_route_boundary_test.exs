defmodule NASR.Entities.AirRouteBoundaryTest do
  use ExUnit.Case
  alias NASR.Entities.AirRouteBoundary

  describe "new/1" do
    test "creates AirRouteBoundary struct from ARB_BASE sample data" do
      sample_data = create_sample_data(%{})

      result = AirRouteBoundary.new(sample_data)

      assert result.effective_date == ~D[2025-08-07]
      assert result.location_id == "ZAB"
      assert result.location_name == "ALBUQUERQUE"
      assert result.computer_id == "ZCA"
      assert result.icao_id == "KZAB"
      assert result.location_type == :artcc
      assert result.city == "ALBUQUERQUE"
      assert result.state == "NM"
      assert result.country_code == "US"
      assert result.latitude_degrees == 35
      assert result.latitude_minutes == 10
      assert result.latitude_seconds == 24.15
      assert result.latitude_hemisphere == "N"
      assert result.latitude_decimal == 35.173375
      assert result.longitude_degrees == 106
      assert result.longitude_minutes == 34
      assert result.longitude_seconds == 3.08
      assert result.longitude_hemisphere == "W"
      assert result.longitude_decimal == -106.56752222
      assert result.cross_reference == "FACILITY LOCATED AT ALBUQUERQUE, NM"
    end

    test "handles different ARTCC locations" do
      # Test Boston ARTCC
      boston_data = create_sample_data(%{
        "LOCATION_ID" => "ZBW",
        "LOCATION_NAME" => "BOSTON",
        "COMPUTER_ID" => "ZCB",
        "ICAO_ID" => "KZBW",
        "CITY" => "NASHUA",
        "STATE" => "NH",
        "LAT_DEG" => "42",
        "LAT_MIN" => "44",
        "LAT_SEC" => "10.31",
        "LAT_DECIMAL" => "42.73619722",
        "LONG_DEG" => "71",
        "LONG_MIN" => "28",
        "LONG_SEC" => "50.23",
        "LONG_DECIMAL" => "-71.48061944",
        "CROSS_REF" => "FACILITY LOCATED AT NASHUA, NH"
      })

      result = AirRouteBoundary.new(boston_data)
      assert result.location_id == "ZBW"
      assert result.location_name == "BOSTON"
      assert result.computer_id == "ZCB"
      assert result.icao_id == "KZBW"
      assert result.city == "NASHUA"
      assert result.state == "NH"
      assert result.latitude_degrees == 42
      assert result.latitude_minutes == 44
      assert result.latitude_seconds == 10.31
      assert result.latitude_decimal == 42.73619722
      assert result.longitude_degrees == 71
      assert result.longitude_minutes == 28
      assert result.longitude_seconds == 50.23
      assert result.longitude_decimal == -71.48061944
    end

    test "handles oceanic ARTCCs" do
      oceanic_data = create_sample_data(%{
        "LOCATION_ID" => "ZAK",
        "LOCATION_NAME" => "OAKLAND OCEANIC ARTCC",
        "COMPUTER_ID" => "ZAK",
        "ICAO_ID" => "KZAK",
        "CITY" => "OAKLAND",
        "STATE" => "CA",
        "CROSS_REF" => ""
      })

      result = AirRouteBoundary.new(oceanic_data)
      assert result.location_id == "ZAK"
      assert result.location_name == "OAKLAND OCEANIC ARTCC"
      assert result.city == "OAKLAND"
      assert result.state == "CA"
      assert result.cross_reference == ""
    end

    test "handles international FIRs" do
      fir_data = create_sample_data(%{
        "LOCATION_ID" => "FIMM",
        "LOCATION_NAME" => "MAURITIUS FIR",
        "COMPUTER_ID" => "PLS",
        "ICAO_ID" => "FIMM",
        "CITY" => "MAURITIUS",
        "STATE" => "",
        "COUNTRY_CODE" => "MU",
        "LAT_DEG" => "20",
        "LAT_MIN" => "26",
        "LAT_SEC" => "0",
        "LAT_HEMIS" => "S",
        "LAT_DECIMAL" => "-20.43333333",
        "LONG_DEG" => "57",
        "LONG_MIN" => "41",
        "LONG_SEC" => "0",
        "LONG_HEMIS" => "E",
        "LONG_DECIMAL" => "57.68333333"
      })

      result = AirRouteBoundary.new(fir_data)
      assert result.location_id == "FIMM"
      assert result.location_name == "MAURITIUS FIR"
      assert result.city == "MAURITIUS"
      assert result.state == ""
      assert result.country_code == "MU"
      assert result.latitude_hemisphere == "S"
      assert result.latitude_decimal == -20.43333333
      assert result.longitude_hemisphere == "E"
      assert result.longitude_decimal == 57.68333333
    end

    test "handles location type conversions" do
      test_cases = [
        {"ARTCC", :artcc},
        {"OTHER", "OTHER"},
        {"", nil}
      ]

      for {input, expected} <- test_cases do
        sample_data = create_sample_data(%{"LOCATION_TYPE" => input})
        result = AirRouteBoundary.new(sample_data)
        assert result.location_type == expected
      end
    end

    test "handles coordinate conversions" do
      # Test integer coordinates
      int_coords = create_sample_data(%{
        "LAT_DEG" => "35",
        "LAT_MIN" => "10",
        "LAT_SEC" => "24",
        "LONG_DEG" => "106",
        "LONG_MIN" => "34",
        "LONG_SEC" => "3"
      })

      result = AirRouteBoundary.new(int_coords)
      assert result.latitude_degrees == 35
      assert result.latitude_minutes == 10
      assert result.latitude_seconds == 24.0
      assert result.longitude_degrees == 106
      assert result.longitude_minutes == 34
      assert result.longitude_seconds == 3.0

      # Test float coordinates
      float_coords = create_sample_data(%{
        "LAT_DEG" => "37",
        "LAT_MIN" => "0",
        "LAT_SEC" => "29",
        "LAT_DECIMAL" => "-37.00805555",
        "LONG_DEG" => "174",
        "LONG_MIN" => "47",
        "LONG_SEC" => "30",
        "LONG_DECIMAL" => "174.79166666"
      })

      result = AirRouteBoundary.new(float_coords)
      assert result.latitude_degrees == 37
      assert result.latitude_minutes == 0
      assert result.latitude_seconds == 29.0
      assert result.latitude_decimal == -37.00805555
      assert result.longitude_degrees == 174
      assert result.longitude_minutes == 47
      assert result.longitude_seconds == 30.0
      assert result.longitude_decimal == 174.79166666
    end

    test "handles empty/nil values correctly" do
      sample_data = create_sample_data(%{
        "EFF_DATE" => "",
        "LAT_DEG" => "",
        "LAT_MIN" => "",
        "LAT_SEC" => "",
        "LAT_DECIMAL" => "",
        "LONG_DEG" => "",
        "LONG_MIN" => "",
        "LONG_SEC" => "",
        "LONG_DECIMAL" => "",
        "LOCATION_TYPE" => "",
        "CROSS_REF" => ""
      })

      result = AirRouteBoundary.new(sample_data)

      assert result.effective_date == nil
      assert result.latitude_degrees == nil
      assert result.latitude_minutes == nil
      assert result.latitude_seconds == nil
      assert result.latitude_decimal == nil
      assert result.longitude_degrees == nil
      assert result.longitude_minutes == nil
      assert result.longitude_seconds == nil
      assert result.longitude_decimal == nil
      assert result.location_type == nil
      assert result.cross_reference == ""
    end

    test "handles Anchorage ARTCC with oceanic designation" do
      anchorage_data = create_sample_data(%{
        "LOCATION_ID" => "ZAN",
        "LOCATION_NAME" => "ANCHORAGE",
        "COMPUTER_ID" => "ZAN",
        "ICAO_ID" => "PAZA",
        "CITY" => "ANCHORAGE",
        "STATE" => "AK",
        "LAT_DEG" => "61",
        "LAT_MIN" => "53",
        "LAT_SEC" => "35.11",
        "LAT_DECIMAL" => "61.89308611",
        "LONG_DEG" => "149",
        "LONG_MIN" => "49",
        "LONG_SEC" => "53.04",
        "LONG_DECIMAL" => "-149.8314",
        "CROSS_REF" => "FACILITY LOCATED AT ANCHORAGE, AK"
      })

      result = AirRouteBoundary.new(anchorage_data)
      assert result.location_id == "ZAN"
      assert result.location_name == "ANCHORAGE"
      assert result.city == "ANCHORAGE"
      assert result.state == "AK"
      assert result.latitude_decimal == 61.89308611
      assert result.longitude_decimal == -149.8314
      assert result.cross_reference == "FACILITY LOCATED AT ANCHORAGE, AK"
    end

    test "handles international airspace boundaries" do
      atlantico_data = create_sample_data(%{
        "LOCATION_ID" => "SBAO",
        "LOCATION_NAME" => "ATLANTICO FIR",
        "COMPUTER_ID" => "ASI",
        "ICAO_ID" => "SBAO",
        "CITY" => "ATLANTICO",
        "STATE" => "",
        "COUNTRY_CODE" => "BR",
        "LAT_DEG" => "15",
        "LAT_MIN" => "52",
        "LAT_SEC" => "0",
        "LAT_HEMIS" => "S",
        "LAT_DECIMAL" => "-15.86666666",
        "LONG_DEG" => "47",
        "LONG_MIN" => "55",
        "LONG_SEC" => "0",
        "LONG_HEMIS" => "W",
        "LONG_DECIMAL" => "-47.91666666"
      })

      result = AirRouteBoundary.new(atlantico_data)
      assert result.location_id == "SBAO"
      assert result.location_name == "ATLANTICO FIR"
      assert result.country_code == "BR"
      assert result.latitude_hemisphere == "S"
      assert result.longitude_hemisphere == "W"
      assert result.latitude_decimal == -15.86666666
      assert result.longitude_decimal == -47.91666666
    end
  end

  describe "type/0" do
    test "returns correct type string" do
      assert AirRouteBoundary.type() == "ARB_BASE"
    end
  end

  # Helper function to create sample data with default values
  defp create_sample_data(overrides) do
    Map.merge(%{
      "EFF_DATE" => "2025/08/07",
      "LOCATION_ID" => "ZAB",
      "LOCATION_NAME" => "ALBUQUERQUE",
      "COMPUTER_ID" => "ZCA",
      "ICAO_ID" => "KZAB",
      "LOCATION_TYPE" => "ARTCC",
      "CITY" => "ALBUQUERQUE",
      "STATE" => "NM",
      "COUNTRY_CODE" => "US",
      "LAT_DEG" => "35",
      "LAT_MIN" => "10",
      "LAT_SEC" => "24.15",
      "LAT_HEMIS" => "N",
      "LAT_DECIMAL" => "35.173375",
      "LONG_DEG" => "106",
      "LONG_MIN" => "34",
      "LONG_SEC" => "3.08",
      "LONG_HEMIS" => "W",
      "LONG_DECIMAL" => "-106.56752222",
      "CROSS_REF" => "FACILITY LOCATED AT ALBUQUERQUE, NM"
    }, overrides)
  end
end