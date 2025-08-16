defmodule NASR.Entities.AirwayTest do
  use ExUnit.Case
  alias NASR.Entities.Airway

  describe "new/1" do
    test "creates Airway struct from AWY_BASE sample data" do
      sample_data = create_sample_data(%{})

      result = Airway.new(sample_data)

      assert result.effective_date == ~D[2025-08-07]
      assert result.regulatory == true
      assert result.airway_designation == :jet
      assert result.airway_location == :contiguous_us
      assert result.airway_id == "J1"
      assert result.update_date == ~D[2025-07-01]
      assert result.remark == "JET ROUTE"
      assert result.airway_string == "ATL MACON VOR GAZ VOR ATL"
    end

    test "handles airway designation conversions" do
      test_cases = [
        {"A", :amber},
        {"AT", :atlantic},
        {"B", :blue},
        {"BF", :bahama},
        {"G", :green},
        {"J", :jet},
        {"PA", :pacific},
        {"PR", :puerto_rico},
        {"R", :red},
        {"RN", :gps_rnav},
        {"V", :vor},
        {"UNKNOWN", "UNKNOWN"}
      ]

      for {input, expected} <- test_cases do
        sample_data = create_sample_data(%{"AWY_DESIGNATION" => input})
        result = Airway.new(sample_data)
        assert result.airway_designation == expected
      end
    end

    test "handles airway location conversions" do
      test_cases = [
        {"A", :alaska},
        {"H", :hawaii},
        {"C", :contiguous_us},
        {"OTHER", "OTHER"}
      ]

      for {input, expected} <- test_cases do
        sample_data = create_sample_data(%{"AWY_LOCATION" => input})
        result = Airway.new(sample_data)
        assert result.airway_location == expected
      end
    end

    test "handles regulatory flag conversions" do
      regulatory_yes = create_sample_data(%{"REGULATORY" => "Y"})
      regulatory_no = create_sample_data(%{"REGULATORY" => "N"})

      result_yes = Airway.new(regulatory_yes)
      result_no = Airway.new(regulatory_no)

      assert result_yes.regulatory == true
      assert result_no.regulatory == false
    end

    test "handles empty/nil values correctly" do
      sample_data = create_sample_data(%{
        "EFF_DATE" => "",
        "UPDATE_DATE" => "",
        "AWY_DESIGNATION" => "",
        "AWY_LOCATION" => ""
      })

      result = Airway.new(sample_data)

      assert result.effective_date == nil
      assert result.update_date == nil
      assert result.airway_designation == nil
      assert result.airway_location == nil
    end

    test "handles VOR airways" do
      vor_airway = create_sample_data(%{
        "AWY_DESIGNATION" => "V",
        "AWY_ID" => "V123",
        "AIRWAY_STRING" => "VOR1 VOR2 VOR3"
      })

      result = Airway.new(vor_airway)
      assert result.airway_designation == :vor
      assert result.airway_id == "V123"
      assert result.airway_string == "VOR1 VOR2 VOR3"
    end

    test "handles GPS RNAV airways" do
      rnav_airway = create_sample_data(%{
        "AWY_DESIGNATION" => "RN",
        "AWY_ID" => "T123",
        "AIRWAY_STRING" => "WAYPOINT1 WAYPOINT2 WAYPOINT3"
      })

      result = Airway.new(rnav_airway)
      assert result.airway_designation == :gps_rnav
      assert result.airway_id == "T123"
      assert result.airway_string == "WAYPOINT1 WAYPOINT2 WAYPOINT3"
    end
  end

  describe "type/0" do
    test "returns correct type string" do
      assert Airway.type() == "AWY_BASE"
    end
  end

  # Helper function to create sample data with default values
  defp create_sample_data(overrides) do
    Map.merge(%{
      "EFF_DATE" => "2025/08/07",
      "REGULATORY" => "Y",
      "AWY_DESIGNATION" => "J",
      "AWY_LOCATION" => "C",
      "AWY_ID" => "J1",
      "UPDATE_DATE" => "2025/07/01",
      "REMARK" => "JET ROUTE",
      "AIRWAY_STRING" => "ATL MACON VOR GAZ VOR ATL"
    }, overrides)
  end
end