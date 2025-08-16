defmodule NASR.Entities.DepartureProcedure.RouteTest do
  use ExUnit.Case
  alias NASR.Entities.DepartureProcedure.Route

  describe "new/1" do
    test "creates Route struct from DP_RTE sample data" do
      sample_data = create_sample_data(%{})

      result = Route.new(sample_data)

      assert result.effective_date == ~D[2025-08-07]
      assert result.departure_procedure_name == "ACCRA"
      assert result.artcc == "ZAU"
      assert result.departure_procedure_computer_code == "ACCRA5.ACCRA"
      assert result.route_portion_type == "BODY"
      assert result.route_name == "FANZI-ACCRA"
      assert result.body_sequence == 1
      assert result.transition_computer_code == ""
      assert result.point_sequence == 10
      assert result.point == "ACCRA"
      assert result.icao_region_code == "K5"
      assert result.point_type == "WP   "
      assert result.next_point == "HHHUL"
      assert result.airport_runway_association == "57C, BUU, ENW, ETB, HXF, MKE/01L, MKE/01R, MKE/07L, MKE/07R, MKE/13, MKE/19L, MKE/19R, MKE/25L, MKE/25R, MKE/31, MWC, RAC, UES"
    end

    test "handles different route portion types" do
      body_route = create_sample_data(%{
        "ROUTE_PORTION_TYPE" => "BODY"
      })

      transition_route = create_sample_data(%{
        "ROUTE_PORTION_TYPE" => "TRANSITION",
        "TRANSITION_COMPUTER_CODE" => "ACCRA5.FANZI"
      })

      body_result = Route.new(body_route)
      transition_result = Route.new(transition_route)

      assert body_result.route_portion_type == "BODY"
      assert transition_result.route_portion_type == "TRANSITION"
      assert transition_result.transition_computer_code == "ACCRA5.FANZI"
    end

    test "handles different point types" do
      waypoint = create_sample_data(%{
        "POINT" => "ACCRA",
        "POINT_TYPE" => "WP   "
      })

      vor_point = create_sample_data(%{
        "POINT" => "ATL",
        "POINT_TYPE" => "VOR"
      })

      ndb_point = create_sample_data(%{
        "POINT" => "GQO",
        "POINT_TYPE" => "NDB"
      })

      wp_result = Route.new(waypoint)
      vor_result = Route.new(vor_point)
      ndb_result = Route.new(ndb_point)

      assert wp_result.point == "ACCRA"
      assert wp_result.point_type == "WP   "
      assert vor_result.point == "ATL"
      assert vor_result.point_type == "VOR"
      assert ndb_result.point == "GQO"
      assert ndb_result.point_type == "NDB"
    end

    test "handles point sequences" do
      point1 = create_sample_data(%{
        "POINT_SEQ" => "10",
        "POINT" => "ACCRA",
        "NEXT_POINT" => "HHHUL"
      })

      point2 = create_sample_data(%{
        "POINT_SEQ" => "20",
        "POINT" => "HHHUL",
        "NEXT_POINT" => "LVENS"
      })

      result1 = Route.new(point1)
      result2 = Route.new(point2)

      assert result1.point_sequence == 10
      assert result1.point == "ACCRA"
      assert result1.next_point == "HHHUL"
      assert result2.point_sequence == 20
      assert result2.point == "HHHUL"
      assert result2.next_point == "LVENS"
    end

    test "handles ICAO region codes" do
      us_point = create_sample_data(%{
        "ICAO_REGION_CODE" => "K5"
      })

      canada_point = create_sample_data(%{
        "ICAO_REGION_CODE" => "C",
        "POINT" => "TORONTO"
      })

      us_result = Route.new(us_point)
      canada_result = Route.new(canada_point)

      assert us_result.icao_region_code == "K5"
      assert canada_result.icao_region_code == "C"
      assert canada_result.point == "TORONTO"
    end

    test "handles complex airport runway associations" do
      complex_assoc = create_sample_data(%{
        "ARPT_RWY_ASSOC" => "ATL/08L, ATL/08R, ATL/09L, ATL/09R, ATL/10, ATL/26L, ATL/26R, ATL/27L, ATL/27R, ATL/28, PDK, FTY"
      })

      simple_assoc = create_sample_data(%{
        "ARPT_RWY_ASSOC" => "BOS/04L, BOS/04R"
      })

      complex_result = Route.new(complex_assoc)
      simple_result = Route.new(simple_assoc)

      assert complex_result.airport_runway_association == "ATL/08L, ATL/08R, ATL/09L, ATL/09R, ATL/10, ATL/26L, ATL/26R, ATL/27L, ATL/27R, ATL/28, PDK, FTY"
      assert simple_result.airport_runway_association == "BOS/04L, BOS/04R"
    end

    test "handles empty/nil values correctly" do
      sample_data = create_sample_data(%{
        "EFF_DATE" => "",
        "BODY_SEQ" => "",
        "POINT_SEQ" => "",
        "TRANSITION_COMPUTER_CODE" => ""
      })

      result = Route.new(sample_data)

      assert result.effective_date == nil
      assert result.body_sequence == nil
      assert result.point_sequence == nil
      assert result.transition_computer_code == ""
    end
  end

  describe "type/0" do
    test "returns correct type string" do
      assert Route.type() == "DP_RTE"
    end
  end

  # Helper function to create sample data with default values
  defp create_sample_data(overrides) do
    Map.merge(%{
      "EFF_DATE" => "2025/08/07",
      "DP_NAME" => "ACCRA",
      "ARTCC" => "ZAU",
      "DP_COMPUTER_CODE" => "ACCRA5.ACCRA",
      "ROUTE_PORTION_TYPE" => "BODY",
      "ROUTE_NAME" => "FANZI-ACCRA",
      "BODY_SEQ" => "1",
      "TRANSITION_COMPUTER_CODE" => "",
      "POINT_SEQ" => "10",
      "POINT" => "ACCRA",
      "ICAO_REGION_CODE" => "K5",
      "POINT_TYPE" => "WP   ",
      "NEXT_POINT" => "HHHUL",
      "ARPT_RWY_ASSOC" => "57C, BUU, ENW, ETB, HXF, MKE/01L, MKE/01R, MKE/07L, MKE/07R, MKE/13, MKE/19L, MKE/19R, MKE/25L, MKE/25R, MKE/31, MWC, RAC, UES"
    }, overrides)
  end
end