defmodule NASR.Entities.LocationIdentifierTest do
  use ExUnit.Case

  describe "new/1" do
    test "creates struct from real-world USA sample data" do
      sample_data = %{
        type: :usa,
        blanks: "",
        landing_facility_type: "AIRPORT",
        location_identifier: "A05",
        tie_in_flight_service_station_fss_identifier: "",
        identifier_group_sort_code: "1",
        identifier_group_code: "USA",
        faa_region_associated_with_the_location_identifier: "ANM",
        state_associated_with_the_location_identifier: "ID",
        city_associated_with_the_location_identifier: "DIXIE",
        controlling_artcc_for_this_location: "ZSE",
        controlling_artcc_for_this_location___computer_id: "ZCS",
        landing_facility_name: "DIXIE USFS",
        navaid_facility_name_1: "",
        navaid_facility_type_1: "",
        navaid_facility_name_2: "",
        navaid_facility_type_2: "",
        navaid_facility_name_3: "",
        navaid_facility_type_3: "",
        navaid_facility_name_4: "",
        navaid_facility_type_4: "",
        ils_runway_end_ex_08_18r_36l: "",
        ils_facility_type: "",
        location_identifier_of_ils_airport: "",
        ils_airport_name: "",
        fss_name: "",
        artcc_name: "",
        artcc_facility_type: "",
        flight_watch_station_fltwo_indicator: "",
        other_facility___facility_name_description: "",
        other_facility___facility_type: "",
        effective_date_of_this_information_mm_dd_yyyy: "08/07/2025"
      }

      result = NASR.Entities.LocationIdentifier.new(sample_data)

      assert result.facility_type == "AIRPORT"
      assert result.location_identifier == "A05"
      assert result.fss_identifier == ""
      assert result.identifier_group_sort_code == "1"
      assert result.identifier_group_code == "USA"
      assert result.faa_region == "ANM"
      assert result.state == "ID"
      assert result.city == "DIXIE"
      assert result.controlling_artcc == "ZSE"
      assert result.controlling_artcc_computer_id == "ZCS"
      assert result.facility_name == "DIXIE USFS"
      assert result.navaid_facility_name_1 == ""
      assert result.navaid_facility_type_1 == ""
      assert result.navaid_facility_name_2 == ""
      assert result.navaid_facility_type_2 == ""
      assert result.navaid_facility_name_3 == ""
      assert result.navaid_facility_type_3 == ""
      assert result.navaid_facility_name_4 == ""
      assert result.navaid_facility_type_4 == ""
      assert result.ils_runway_end == ""
      assert result.ils_facility_type == ""
      assert result.ils_airport_identifier == ""
      assert result.ils_airport_name == ""
      assert result.fss_name == ""
      assert result.artcc_name == ""
      assert result.artcc_facility_type == ""
      assert result.flight_watch_indicator == ""
      assert result.other_facility_name == ""
      assert result.other_facility_type == ""
      assert result.effective_date == ~D[2025-08-07]
    end

    test "handles empty effective date" do
      sample_data = %{
        type: :usa,
        landing_facility_type: "AIRPORT",
        location_identifier: "TEST",
        tie_in_flight_service_station_fss_identifier: "",
        identifier_group_sort_code: "1",
        identifier_group_code: "USA",
        faa_region_associated_with_the_location_identifier: "ANM",
        state_associated_with_the_location_identifier: "ID",
        city_associated_with_the_location_identifier: "TEST",
        controlling_artcc_for_this_location: "ZSE",
        controlling_artcc_for_this_location___computer_id: "ZCS",
        landing_facility_name: "TEST FACILITY",
        navaid_facility_name_1: "",
        navaid_facility_type_1: "",
        navaid_facility_name_2: "",
        navaid_facility_type_2: "",
        navaid_facility_name_3: "",
        navaid_facility_type_3: "",
        navaid_facility_name_4: "",
        navaid_facility_type_4: "",
        ils_runway_end_ex_08_18r_36l: "",
        ils_facility_type: "",
        location_identifier_of_ils_airport: "",
        ils_airport_name: "",
        fss_name: "",
        artcc_name: "",
        artcc_facility_type: "",
        flight_watch_station_fltwo_indicator: "",
        other_facility___facility_name_description: "",
        other_facility___facility_type: "",
        effective_date_of_this_information_mm_dd_yyyy: ""
      }

      result = NASR.Entities.LocationIdentifier.new(sample_data)

      assert result.effective_date == nil
    end
  end
end