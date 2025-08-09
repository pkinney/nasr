defmodule NASR.Entities.ILSLocalizerDataTest do
  use ExUnit.Case

  describe "new/1" do
    test "creates struct from real-world ILS2 sample data" do
      sample_data = %{
        type: :ils2,
        record_type_indicator: "ILS2",
        blank: "",
        airport_site_number_identifier_ex_04508_a: "00128.*A",
        ils_runway_end_identifier_ex_18_36l: "05",
        ils_system_type_see_ils1_record_type_for_list: "ILS",
        status_of_localizer_operational_ifr: "OPERATIONAL RESTRICTED",
        date_of_localizer_operational_status: "07/18/2017",
        latitude_of_localizer_antenna_formatted: "33-35-47.260N",
        latitude_of_localizer_antenna_all_seconds: "120947.260N",
        longitude_of_localizer_antenna_formatted: "085-50-48.960W",
        longitude_of_localizer_antenna_all_seconds: "309048.960W",
        indicating_source_of_latitude_longitude: "K",
        distance_of_localizer_antenna: "",
        of_localizer_antenna_from_runway: "",
        indicating_source_of_distance: "",
        elevation_of_localizer_antenna: "612.1",
        localizer_frequency_mhz_ex_108_10: "111.50",
        back_course_status_restricted: "",
        localizer_course_width_degrees_and_hundredths: "",
        course_width_at_threshold: "",
        localizer_distance_from_stop_end_of_rwy_feet: "",
        direction_from_stop_end_of_rwy: "",
        services_code: "NV"
      }

      result = NASR.Entities.ILSLocalizerData.new(sample_data)

      assert result.record_type_indicator == "ILS2"
      assert result.airport_site_number == "00128.*A"
      assert result.ils_runway_end_identifier == "05"
      assert result.ils_system_type == :ils
      assert result.operational_status == :operational_restricted
      assert result.operational_status_date == ~D[2017-07-18]
      assert result.latitude_formatted == "33-35-47.260N"
      assert result.latitude_seconds == "120947.260N"
      assert result.longitude_formatted == "085-50-48.960W"
      assert result.longitude_seconds == "309048.960W"
      assert result.position_source == :ngs
      assert result.site_elevation == 612.1
      assert result.localizer_frequency == 111.50
      assert result.services_code == :no_voice
    end

    test "converts operational status to atoms" do
      test_cases = [
        {"OPERATIONAL IFR", :operational_ifr},
        {"OPERATIONAL VFR ONLY", :operational_vfr_only},
        {"OPERATIONAL RESTRICTED", :operational_restricted},
        {"DECOMMISSIONED", :decommissioned},
        {"SHUTDOWN", :shutdown}
      ]

      for {input, expected} <- test_cases do
        sample_data = %{
          type: :ils2,
          record_type_indicator: "ILS2",
          blank: "",
          airport_site_number_identifier_ex_04508_a: "00128.*A",
          ils_runway_end_identifier_ex_18_36l: "05",
          ils_system_type_see_ils1_record_type_for_list: "ILS",
          status_of_localizer_operational_ifr: input,
          date_of_localizer_operational_status: "07/18/2017",
          latitude_of_localizer_antenna_formatted: "33-35-47.260N",
          latitude_of_localizer_antenna_all_seconds: "120947.260N",
          longitude_of_localizer_antenna_formatted: "085-50-48.960W",
          longitude_of_localizer_antenna_all_seconds: "309048.960W",
          indicating_source_of_latitude_longitude: "K",
          distance_of_localizer_antenna: "",
          of_localizer_antenna_from_runway: "",
          indicating_source_of_distance: "",
          elevation_of_localizer_antenna: "612.1",
          localizer_frequency_mhz_ex_108_10: "111.50",
          back_course_status_restricted: "",
          localizer_course_width_degrees_and_hundredths: "",
          course_width_at_threshold: "",
          localizer_distance_from_stop_end_of_rwy_feet: "",
          direction_from_stop_end_of_rwy: "",
          services_code: "NV"
        }

        result = NASR.Entities.ILSLocalizerData.new(sample_data)
        assert result.operational_status == expected
      end
    end

    test "converts source codes to atoms" do
      test_cases = [
        {"A", :air_force},
        {"C", :coast_guard},
        {"F", :faa},
        {"K", :ngs},
        {"M", :dod},
        {"N", :navy},
        {"O", :owner}
      ]

      for {input, expected} <- test_cases do
        sample_data = %{
          type: :ils2,
          record_type_indicator: "ILS2",
          blank: "",
          airport_site_number_identifier_ex_04508_a: "00128.*A",
          ils_runway_end_identifier_ex_18_36l: "05",
          ils_system_type_see_ils1_record_type_for_list: "ILS",
          status_of_localizer_operational_ifr: "OPERATIONAL IFR",
          date_of_localizer_operational_status: "07/18/2017",
          latitude_of_localizer_antenna_formatted: "33-35-47.260N",
          latitude_of_localizer_antenna_all_seconds: "120947.260N",
          longitude_of_localizer_antenna_formatted: "085-50-48.960W",
          longitude_of_localizer_antenna_all_seconds: "309048.960W",
          indicating_source_of_latitude_longitude: input,
          distance_of_localizer_antenna: "",
          of_localizer_antenna_from_runway: "",
          indicating_source_of_distance: "",
          elevation_of_localizer_antenna: "612.1",
          localizer_frequency_mhz_ex_108_10: "111.50",
          back_course_status_restricted: "",
          localizer_course_width_degrees_and_hundredths: "",
          course_width_at_threshold: "",
          localizer_distance_from_stop_end_of_rwy_feet: "",
          direction_from_stop_end_of_rwy: "",
          services_code: "NV"
        }

        result = NASR.Entities.ILSLocalizerData.new(sample_data)
        assert result.position_source == expected
      end
    end

    test "converts services codes to atoms" do
      test_cases = [
        {"AP", :approach_control},
        {"AT", :atis},
        {"NV", :no_voice}
      ]

      for {input, expected} <- test_cases do
        sample_data = %{
          type: :ils2,
          record_type_indicator: "ILS2",
          blank: "",
          airport_site_number_identifier_ex_04508_a: "00128.*A",
          ils_runway_end_identifier_ex_18_36l: "05",
          ils_system_type_see_ils1_record_type_for_list: "ILS",
          status_of_localizer_operational_ifr: "OPERATIONAL IFR",
          date_of_localizer_operational_status: "07/18/2017",
          latitude_of_localizer_antenna_formatted: "33-35-47.260N",
          latitude_of_localizer_antenna_all_seconds: "120947.260N",
          longitude_of_localizer_antenna_formatted: "085-50-48.960W",
          longitude_of_localizer_antenna_all_seconds: "309048.960W",
          indicating_source_of_latitude_longitude: "K",
          distance_of_localizer_antenna: "",
          of_localizer_antenna_from_runway: "",
          indicating_source_of_distance: "",
          elevation_of_localizer_antenna: "612.1",
          localizer_frequency_mhz_ex_108_10: "111.50",
          back_course_status_restricted: "",
          localizer_course_width_degrees_and_hundredths: "",
          course_width_at_threshold: "",
          localizer_distance_from_stop_end_of_rwy_feet: "",
          direction_from_stop_end_of_rwy: "",
          services_code: input
        }

        result = NASR.Entities.ILSLocalizerData.new(sample_data)
        assert result.services_code == expected
      end
    end
  end
end