defmodule NASR.UtilsTest do
  use ExUnit.Case

  describe "list_files/1" do
    test "lists only zip files in directory" do
      # Create a temporary directory
      {:ok, tmp_dir} = Briefly.create(directory: true)

      # Create test files
      File.write!(Path.join(tmp_dir, "test1.zip"), "")
      File.write!(Path.join(tmp_dir, "test2.zip"), "")
      File.write!(Path.join(tmp_dir, "test.txt"), "")
      File.write!(Path.join(tmp_dir, "readme.md"), "")

      result = NASR.Utils.list_files(tmp_dir)

      assert length(result) == 2
      assert Enum.all?(result, &String.ends_with?(&1, ".zip"))
      assert Enum.any?(result, &String.ends_with?(&1, "test1.zip"))
      assert Enum.any?(result, &String.ends_with?(&1, "test2.zip"))
    end

    test "returns empty list when no zip files exist" do
      {:ok, tmp_dir} = Briefly.create(directory: true)
      File.write!(Path.join(tmp_dir, "test.txt"), "")

      result = NASR.Utils.list_files(tmp_dir)

      assert result == []
    end
  end

  describe "safe_str_to_int/1" do
    test "converts valid integer strings" do
      assert NASR.Utils.safe_str_to_int("123") == 123
      assert NASR.Utils.safe_str_to_int("-456") == -456
      assert NASR.Utils.safe_str_to_int("0") == 0
    end

    test "converts valid float strings to integers by truncation" do
      assert NASR.Utils.safe_str_to_int("123.45") == 123
      assert NASR.Utils.safe_str_to_int("-456.78") == -456
      assert NASR.Utils.safe_str_to_int("0.99") == 0
    end

    test "returns nil for empty string" do
      assert NASR.Utils.safe_str_to_int("") == nil
    end

    test "returns nil for invalid strings" do
      assert NASR.Utils.safe_str_to_int("abc") == nil
      assert NASR.Utils.safe_str_to_int("12.34.56") == nil
      assert NASR.Utils.safe_str_to_int("12a") == nil
    end
  end

  describe "safe_str_to_float/1" do
    test "converts valid integer strings to floats" do
      assert NASR.Utils.safe_str_to_float("123") == 123.0
      assert NASR.Utils.safe_str_to_float("-456") == -456.0
      assert NASR.Utils.safe_str_to_float("0") == 0.0
    end

    test "converts valid float strings" do
      assert NASR.Utils.safe_str_to_float("123.45") == 123.45
      assert NASR.Utils.safe_str_to_float("-456.78") == -456.78
      assert NASR.Utils.safe_str_to_float("0.99") == 0.99
    end

    test "returns nil for empty string" do
      assert NASR.Utils.safe_str_to_float("") == nil
    end

    test "returns nil for invalid strings" do
      assert NASR.Utils.safe_str_to_float("abc") == nil
      assert NASR.Utils.safe_str_to_float("12.34.56") == nil
      assert NASR.Utils.safe_str_to_float("12a") == nil
    end
  end

  describe "convert_seconds_to_decimal/1" do
    test "converts north coordinates" do
      assert NASR.Utils.convert_seconds_to_decimal("3600.0N") == 1.0
      assert NASR.Utils.convert_seconds_to_decimal("1800.0N") == 0.5
    end

    test "converts south coordinates to negative" do
      assert NASR.Utils.convert_seconds_to_decimal("3600.0S") == -1.0
      assert NASR.Utils.convert_seconds_to_decimal("1800.0S") == -0.5
    end

    test "converts east coordinates" do
      assert NASR.Utils.convert_seconds_to_decimal("7200.0E") == 2.0
      assert NASR.Utils.convert_seconds_to_decimal("3600.0E") == 1.0
    end

    test "converts west coordinates to negative" do
      assert NASR.Utils.convert_seconds_to_decimal("7200.0W") == -2.0
      assert NASR.Utils.convert_seconds_to_decimal("3600.0W") == -1.0
    end
  end

  describe "convert_dms_to_decimal/1" do
    test "returns nil for empty string" do
      assert NASR.Utils.convert_dms_to_decimal("") == nil
    end

    test "converts north coordinates" do
      result = NASR.Utils.convert_dms_to_decimal("40-30-15.0N")
      assert_in_delta result, 40.5041666667, 0.0001
    end

    test "converts south coordinates to negative" do
      result = NASR.Utils.convert_dms_to_decimal("40-30-15.0S")
      assert_in_delta result, -40.5041666667, 0.0001
    end

    test "converts east coordinates" do
      result = NASR.Utils.convert_dms_to_decimal("74-15-30.0E")
      assert_in_delta result, 74.258333333, 0.0001
    end

    test "converts west coordinates to negative" do
      result = NASR.Utils.convert_dms_to_decimal("74-15-30.0W")
      assert_in_delta result, -74.258333333, 0.0001
    end

    test "handles zero values" do
      result = NASR.Utils.convert_dms_to_decimal("0-0-0.0N")
      assert result == 0.0
    end
  end

  describe "convert_yn/1" do
    test "converts Y to true" do
      assert NASR.Utils.convert_yn("Y") == true
    end

    test "converts N to false" do
      assert NASR.Utils.convert_yn("N") == false
    end

    test "returns nil for other values" do
      assert NASR.Utils.convert_yn("X") == nil
      assert NASR.Utils.convert_yn("") == nil
      assert NASR.Utils.convert_yn("yes") == nil
      assert NASR.Utils.convert_yn("no") == nil
    end
  end

  describe "get_airac_cycle_for_date/1" do
    test "converts real-world dates to correct AIRAC codes for 2024" do
      # 2024 AIRAC cycle dates from official NAVBLUE sources
      assert NASR.Utils.get_airac_cycle_for_date(~D[2024-01-25]) == "2401"
      assert NASR.Utils.get_airac_cycle_for_date(~D[2024-02-22]) == "2402"
      assert NASR.Utils.get_airac_cycle_for_date(~D[2024-03-21]) == "2403"
      assert NASR.Utils.get_airac_cycle_for_date(~D[2024-04-18]) == "2404"
      assert NASR.Utils.get_airac_cycle_for_date(~D[2024-05-16]) == "2405"
      assert NASR.Utils.get_airac_cycle_for_date(~D[2024-06-13]) == "2406"
      assert NASR.Utils.get_airac_cycle_for_date(~D[2024-07-11]) == "2407"
      assert NASR.Utils.get_airac_cycle_for_date(~D[2024-08-08]) == "2408"
      assert NASR.Utils.get_airac_cycle_for_date(~D[2024-09-05]) == "2409"
      assert NASR.Utils.get_airac_cycle_for_date(~D[2024-10-03]) == "2410"
      assert NASR.Utils.get_airac_cycle_for_date(~D[2024-10-31]) == "2411"
      assert NASR.Utils.get_airac_cycle_for_date(~D[2024-11-28]) == "2412"
      assert NASR.Utils.get_airac_cycle_for_date(~D[2024-12-26]) == "2413"
    end

    test "converts real-world dates to correct AIRAC codes for 2025" do
      # 2025 AIRAC cycle dates from official NAVBLUE sources
      assert NASR.Utils.get_airac_cycle_for_date(~D[2025-01-23]) == "2501"
      assert NASR.Utils.get_airac_cycle_for_date(~D[2025-02-20]) == "2502"
      assert NASR.Utils.get_airac_cycle_for_date(~D[2025-03-20]) == "2503"
      assert NASR.Utils.get_airac_cycle_for_date(~D[2025-04-17]) == "2504"
      assert NASR.Utils.get_airac_cycle_for_date(~D[2025-05-15]) == "2505"
      assert NASR.Utils.get_airac_cycle_for_date(~D[2025-06-12]) == "2506"
      assert NASR.Utils.get_airac_cycle_for_date(~D[2025-07-10]) == "2507"
      assert NASR.Utils.get_airac_cycle_for_date(~D[2025-08-07]) == "2508"
      assert NASR.Utils.get_airac_cycle_for_date(~D[2025-09-04]) == "2509"
      assert NASR.Utils.get_airac_cycle_for_date(~D[2025-10-02]) == "2510"
      assert NASR.Utils.get_airac_cycle_for_date(~D[2025-10-30]) == "2511"
      assert NASR.Utils.get_airac_cycle_for_date(~D[2025-11-27]) == "2512"
      assert NASR.Utils.get_airac_cycle_for_date(~D[2025-12-25]) == "2513"
    end

    test "handles dates within AIRAC cycles (mid-cycle dates)" do
      # Test dates that fall within cycles, not just on effective dates
      # within 2401 cycle
      assert NASR.Utils.get_airac_cycle_for_date(~D[2024-02-01]) == "2401"
      # within 2401 cycle
      assert NASR.Utils.get_airac_cycle_for_date(~D[2024-02-15]) == "2401"
      # within 2402 cycle
      assert NASR.Utils.get_airac_cycle_for_date(~D[2024-03-01]) == "2402"
      # day before 2407 starts
      assert NASR.Utils.get_airac_cycle_for_date(~D[2024-07-10]) == "2406"
      # within 2407 cycle
      assert NASR.Utils.get_airac_cycle_for_date(~D[2024-07-20]) == "2407"
      # within 2501 cycle
      assert NASR.Utils.get_airac_cycle_for_date(~D[2025-02-01]) == "2501"
      # within 2506 cycle
      assert NASR.Utils.get_airac_cycle_for_date(~D[2025-06-20]) == "2506"
    end

    test "handles year boundary transitions correctly" do
      # Test dates around year boundaries
      # Should be 2023 cycle 13
      assert NASR.Utils.get_airac_cycle_for_date(~D[2024-01-01]) == "2313"
      # Day before 2401 starts
      assert NASR.Utils.get_airac_cycle_for_date(~D[2024-01-24]) == "2313"
      # Should be 2024 cycle 13
      assert NASR.Utils.get_airac_cycle_for_date(~D[2025-01-01]) == "2413"
      # Day before 2501 starts
      assert NASR.Utils.get_airac_cycle_for_date(~D[2025-01-22]) == "2413"
    end

    test "handles leap year correctly" do
      # 2024 is a leap year, verify February calculations work correctly
      # Leap day should be in 2402 cycle
      assert NASR.Utils.get_airac_cycle_for_date(~D[2024-02-29]) == "2402"
    end

    test "uses current date when nil is passed" do
      # This test will use the current date, so we just verify it returns a string
      result = NASR.Utils.get_airac_cycle_for_date(nil)
      assert is_binary(result)
      assert String.length(result) == 4
    end
  end
end
