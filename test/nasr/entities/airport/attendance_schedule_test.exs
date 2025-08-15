defmodule NASR.Entities.Airport.AttendanceScheduleTest do
  use ExUnit.Case

  describe "new/1" do
    test "creates struct from airport attendance schedule data" do
      sample_data = %{
        "SITE_NO" => "04513.0*A",
        "SITE_TYPE_CODE" => "AIRPORT",
        "ARPT_ID" => "LAX",
        "CITY" => "LOS ANGELES",
        "STATE_CODE" => "CA",
        "COUNTRY_CODE" => "US",
        "SKED_SEQ_NO" => "1",
        "MONTH" => "ALL YEAR",
        "DAY" => "MON-FRI",
        "HOUR" => "0600-2200",
        "EFF_DATE" => "2025/08/07"
      }

      result = NASR.Entities.Airport.AttendanceSchedule.new(sample_data)

      assert result.site_no == "04513.0*A"
      assert result.arpt_id == "LAX"
      assert result.city == "LOS ANGELES"
      assert result.state_code == "CA"
      assert result.country_code == "US"
      assert result.attendance_schedule_sequence_no == 1
      assert result.months_attended == "ALL YEAR"
      assert result.days_attended == "MON-FRI"
      assert result.hours_attended == "0600-2200"
      assert result.effective_date == ~D[2025-08-07]
    end

    test "handles various schedule formats" do
      test_cases = [
        {"ALL YEAR", "MON-FRI", "0600-2200"},
        {"JAN-MAR", "TUE,THU", "0800-1700"},
        {"SUMMER", "WEEKENDS", "0900-1800"},
        {"UNATNDD", "", ""}
      ]

      for {months, days, hours} <- test_cases do
        sample_data = create_sample_data(%{
          "MONTH" => months,
          "DAY" => days,
          "HOUR" => hours
        })
        result = NASR.Entities.Airport.AttendanceSchedule.new(sample_data)
        
        assert result.months_attended == months
        assert result.days_attended == days
        assert result.hours_attended == hours
      end
    end

    test "handles sequence numbers correctly" do
      test_cases = [
        {"1", 1},
        {"2", 2},
        {"10", 10},
        {"", nil},
        {nil, nil}
      ]

      for {input, expected} <- test_cases do
        sample_data = create_sample_data(%{"SKED_SEQ_NO" => input})
        result = NASR.Entities.Airport.AttendanceSchedule.new(sample_data)
        assert result.attendance_schedule_sequence_no == expected
      end
    end

    test "handles unattended facilities" do
      sample_data = create_sample_data(%{
        "MONTH" => "UNATNDD",
        "DAY" => "",
        "HOUR" => ""
      })
      
      result = NASR.Entities.Airport.AttendanceSchedule.new(sample_data)
      
      assert result.months_attended == "UNATNDD"
      assert result.days_attended == ""
      assert result.hours_attended == ""
    end

    test "handles seasonal schedules" do
      sample_data = create_sample_data(%{
        "MONTH" => "APR-OCT",
        "DAY" => "DAILY",
        "HOUR" => "SUNRISE-SUNSET"
      })
      
      result = NASR.Entities.Airport.AttendanceSchedule.new(sample_data)
      
      assert result.months_attended == "APR-OCT"
      assert result.days_attended == "DAILY"
      assert result.hours_attended == "SUNRISE-SUNSET"
    end

    test "parses dates correctly" do
      sample_data = create_sample_data(%{"EFF_DATE" => "2023/12/15"})
      result = NASR.Entities.Airport.AttendanceSchedule.new(sample_data)
      assert result.effective_date == ~D[2023-12-15]
    end
  end

  test "type/0 returns correct CSV filename" do
    assert NASR.Entities.Airport.AttendanceSchedule.type() == "APT_ATT"
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
      "SKED_SEQ_NO" => "1",
      "MONTH" => "ALL YEAR",
      "DAY" => "MON-FRI",
      "HOUR" => "0800-1700",
      "EFF_DATE" => "2025/08/07"
    }, overrides)
  end
end