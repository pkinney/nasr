defmodule NASR.Entities.PreferredRouteDataTest do
  use ExUnit.Case

  describe "new/1" do
    test "creates struct from real-world PFR1 sample data" do
      sample_data = %{
        type: :pfr1,
        record_type_indicator: "PFR1",
        origin_facility_location_identifier: "ABE",
        destination_facility_location_identifier: "ACY",
        type_of_preferred_route_code: "TEC",
        route_identifier_sequence_number_1_99: "1",
        type_of_preferred_route_description: "TOWER ENROUTE CONTROL",
        preferred_route_area_description: "",
        preferred_route_altitude_description: "5000",
        aircraft_allowed_limitations_description: "",
        effective_hours_gmt_description_1: "",
        effective_hours_gmt_description_2: "",
        effective_hours_gmt_description_3: "",
        route_direction_limitations_description: "",
        nar_type_common_non_common: "",
        designator: "",
        destination_city: ""
      }

      result = NASR.Entities.PreferredRouteData.new(sample_data)

      assert result.record_type_indicator == "PFR1"
      assert result.origin_facility_location_identifier == "ABE"
      assert result.destination_facility_location_identifier == "ACY"
      assert result.type_of_preferred_route_code == "TEC"
      assert result.route_identifier_sequence_number == "1"
      assert result.type_of_preferred_route_description == "TOWER ENROUTE CONTROL"
      assert result.preferred_route_altitude_description == "5000"
    end

    test "handles empty fields correctly" do
      sample_data = %{
        type: :pfr1,
        record_type_indicator: "PFR1",
        origin_facility_location_identifier: "DCA",
        destination_facility_location_identifier: "BWI",
        type_of_preferred_route_code: "L",
        route_identifier_sequence_number_1_99: "2",
        type_of_preferred_route_description: "LOW ALTITUDE ROUTE",
        preferred_route_area_description: "",
        preferred_route_altitude_description: "",
        aircraft_allowed_limitations_description: "",
        effective_hours_gmt_description_1: "",
        effective_hours_gmt_description_2: "",
        effective_hours_gmt_description_3: "",
        route_direction_limitations_description: "",
        nar_type_common_non_common: "",
        designator: "",
        destination_city: ""
      }

      result = NASR.Entities.PreferredRouteData.new(sample_data)

      assert result.record_type_indicator == "PFR1"
      assert result.origin_facility_location_identifier == "DCA"
      assert result.destination_facility_location_identifier == "BWI"
      assert result.type_of_preferred_route_code == "L"
      assert result.preferred_route_area_description == ""
      assert result.preferred_route_altitude_description == ""
    end
  end
end