defmodule NASR.Entities.ParachuteJumpAreaDataTest do
  use ExUnit.Case

  describe "new/1" do
    test "creates struct from real-world PJA1 sample data" do
      sample_data = %{
        type: :pja1,
        record_type_indicator: "PJA1",
        navaid_facility_type_described: "VOR/DME",
        pja_id: "PAK005",
        navaid_identifier_ex_scy: "TED",
        navaid_facility_type_code_ex_c: "D",
        azimuth_degrees_from_navaid_000_0_359_99: "034.44",
        distance_in_nautical_miles_from_navaid: "14.4",
        navaid_name: "ANCHORAGE",
        pja_state_abbreviation_two_letter_post_office: "AK",
        pja_state_name: "ALASKA",
        pja_associated_city_name: "ANCHORAGE",
        pja_latitude_formatted: "61-18-47.4645N",
        pja_latitude_seconds: "220727.4645N",
        pja_longitude_formatted: "149-33-55.9086W",
        pja_longitude_seconds: "538435.9086W",
        associated_airport_name: "",
        associated_airport_site_number: "",
        pja_drop_zone_name: "",
        pja_maximum_altitude_allowed: "12500MSL",
        pja_area_radius_in_nautical_miles_from: "",
        sectional_charting_required_yes_no: "NO",
        area_to_be_published_in_airport_facility: "YES",
        additional_descriptive_text_for_area: "",
        associated_fss_ident: "ENA",
        associated_fss_name: "KENAI",
        pja_use: "",
        volume: ""
      }

      result = NASR.Entities.ParachuteJumpAreaData.new(sample_data)

      assert result.record_type_indicator == "PJA1"
      assert result.pja_id == "PAK005"
      assert result.navaid_identifier == "TED"
      assert result.navaid_facility_type == "D"
      assert result.navaid_facility_type_described == "VOR/DME"
      assert result.azimuth_from_navaid == 34.44
      assert result.distance_from_navaid == 14.4
      assert result.navaid_name == "ANCHORAGE"
      assert result.state == "AK"
      assert result.state_name == "ALASKA"
      assert result.city == "ANCHORAGE"
      assert_in_delta result.latitude, 61.313_184_58, 0.000_001
      assert_in_delta result.longitude, -149.565_529_61, 0.000_001
      assert result.max_altitude == "12500MSL"
      assert result.sectional_charting_required == false
      assert result.published_in_airport_facility_directory == true
      assert result.fss_ident == "ENA"
      assert result.fss_name == "KENAI"
    end

    test "handles boolean conversions correctly" do
      sample_data = %{
        type: :pja1,
        record_type_indicator: "PJA1",
        navaid_facility_type_described: "",
        pja_id: "TEST01",
        navaid_identifier_ex_scy: "SCY",
        navaid_facility_type_code_ex_c: "C",
        azimuth_degrees_from_navaid_000_0_359_99: "180.0",
        distance_in_nautical_miles_from_navaid: "5.0",
        navaid_name: "TEST NAVAID",
        pja_state_abbreviation_two_letter_post_office: "CA",
        pja_state_name: "CALIFORNIA",
        pja_associated_city_name: "TEST CITY",
        pja_latitude_formatted: "34-30-00.0000N",
        pja_latitude_seconds: "124200.0000N",
        pja_longitude_formatted: "118-30-00.0000W",
        pja_longitude_seconds: "426600.0000W",
        associated_airport_name: "TEST AIRPORT",
        associated_airport_site_number: "123456.*A",
        pja_drop_zone_name: "TEST DROP ZONE",
        pja_maximum_altitude_allowed: "10000AGL",
        pja_area_radius_in_nautical_miles_from: "2.0",
        sectional_charting_required_yes_no: "YES",
        area_to_be_published_in_airport_facility: "NO",
        additional_descriptive_text_for_area: "Test area description",
        associated_fss_ident: "LAX",
        associated_fss_name: "LOS ANGELES",
        pja_use: "STUDENT TRAINING",
        volume: "HIGH"
      }

      result = NASR.Entities.ParachuteJumpAreaData.new(sample_data)

      assert result.pja_id == "TEST01"
      assert result.sectional_charting_required == true
      assert result.published_in_airport_facility_directory == false
      assert result.airport_name == "TEST AIRPORT"
      assert result.drop_zone_name == "TEST DROP ZONE"
      assert result.description == "Test area description"
      assert result.use == "STUDENT TRAINING"
      assert result.volume == "HIGH"
    end
  end
end