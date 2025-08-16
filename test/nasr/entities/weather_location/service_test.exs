defmodule NASR.Entities.WeatherLocation.ServiceTest do
  use ExUnit.Case
  alias NASR.Entities.WeatherLocation.Service

  describe "new/1" do
    test "creates WeatherLocation.Service struct with METAR service" do
      raw_data = create_sample_metar_data()

      service = Service.new(raw_data)

      assert service.effective_date == ~D[2025-08-07]
      assert service.weather_id == "00U"
      assert service.city == "HARDIN"
      assert service.state_code == "MT"
      assert service.country_code == "US"
      assert service.service_type == :metar
      assert service.service_area == ""
    end

    test "creates WeatherLocation.Service struct with SPECI service" do
      raw_data = create_sample_speci_data()

      service = Service.new(raw_data)

      assert service.weather_id == "00U"
      assert service.service_type == :speci
      assert service.service_area == ""
    end

    test "creates WeatherLocation.Service struct with NOTAM service" do
      raw_data = create_sample_notam_data()

      service = Service.new(raw_data)

      assert service.weather_id == "01G"
      assert service.city == "PERRY"
      assert service.state_code == "NY"
      assert service.service_type == :notam
      assert service.service_area == ""
    end

    test "creates WeatherLocation.Service struct with UA (Upper Air) service" do
      raw_data = create_sample_ua_data()

      service = Service.new(raw_data)

      assert service.weather_id == "01M"
      assert service.city == "BELMONT"
      assert service.state_code == "MS"
      assert service.service_type == :ua
      assert service.service_area == ""
    end

    test "creates WeatherLocation.Service struct with SA (Surface Analysis) service" do
      raw_data = create_sample_sa_data()

      service = Service.new(raw_data)

      assert service.weather_id == "04W"
      assert service.city == "HINCKLEY"
      assert service.state_code == "MN"
      assert service.service_type == :sa
      assert service.service_area == ""
    end

    test "handles nil and empty values" do
      raw_data = %{
        "EFF_DATE" => "",
        "WEA_ID" => "TEST",
        "CITY" => "",
        "STATE_CODE" => "",
        "COUNTRY_CODE" => "",
        "WEA_SVC_TYPE_CODE" => "",
        "WEA_AFFECT_AREA" => ""
      }

      service = Service.new(raw_data)

      assert service.effective_date == nil
      assert service.weather_id == "TEST"
      assert service.city == ""
      assert service.state_code == ""
      assert service.country_code == ""
      assert service.service_type == nil
      assert service.service_area == ""
    end

    test "handles service area descriptions" do
      raw_data = create_sample_metar_data()
        |> Map.put("WEA_AFFECT_AREA", "TERMINAL AREA")

      service = Service.new(raw_data)

      assert service.service_area == "TERMINAL AREA"
    end

    test "preserves unknown service types" do
      raw_data = create_sample_metar_data()
        |> Map.put("WEA_SVC_TYPE_CODE", "UNKNOWN_TYPE")

      service = Service.new(raw_data)

      assert service.service_type == "UNKNOWN_TYPE"
    end

    test "handles case-insensitive service types" do
      raw_data = create_sample_metar_data()
        |> Map.put("WEA_SVC_TYPE_CODE", "metar")

      service = Service.new(raw_data)

      assert service.service_type == :metar
    end

    test "handles multiple services for same location" do
      # First service - METAR
      metar_data = create_sample_metar_data()
      metar_service = Service.new(metar_data)

      # Second service - SPECI for same location
      speci_data = create_sample_speci_data()
      speci_service = Service.new(speci_data)

      # Third service - NOTAM for different location
      notam_data = create_sample_notam_data()
      notam_service = Service.new(notam_data)

      assert metar_service.weather_id == speci_service.weather_id
      assert metar_service.service_type == :metar
      assert speci_service.service_type == :speci
      assert notam_service.weather_id != metar_service.weather_id
      assert notam_service.service_type == :notam
    end

    test "handles all standard weather service types" do
      base_data = create_sample_metar_data()

      # Test METAR
      metar_service = Service.new(Map.put(base_data, "WEA_SVC_TYPE_CODE", "METAR"))
      assert metar_service.service_type == :metar

      # Test SPECI
      speci_service = Service.new(Map.put(base_data, "WEA_SVC_TYPE_CODE", "SPECI"))
      assert speci_service.service_type == :speci

      # Test NOTAM
      notam_service = Service.new(Map.put(base_data, "WEA_SVC_TYPE_CODE", "NOTAM"))
      assert notam_service.service_type == :notam

      # Test UA (Upper Air)
      ua_service = Service.new(Map.put(base_data, "WEA_SVC_TYPE_CODE", "UA"))
      assert ua_service.service_type == :ua

      # Test SA (Surface Analysis)
      sa_service = Service.new(Map.put(base_data, "WEA_SVC_TYPE_CODE", "SA"))
      assert sa_service.service_type == :sa

      # Test PIREP
      pirep_service = Service.new(Map.put(base_data, "WEA_SVC_TYPE_CODE", "PIREP"))
      assert pirep_service.service_type == :pirep
    end
  end

  describe "type/0" do
    test "returns the correct CSV type" do
      assert Service.type() == "WXL_SVC"
    end
  end

  # Helper functions for creating test data
  defp create_sample_metar_data do
    %{
      "EFF_DATE" => "2025/08/07",
      "WEA_ID" => "00U",
      "CITY" => "HARDIN",
      "STATE_CODE" => "MT",
      "COUNTRY_CODE" => "US",
      "WEA_SVC_TYPE_CODE" => "METAR",
      "WEA_AFFECT_AREA" => ""
    }
  end

  defp create_sample_speci_data do
    %{
      "EFF_DATE" => "2025/08/07",
      "WEA_ID" => "00U",
      "CITY" => "HARDIN",
      "STATE_CODE" => "MT",
      "COUNTRY_CODE" => "US",
      "WEA_SVC_TYPE_CODE" => "SPECI",
      "WEA_AFFECT_AREA" => ""
    }
  end

  defp create_sample_notam_data do
    %{
      "EFF_DATE" => "2025/08/07",
      "WEA_ID" => "01G",
      "CITY" => "PERRY",
      "STATE_CODE" => "NY",
      "COUNTRY_CODE" => "US",
      "WEA_SVC_TYPE_CODE" => "NOTAM",
      "WEA_AFFECT_AREA" => ""
    }
  end

  defp create_sample_ua_data do
    %{
      "EFF_DATE" => "2025/08/07",
      "WEA_ID" => "01M",
      "CITY" => "BELMONT",
      "STATE_CODE" => "MS",
      "COUNTRY_CODE" => "US",
      "WEA_SVC_TYPE_CODE" => "UA",
      "WEA_AFFECT_AREA" => ""
    }
  end

  defp create_sample_sa_data do
    %{
      "EFF_DATE" => "2025/08/07",
      "WEA_ID" => "04W",
      "CITY" => "HINCKLEY",
      "STATE_CODE" => "MN",
      "COUNTRY_CODE" => "US",
      "WEA_SVC_TYPE_CODE" => "SA",
      "WEA_AFFECT_AREA" => ""
    }
  end
end