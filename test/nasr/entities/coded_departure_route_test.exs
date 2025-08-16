defmodule NASR.Entities.CodedDepartureRouteTest do
  use ExUnit.Case
  alias NASR.Entities.CodedDepartureRoute

  describe "new/1" do
    test "creates CodedDepartureRoute struct from CDR sample data" do
      sample_data = create_sample_data(%{})

      result = CodedDepartureRoute.new(sample_data)

      assert result.route_code == "ABECLTHV"
      assert result.origin_airport == "KABE"
      assert result.destination_airport == "KCLT"
      assert result.departure_fix == "ETX"
      assert result.route_string == "KABE ETX RAV J64 BURNI TYROO QUARM AIR HVQ LNDIZ PARQR4 KCLT"
      assert result.departure_center == "ZNY"
      assert result.arrival_center == "ZTL"
      assert result.transition_centers == "ZID ZNY ZOB ZTL"
      assert result.coordination_required == false
      assert result.playbook == ""
      assert result.navigation_equipment == 1
      assert result.length == 573
    end

    test "handles coordination required flag conversions" do
      test_cases = [
        {"Y", true},
        {"N", false},
        {"", nil}
      ]

      for {input, expected} <- test_cases do
        sample_data = create_sample_data(%{"CoordReq" => input})
        result = CodedDepartureRoute.new(sample_data)
        assert result.coordination_required == expected
      end
    end

    test "handles playbook references" do
      sample_data = create_sample_data(%{
        "RCode" => "ABQATLER",
        "Orig" => "KABQ",
        "Dest" => "KATL",
        "Play" => "ATL NO CHPPR GLAVN"
      })

      result = CodedDepartureRoute.new(sample_data)
      assert result.route_code == "ABQATLER"
      assert result.origin_airport == "KABQ"
      assert result.destination_airport == "KATL"
      assert result.playbook == "ATL NO CHPPR GLAVN"
    end

    test "handles navigation equipment requirements" do
      test_cases = [
        {"1", 1},
        {"2", 2},
        {"3", 3},
        {"", nil}
      ]

      for {input, expected} <- test_cases do
        sample_data = create_sample_data(%{"NavEqp" => input})
        result = CodedDepartureRoute.new(sample_data)
        assert result.navigation_equipment == expected
      end
    end

    test "handles route lengths" do
      test_cases = [
        {"573", 573},
        {"1366", 1366},
        {"1545", 1545},
        {"", nil}
      ]

      for {input, expected} <- test_cases do
        sample_data = create_sample_data(%{"Length" => input})
        result = CodedDepartureRoute.new(sample_data)
        assert result.length == expected
      end
    end

    test "handles complex route strings" do
      complex_route = create_sample_data(%{
        "RCode" => "ABQBWICE",
        "Route String" => "KABQ CNX J15 CME FST J86 IAH J2 CEW ALLMA TEEEM Q99 OGRAE GOOOB THHMP RAVNN8 KBWI",
        "TCNTRs" => "ZAB ZDC ZFW ZHU ZJX",
        "Play" => "CEW"
      })

      result = CodedDepartureRoute.new(complex_route)
      assert result.route_code == "ABQBWICE"
      assert result.route_string == "KABQ CNX J15 CME FST J86 IAH J2 CEW ALLMA TEEEM Q99 OGRAE GOOOB THHMP RAVNN8 KBWI"
      assert result.transition_centers == "ZAB ZDC ZFW ZHU ZJX"
      assert result.playbook == "CEW"
    end

    test "handles multiple transition centers" do
      sample_data = create_sample_data(%{
        "TCNTRs" => "ZAB ZAU ZDC ZDV ZID ZMP ZNY ZOB"
      })

      result = CodedDepartureRoute.new(sample_data)
      assert result.transition_centers == "ZAB ZAU ZDC ZDV ZID ZMP ZNY ZOB"
    end

    test "handles jet routes with standard naming" do
      jet_route = create_sample_data(%{
        "RCode" => "ABQBWIJ1",
        "DepFix" => "ALS",
        "Route String" => "KABQ ALS J13 FQF J128 HCT J60 JOT J30 APE AIR KEMAN ANTHM5 KBWI",
        "Play" => "JOT 1"
      })

      result = CodedDepartureRoute.new(jet_route)
      assert result.route_code == "ABQBWIJ1"
      assert result.departure_fix == "ALS"
      assert result.route_string == "KABQ ALS J13 FQF J128 HCT J60 JOT J30 APE AIR KEMAN ANTHM5 KBWI"
      assert result.playbook == "JOT 1"
    end

    test "handles empty/nil values correctly" do
      sample_data = create_sample_data(%{
        "CoordReq" => "",
        "Play" => "",
        "NavEqp" => "",
        "Length" => ""
      })

      result = CodedDepartureRoute.new(sample_data)

      assert result.coordination_required == nil
      assert result.playbook == ""
      assert result.navigation_equipment == nil
      assert result.length == nil
    end

    test "handles different center configurations" do
      # Single center transition
      single_center = create_sample_data(%{
        "DCNTR" => "ZAB",
        "ACNTR" => "ZDV",
        "TCNTRs" => "ZAB ZDV"
      })

      result = CodedDepartureRoute.new(single_center)
      assert result.departure_center == "ZAB"
      assert result.arrival_center == "ZDV"
      assert result.transition_centers == "ZAB ZDV"

      # Multiple center transition
      multi_center = create_sample_data(%{
        "DCNTR" => "ZAB",
        "ACNTR" => "ZTL",
        "TCNTRs" => "ZAB ZFW ZHU ZTL"
      })

      result = CodedDepartureRoute.new(multi_center)
      assert result.departure_center == "ZAB"
      assert result.arrival_center == "ZTL"
      assert result.transition_centers == "ZAB ZFW ZHU ZTL"
    end
  end

  describe "type/0" do
    test "returns correct type string" do
      assert CodedDepartureRoute.type() == "CDR"
    end
  end

  # Helper function to create sample data with default values
  defp create_sample_data(overrides) do
    Map.merge(%{
      "RCode" => "ABECLTHV",
      "Orig" => "KABE",
      "Dest" => "KCLT",
      "DepFix" => "ETX",
      "Route String" => "KABE ETX RAV J64 BURNI TYROO QUARM AIR HVQ LNDIZ PARQR4 KCLT",
      "DCNTR" => "ZNY",
      "ACNTR" => "ZTL",
      "TCNTRs" => "ZID ZNY ZOB ZTL",
      "CoordReq" => "N",
      "Play" => "",
      "NavEqp" => "1",
      "Length" => "573"
    }, overrides)
  end
end