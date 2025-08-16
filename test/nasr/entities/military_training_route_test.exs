defmodule NASR.Entities.MilitaryTrainingRouteTest do
  use ExUnit.Case
  alias NASR.Entities.MilitaryTrainingRoute

  describe "new/1" do
    test "creates MilitaryTrainingRoute struct from MTR_BASE sample data" do
      sample_data = create_sample_data(%{})

      result = MilitaryTrainingRoute.new(sample_data)

      assert result.effective_date == ~D[2025-08-07]
      assert result.route_type_code == :instrument_route
      assert result.route_id == "002"
      assert result.artcc == "ZTL"
      assert result.fss == ""
      assert result.time_of_use == "CONTINUOUS"
    end

    test "handles different route type codes" do
      route_types = [
        {"IR", :instrument_route},
        {"VR", :visual_route}
      ]

      for {input, expected} <- route_types do
        sample_data = create_sample_data(%{"ROUTE_TYPE_CODE" => input})
        result = MilitaryTrainingRoute.new(sample_data)
        assert result.route_type_code == expected
      end
    end

    test "handles Visual Route (VR)" do
      vr_data = create_sample_data(%{
        "ROUTE_TYPE_CODE" => "VR",
        "ROUTE_ID" => "1234",
        "ARTCC" => "ZDC",
        "FSS" => "DCA",
        "TIME_OF_USE" => "DAYLIGHT HOURS ONLY"
      })

      result = MilitaryTrainingRoute.new(vr_data)
      assert result.route_type_code == :visual_route
      assert result.route_id == "1234"
      assert result.artcc == "ZDC"
      assert result.fss == "DCA"
      assert result.time_of_use == "DAYLIGHT HOURS ONLY"
    end

    test "handles multiple ARTCC centers" do
      multi_artcc_data = create_sample_data(%{
        "ROUTE_ID" => "017",
        "ARTCC" => "ZJX ZTL",
        "TIME_OF_USE" => "1200-0400Z++"
      })

      result = MilitaryTrainingRoute.new(multi_artcc_data)
      assert result.route_id == "017"
      assert result.artcc == "ZJX ZTL"
      assert result.time_of_use == "1200-0400Z++"
    end

    test "handles complex time restrictions" do
      time_restricted_data = create_sample_data(%{
        "ROUTE_ID" => "021",
        "ARTCC" => "ZJX ZTL",
        "TIME_OF_USE" => "1200-0400Z++ MON-FRI, OCCASIONALLY ON WEEKENDS"
      })

      result = MilitaryTrainingRoute.new(time_restricted_data)
      assert result.route_id == "021"
      assert result.artcc == "ZJX ZTL"
      assert result.time_of_use == "1200-0400Z++ MON-FRI, OCCASIONALLY ON WEEKENDS"
    end

    test "handles daylight hours restriction" do
      daylight_data = create_sample_data(%{
        "ROUTE_ID" => "030",
        "ARTCC" => "ZHU ZJX ZTL",
        "TIME_OF_USE" => "DAYLIGHT HOURS ONLY, DAILY"
      })

      result = MilitaryTrainingRoute.new(daylight_data)
      assert result.route_id == "030"
      assert result.artcc == "ZHU ZJX ZTL"
      assert result.time_of_use == "DAYLIGHT HOURS ONLY, DAILY"
    end

    test "handles local time restrictions" do
      local_time_data = create_sample_data(%{
        "ROUTE_ID" => "018",
        "ARTCC" => "ZJX",
        "TIME_OF_USE" => "0700-2400 LOCAL DAILY"
      })

      result = MilitaryTrainingRoute.new(local_time_data)
      assert result.route_id == "018"
      assert result.artcc == "ZJX"
      assert result.time_of_use == "0700-2400 LOCAL DAILY"
    end

    test "handles sunrise-sunset restriction" do
      sunrise_sunset_data = create_sample_data(%{
        "ROUTE_ID" => "038",
        "ARTCC" => "ZHU",
        "TIME_OF_USE" => "SUNRISE-SUNSET, MON-FRI, OCCASIONAL WEEKENDS"
      })

      result = MilitaryTrainingRoute.new(sunrise_sunset_data)
      assert result.route_id == "038"
      assert result.artcc == "ZHU"
      assert result.time_of_use == "SUNRISE-SUNSET, MON-FRI, OCCASIONAL WEEKENDS"
    end

    test "handles route with FSS assignment" do
      fss_data = create_sample_data(%{
        "ROUTE_ID" => "123",
        "ARTCC" => "ZMA",
        "FSS" => "MIA",
        "TIME_OF_USE" => "0600-2200 LOCAL"
      })

      result = MilitaryTrainingRoute.new(fss_data)
      assert result.route_id == "123"
      assert result.artcc == "ZMA"
      assert result.fss == "MIA"
      assert result.time_of_use == "0600-2200 LOCAL"
    end

    test "handles three-digit route numbers" do
      three_digit_data = create_sample_data(%{
        "ROUTE_ID" => "456",
        "ARTCC" => "ZDC ZTL",
        "TIME_OF_USE" => "1200-0400Z++ WEEKDAYS, OCCASIONAL WEEKENDS"
      })

      result = MilitaryTrainingRoute.new(three_digit_data)
      assert result.route_id == "456"
      assert result.artcc == "ZDC ZTL"
      assert result.time_of_use == "1200-0400Z++ WEEKDAYS, OCCASIONAL WEEKENDS"
    end

    test "handles empty/nil values correctly" do
      empty_data = create_sample_data(%{
        "FSS" => "",
        "ROUTE_TYPE_CODE" => ""
      })

      result = MilitaryTrainingRoute.new(empty_data)

      assert result.fss == ""
      assert result.route_type_code == nil
    end

    test "handles unknown route type codes as strings" do
      unknown_data = create_sample_data(%{
        "ROUTE_TYPE_CODE" => "XR"
      })

      result = MilitaryTrainingRoute.new(unknown_data)
      assert result.route_type_code == "XR"
    end

    test "handles multi-center coordination" do
      multi_center_data = create_sample_data(%{
        "ROUTE_ID" => "031",
        "ARTCC" => "ZHU ZJX ZTL",
        "TIME_OF_USE" => "DAYLIGHT HOURS ONLY, DAILY"
      })

      result = MilitaryTrainingRoute.new(multi_center_data)
      assert result.route_id == "031"
      assert result.artcc == "ZHU ZJX ZTL"
      assert result.time_of_use == "DAYLIGHT HOURS ONLY, DAILY"
    end

    test "handles weekend restrictions" do
      weekend_data = create_sample_data(%{
        "ROUTE_ID" => "037",
        "ARTCC" => "ZHU ZME",
        "TIME_OF_USE" => "MON-FRI 1200-0400Z++, OCCASIONAL WEEKENDS"
      })

      result = MilitaryTrainingRoute.new(weekend_data)
      assert result.route_id == "037"
      assert result.artcc == "ZHU ZME"
      assert result.time_of_use == "MON-FRI 1200-0400Z++, OCCASIONAL WEEKENDS"
    end
  end

  describe "type/0" do
    test "returns correct type string" do
      assert MilitaryTrainingRoute.type() == "MTR_BASE"
    end
  end

  # Helper function to create sample data with default values
  defp create_sample_data(overrides) do
    Map.merge(%{
      "EFF_DATE" => "2025/08/07",
      "ROUTE_TYPE_CODE" => "IR",
      "ROUTE_ID" => "002",
      "ARTCC" => "ZTL",
      "FSS" => "",
      "TIME_OF_USE" => "CONTINUOUS"
    }, overrides)
  end
end