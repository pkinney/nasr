defmodule NASR.Entities.WeatherLocationTest do
  use ExUnit.Case
  alias NASR.Entities.WeatherLocation

  describe "new/1" do
    test "creates WeatherLocation struct from CSV data" do
      raw_data = create_sample_data()

      weather_location = WeatherLocation.new(raw_data)

      assert weather_location.effective_date == ~D[2025-08-07]
      assert weather_location.weather_id == "00U"
      assert weather_location.city == "HARDIN"
      assert weather_location.state_code == "MT"
      assert weather_location.country_code == "US"
      assert weather_location.latitude_degrees == 45
      assert weather_location.latitude_minutes == 44
      assert weather_location.latitude_seconds == 43.15
      assert weather_location.latitude_hemisphere == "N"
      assert weather_location.latitude == 45.74531944
      assert weather_location.longitude_degrees == 107
      assert weather_location.longitude_minutes == 39
      assert weather_location.longitude_seconds == 35.13
      assert weather_location.longitude_hemisphere == "W"
      assert weather_location.longitude == -107.65975833
      assert weather_location.elevation == 3085
      assert weather_location.survey_method_code == :estimated
    end

    test "handles surveyed survey method code" do
      raw_data = create_sample_data_surveyed()

      weather_location = WeatherLocation.new(raw_data)

      assert weather_location.weather_id == "01G"
      assert weather_location.city == "PERRY"
      assert weather_location.state_code == "NY"
      assert weather_location.survey_method_code == :surveyed
      assert weather_location.elevation == 1558
    end

    test "handles high elevation locations" do
      raw_data = create_sample_data_high_elevation()

      weather_location = WeatherLocation.new(raw_data)

      assert weather_location.weather_id == "0CO"
      assert weather_location.city == "EMPIRE"
      assert weather_location.state_code == "CO"
      assert weather_location.elevation == 12493
      assert weather_location.survey_method_code == :surveyed
    end

    test "handles Alaska locations with different coordinates" do
      raw_data = create_sample_data_alaska()

      weather_location = WeatherLocation.new(raw_data)

      assert weather_location.weather_id == "05K"
      assert weather_location.city == "PORT ALSWORTH"
      assert weather_location.state_code == "AK"
      assert weather_location.latitude_degrees == 60
      assert weather_location.latitude_minutes == 11
      assert weather_location.latitude_seconds == 49.8
      assert weather_location.latitude == 60.19716666
      assert weather_location.longitude_degrees == 154
      assert weather_location.longitude_minutes == 19
      assert weather_location.longitude_seconds == 26.9
      assert weather_location.longitude == -154.32413888
      assert weather_location.elevation == 288
      assert weather_location.survey_method_code == :estimated
    end

    test "handles nil and empty values" do
      raw_data = %{
        "EFF_DATE" => "",
        "WEA_ID" => "TEST",
        "CITY" => "",
        "STATE_CODE" => "",
        "COUNTRY_CODE" => "",
        "LAT_DEG" => "",
        "LAT_MIN" => "",
        "LAT_SEC" => "",
        "LAT_HEMIS" => "",
        "LAT_DECIMAL" => "",
        "LONG_DEG" => "",
        "LONG_MIN" => "",
        "LONG_SEC" => "",
        "LONG_HEMIS" => "",
        "LONG_DECIMAL" => "",
        "ELEV" => "",
        "SURVEY_METHOD_CODE" => ""
      }

      weather_location = WeatherLocation.new(raw_data)

      assert weather_location.effective_date == nil
      assert weather_location.weather_id == "TEST"
      assert weather_location.city == ""
      assert weather_location.state_code == ""
      assert weather_location.country_code == ""
      assert weather_location.latitude_degrees == nil
      assert weather_location.latitude_minutes == nil
      assert weather_location.latitude_seconds == nil
      assert weather_location.latitude == nil
      assert weather_location.longitude_degrees == nil
      assert weather_location.longitude_minutes == nil
      assert weather_location.longitude_seconds == nil
      assert weather_location.longitude == nil
      assert weather_location.elevation == nil
      assert weather_location.survey_method_code == nil
    end

    test "preserves unknown survey method codes" do
      raw_data = create_sample_data()
        |> Map.put("SURVEY_METHOD_CODE", "X")

      weather_location = WeatherLocation.new(raw_data)

      assert weather_location.survey_method_code == "X"
    end

    test "handles zero elevation" do
      raw_data = create_sample_data()
        |> Map.put("ELEV", "0")

      weather_location = WeatherLocation.new(raw_data)

      assert weather_location.elevation == 0
    end

    test "handles negative elevation (below sea level)" do
      raw_data = create_sample_data()
        |> Map.put("ELEV", "-100")

      weather_location = WeatherLocation.new(raw_data)

      assert weather_location.elevation == -100
    end

    test "handles decimal coordinates properly" do
      raw_data = create_sample_data_precise_coordinates()

      weather_location = WeatherLocation.new(raw_data)

      assert weather_location.weather_id == "06C"
      assert weather_location.city == "CHICAGO/SCHAUMBURG"
      assert weather_location.state_code == "IL"
      assert weather_location.latitude_degrees == 41
      assert weather_location.latitude_minutes == 59
      assert weather_location.latitude_seconds == 32.4365
      assert weather_location.latitude == 41.99234347
      assert weather_location.longitude_degrees == 88
      assert weather_location.longitude_minutes == 6
      assert weather_location.longitude_seconds == 32.8666
      assert weather_location.longitude == -88.10912961
      assert weather_location.elevation == 800
      assert weather_location.survey_method_code == :estimated
    end
  end

  describe "type/0" do
    test "returns the correct CSV type" do
      assert WeatherLocation.type() == "WXL_BASE"
    end
  end

  # Helper functions for creating test data
  defp create_sample_data do
    %{
      "EFF_DATE" => "2025/08/07",
      "WEA_ID" => "00U",
      "CITY" => "HARDIN",
      "STATE_CODE" => "MT",
      "COUNTRY_CODE" => "US",
      "LAT_DEG" => "45",
      "LAT_MIN" => "44",
      "LAT_SEC" => "43.15",
      "LAT_HEMIS" => "N",
      "LAT_DECIMAL" => "45.74531944",
      "LONG_DEG" => "107",
      "LONG_MIN" => "39",
      "LONG_SEC" => "35.13",
      "LONG_HEMIS" => "W",
      "LONG_DECIMAL" => "-107.65975833",
      "ELEV" => "3085",
      "SURVEY_METHOD_CODE" => "E"
    }
  end

  defp create_sample_data_surveyed do
    %{
      "EFF_DATE" => "2025/08/07",
      "WEA_ID" => "01G",
      "CITY" => "PERRY",
      "STATE_CODE" => "NY",
      "COUNTRY_CODE" => "US",
      "LAT_DEG" => "42",
      "LAT_MIN" => "44",
      "LAT_SEC" => "33.44",
      "LAT_HEMIS" => "N",
      "LAT_DECIMAL" => "42.74262222",
      "LONG_DEG" => "78",
      "LONG_MIN" => "2",
      "LONG_SEC" => "48.86",
      "LONG_HEMIS" => "W",
      "LONG_DECIMAL" => "-78.04690555",
      "ELEV" => "1558",
      "SURVEY_METHOD_CODE" => "S"
    }
  end

  defp create_sample_data_high_elevation do
    %{
      "EFF_DATE" => "2025/08/07",
      "WEA_ID" => "0CO",
      "CITY" => "EMPIRE",
      "STATE_CODE" => "CO",
      "COUNTRY_CODE" => "US",
      "LAT_DEG" => "39",
      "LAT_MIN" => "47",
      "LAT_SEC" => "40",
      "LAT_HEMIS" => "N",
      "LAT_DECIMAL" => "39.79444444",
      "LONG_DEG" => "105",
      "LONG_MIN" => "45",
      "LONG_SEC" => "47",
      "LONG_HEMIS" => "W",
      "LONG_DECIMAL" => "-105.76305555",
      "ELEV" => "12493",
      "SURVEY_METHOD_CODE" => "S"
    }
  end

  defp create_sample_data_alaska do
    %{
      "EFF_DATE" => "2025/08/07",
      "WEA_ID" => "05K",
      "CITY" => "PORT ALSWORTH",
      "STATE_CODE" => "AK",
      "COUNTRY_CODE" => "US",
      "LAT_DEG" => "60",
      "LAT_MIN" => "11",
      "LAT_SEC" => "49.8",
      "LAT_HEMIS" => "N",
      "LAT_DECIMAL" => "60.19716666",
      "LONG_DEG" => "154",
      "LONG_MIN" => "19",
      "LONG_SEC" => "26.9",
      "LONG_HEMIS" => "W",
      "LONG_DECIMAL" => "-154.32413888",
      "ELEV" => "288",
      "SURVEY_METHOD_CODE" => "E"
    }
  end

  defp create_sample_data_precise_coordinates do
    %{
      "EFF_DATE" => "2025/08/07",
      "WEA_ID" => "06C",
      "CITY" => "CHICAGO/SCHAUMBURG",
      "STATE_CODE" => "IL",
      "COUNTRY_CODE" => "US",
      "LAT_DEG" => "41",
      "LAT_MIN" => "59",
      "LAT_SEC" => "32.4365",
      "LAT_HEMIS" => "N",
      "LAT_DECIMAL" => "41.99234347",
      "LONG_DEG" => "88",
      "LONG_MIN" => "6",
      "LONG_SEC" => "32.8666",
      "LONG_HEMIS" => "W",
      "LONG_DECIMAL" => "-88.10912961",
      "ELEV" => "800",
      "SURVEY_METHOD_CODE" => "E"
    }
  end
end