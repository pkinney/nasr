defmodule NASR.Entities.Airport.ArrestingSystemsTest do
  use ExUnit.Case

  describe "new/1" do
    test "creates struct from airport arresting systems data" do
      sample_data = %{
        "SITE_NO" => "04513.0*A",
        "SITE_TYPE_CODE" => "AIRPORT",
        "ARPT_ID" => "LAX",
        "CITY" => "LOS ANGELES",
        "STATE_CODE" => "CA",
        "COUNTRY_CODE" => "US",
        "RWY_ID" => "07R/25L",
        "RWY_END_ID" => "07R",
        "ARREST_DEVICE_CODE" => "BAK-12",
        "EFF_DATE" => "2025/08/07"
      }

      result = NASR.Entities.Airport.ArrestingSystems.new(sample_data)

      assert result.site_no == "04513.0*A"
      assert result.arpt_id == "LAX"
      assert result.city == "LOS ANGELES"
      assert result.state_code == "CA"
      assert result.country_code == "US"
      assert result.runway_id == "07R/25L"
      assert result.runway_end_id == "07R"
      assert result.arresting_device_type == :bak_12
      assert result.effective_date == ~D[2025-08-07]
    end

    test "handles arresting device types correctly" do
      test_cases = [
        {"BAK-6", :bak_6},
        {"BAK-9", :bak_9},
        {"BAK-12", :bak_12},
        {"BAK-12B", :bak_12b},
        {"BAK-13", :bak_13},
        {"BAK-14", :bak_14},
        {"E5", :e5},
        {"E5-1", :e5_1},
        {"E27", :e27},
        {"E27B", :e27b},
        {"E28", :e28},
        {"E28B", :e28b},
        {"EMAS", :emas},
        {"M21", :m21},
        {"MA-1", :ma_1},
        {"MA-1A", :ma_1a},
        {"MA-1A MOD", :ma_1a_mod},
        {"UNKNOWN", "UNKNOWN"}
      ]

      for {input, expected} <- test_cases do
        sample_data = create_sample_data(%{"ARREST_DEVICE_CODE" => input})
        result = NASR.Entities.Airport.ArrestingSystems.new(sample_data)
        assert result.arresting_device_type == expected
      end
    end

    test "handles nil and empty arresting device codes" do
      sample_data = create_sample_data(%{"ARREST_DEVICE_CODE" => ""})
      result = NASR.Entities.Airport.ArrestingSystems.new(sample_data)
      assert result.arresting_device_type == nil

      sample_data = create_sample_data(%{"ARREST_DEVICE_CODE" => nil})
      result = NASR.Entities.Airport.ArrestingSystems.new(sample_data)
      assert result.arresting_device_type == nil
    end

    test "handles various runway identifiers" do
      test_cases = [
        "01/19",
        "07R/25L",
        "10L/28R",
        "36",
        "H1"
      ]

      for runway_id <- test_cases do
        sample_data = create_sample_data(%{
          "RWY_ID" => runway_id,
          "RWY_END_ID" => String.split(runway_id, "/") |> List.first()
        })
        result = NASR.Entities.Airport.ArrestingSystems.new(sample_data)
        assert result.runway_id == runway_id
      end
    end

    test "parses dates correctly" do
      sample_data = create_sample_data(%{"EFF_DATE" => "2023/12/15"})
      result = NASR.Entities.Airport.ArrestingSystems.new(sample_data)
      assert result.effective_date == ~D[2023-12-15]
    end
  end

  test "type/0 returns correct CSV filename" do
    assert NASR.Entities.Airport.ArrestingSystems.type() == "APT_ARS"
  end

  # Helper function to create sample data with default values
  defp create_sample_data(overrides) do
    Map.merge(%{
      "SITE_NO" => "12345.*A",
      "SITE_TYPE_CODE" => "AIRPORT",
      "ARPT_ID" => "TEST",
      "CITY" => "TEST CITY",
      "STATE_CODE" => "TX",
      "COUNTRY_CODE" => "US",
      "RWY_ID" => "01/19",
      "RWY_END_ID" => "01",
      "ARREST_DEVICE_CODE" => "BAK-12",
      "EFF_DATE" => "2025/08/07"
    }, overrides)
  end
end