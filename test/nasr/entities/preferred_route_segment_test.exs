defmodule NASR.Entities.PreferredRouteSegmentTest do
  use ExUnit.Case

  describe "new/1" do
    test "creates struct from real-world PFR2 sample data" do
      sample_data = %{
        type: :pfr2,
        navaid_facility_type_described: "VORTAC",
        record_type_indicator: "PFR2",
        blank: "",
        icao_region_code: "",
        origin_facility_location_identifier: "ABE",
        destination_facility_location_identifier: "ACY",
        type_of_preferred_route_code: "TEC",
        route_identifier_sequence_number_1_99: "1",
        segment_sequence_number_within_the_route: "005",
        segment_identifier_navaid_ident_awy_number: "FJC",
        segment_type_described: "NAVAID",
        fix_state_code___post_office_alpha_code: "",
        navaid_facility_type_code: "C",
        radial_and_distance_from_navaid: ""
      }

      result = NASR.Entities.PreferredRouteSegment.new(sample_data)

      assert result.record_type_indicator == "PFR2"
      assert result.origin_facility_location_identifier == "ABE"
      assert result.destination_facility_location_identifier == "ACY"
      assert result.type_of_preferred_route_code == "TEC"
      assert result.route_identifier_sequence_number == "1"
      assert result.segment_sequence_number_within_the_route == "005"
      assert result.segment_identifier_navaid_ident_awy_number == "FJC"
      assert result.segment_type_described == "NAVAID"
      assert result.navaid_facility_type_code == "C"
      assert result.navaid_facility_type_described == "VORTAC"
    end

    test "handles airway segment data" do
      sample_data = %{
        type: :pfr2,
        navaid_facility_type_described: "",
        record_type_indicator: "PFR2",
        blank: "",
        icao_region_code: "",
        origin_facility_location_identifier: "DCA",
        destination_facility_location_identifier: "BWI",
        type_of_preferred_route_code: "H",
        route_identifier_sequence_number_1_99: "3",
        segment_sequence_number_within_the_route: "010",
        segment_identifier_navaid_ident_awy_number: "J42",
        segment_type_described: "AIRWAY",
        fix_state_code___post_office_alpha_code: "",
        navaid_facility_type_code: "",
        radial_and_distance_from_navaid: ""
      }

      result = NASR.Entities.PreferredRouteSegment.new(sample_data)

      assert result.record_type_indicator == "PFR2"
      assert result.segment_identifier_navaid_ident_awy_number == "J42"
      assert result.segment_type_described == "AIRWAY"
      assert result.type_of_preferred_route_code == "H"
      assert result.navaid_facility_type_described == ""
    end
  end
end