defmodule NASR.Entities.STAR.RouteTest do
  use ExUnit.Case
  alias NASR.Entities.STAR.Route

  describe "new/1" do
    test "creates Route struct from STAR_RTE sample data" do
      sample_data = create_sample_data(%{})

      result = Route.new(sample_data)

      assert result.effective_date == ~D[2025-08-07]
      assert result.star_computer_code == "AALAN.BLAID2"
      assert result.artcc == "ZLA"
      assert result.route_portion_type == "BODY"
      assert result.route_name == "AALAN-BLAID"
      assert result.body_sequence == 1
      assert result.transition_computer_code == ""
      assert result.point_sequence == 10
      assert result.point == "BLAID"
      assert result.icao_region_code == "K2"
      assert result.point_type == "RP   "
      assert result.next_point == "AALAN"
      assert result.airport_runway_association == "LAS"
    end

    test "handles different route portion types" do
      body_route = create_sample_data(%{
        "ROUTE_PORTION_TYPE" => "BODY"
      })

      transition_route = create_sample_data(%{
        "ROUTE_PORTION_TYPE" => "TRANSITION",
        "TRANSITION_COMPUTER_CODE" => "BLAID2.AALAN"
      })

      body_result = Route.new(body_route)
      transition_result = Route.new(transition_route)

      assert body_result.route_portion_type == "BODY"
      assert transition_result.route_portion_type == "TRANSITION"
      assert transition_result.transition_computer_code == "BLAID2.AALAN"
    end

    test "handles different point types" do
      reporting_point = create_sample_data(%{
        "POINT" => "BLAID",
        "POINT_TYPE" => "RP   "
      })

      waypoint = create_sample_data(%{
        "POINT" => "AALLE",
        "POINT_TYPE" => "WP   "
      })

      vor_point = create_sample_data(%{
        "POINT" => "LAS",
        "POINT_TYPE" => "VOR"
      })

      rp_result = Route.new(reporting_point)
      wp_result = Route.new(waypoint)
      vor_result = Route.new(vor_point)

      assert rp_result.point == "BLAID"
      assert rp_result.point_type == "RP   "
      assert wp_result.point == "AALLE"
      assert wp_result.point_type == "WP   "
      assert vor_result.point == "LAS"
      assert vor_result.point_type == "VOR"
    end

    test "handles point sequences" do
      point1 = create_sample_data(%{
        "POINT_SEQ" => "10",
        "POINT" => "BLAID",
        "NEXT_POINT" => "AALAN"
      })

      point2 = create_sample_data(%{
        "POINT_SEQ" => "20",
        "POINT" => "AALAN",
        "NEXT_POINT" => ""
      })

      result1 = Route.new(point1)
      result2 = Route.new(point2)

      assert result1.point_sequence == 10
      assert result1.point == "BLAID"
      assert result1.next_point == "AALAN"
      assert result2.point_sequence == 20
      assert result2.point == "AALAN"
      assert result2.next_point == ""
    end

    test "handles ICAO region codes" do
      west_coast = create_sample_data(%{
        "ICAO_REGION_CODE" => "K2"
      })

      east_coast = create_sample_data(%{
        "ICAO_REGION_CODE" => "K1",
        "POINT" => "COATE"
      })

      west_result = Route.new(west_coast)
      east_result = Route.new(east_coast)

      assert west_result.icao_region_code == "K2"
      assert east_result.icao_region_code == "K1"
      assert east_result.point == "COATE"
    end

    test "handles different airport runway associations" do
      single_airport = create_sample_data(%{
        "ARPT_RWY_ASSOC" => "LAS"
      })

      specific_runways = create_sample_data(%{
        "ARPT_RWY_ASSOC" => "DEN/25",
        "STAR_COMPUTER_CODE" => "AALLE.AALLE4"
      })

      multiple_runways = create_sample_data(%{
        "ARPT_RWY_ASSOC" => "ATL/08L, ATL/08R, ATL/09L, ATL/09R, ATL/10"
      })

      single_result = Route.new(single_airport)
      specific_result = Route.new(specific_runways)
      multiple_result = Route.new(multiple_runways)

      assert single_result.airport_runway_association == "LAS"
      assert specific_result.airport_runway_association == "DEN/25"
      assert specific_result.star_computer_code == "AALLE.AALLE4"
      assert multiple_result.airport_runway_association == "ATL/08L, ATL/08R, ATL/09L, ATL/09R, ATL/10"
    end

    test "handles final approach points" do
      final_point = create_sample_data(%{
        "POINT_SEQ" => "20",
        "POINT" => "AALAN",
        "NEXT_POINT" => "",
        "ARPT_RWY_ASSOC" => "LAS"
      })

      result = Route.new(final_point)

      assert result.point_sequence == 20
      assert result.point == "AALAN"
      assert result.next_point == ""
      assert result.airport_runway_association == "LAS"
    end

    test "handles empty/nil values correctly" do
      sample_data = create_sample_data(%{
        "EFF_DATE" => "",
        "BODY_SEQ" => "",
        "POINT_SEQ" => "",
        "TRANSITION_COMPUTER_CODE" => "",
        "NEXT_POINT" => ""
      })

      result = Route.new(sample_data)

      assert result.effective_date == nil
      assert result.body_sequence == nil
      assert result.point_sequence == nil
      assert result.transition_computer_code == ""
      assert result.next_point == ""
    end
  end

  describe "type/0" do
    test "returns correct type string" do
      assert Route.type() == "STAR_RTE"
    end
  end

  # Helper function to create sample data with default values
  defp create_sample_data(overrides) do
    Map.merge(%{
      "EFF_DATE" => "2025/08/07",
      "STAR_COMPUTER_CODE" => "AALAN.BLAID2",
      "ARTCC" => "ZLA",
      "ROUTE_PORTION_TYPE" => "BODY",
      "ROUTE_NAME" => "AALAN-BLAID",
      "BODY_SEQ" => "1",
      "TRANSITION_COMPUTER_CODE" => "",
      "POINT_SEQ" => "10",
      "POINT" => "BLAID",
      "ICAO_REGION_CODE" => "K2",
      "POINT_TYPE" => "RP   ",
      "NEXT_POINT" => "AALAN",
      "ARPT_RWY_ASSOC" => "LAS"
    }, overrides)
  end
end