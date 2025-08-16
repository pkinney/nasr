defmodule NASR.Entities.STARTest do
  use ExUnit.Case
  alias NASR.Entities.STAR

  describe "new/1" do
    test "creates STAR struct from STAR_BASE sample data" do
      sample_data = create_sample_data(%{})

      result = STAR.new(sample_data)

      assert result.effective_date == ~D[2025-08-07]
      assert result.arrival_name == "BLAID"
      assert result.amendment_number == "TWO"
      assert result.artcc == "ZLA"
      assert result.star_amendment_effective_date == ~D[2024-01-25]
      assert result.rnav_flag == false
      assert result.star_computer_code == "AALAN.BLAID2"
      assert result.served_airports == "LAS"
    end

    test "handles RNAV flag conversions" do
      rnav_yes = create_sample_data(%{"RNAV_FLAG" => "Y"})
      rnav_no = create_sample_data(%{"RNAV_FLAG" => "N"})

      result_yes = STAR.new(rnav_yes)
      result_no = STAR.new(rnav_no)

      assert result_yes.rnav_flag == true
      assert result_no.rnav_flag == false
    end

    test "handles different amendment numbers" do
      amendments = ["ONE", "TWO", "THREE", "FOUR", "FIVE", "SIX"]

      for amendment <- amendments do
        sample_data = create_sample_data(%{"AMENDMENT_NO" => amendment})
        result = STAR.new(sample_data)
        assert result.amendment_number == amendment
      end
    end

    test "handles different ARTCCs" do
      artccs = ["ZLA", "ZDV", "ZNY", "ZAU", "ZDC"]

      for artcc <- artccs do
        sample_data = create_sample_data(%{"ARTCC" => artcc})
        result = STAR.new(sample_data)
        assert result.artcc == artcc
      end
    end

    test "handles RNAV STAR procedures" do
      rnav_star = create_sample_data(%{
        "ARRIVAL_NAME" => "AALLE",
        "AMENDMENT_NO" => "FOUR",
        "ARTCC" => "ZDV",
        "STAR_AMEND_EFF_DATE" => "2025/06/12",
        "RNAV_FLAG" => "Y",
        "STAR_COMPUTER_CODE" => "AALLE.AALLE4",
        "SERVED_ARPT" => "DEN"
      })

      result = STAR.new(rnav_star)

      assert result.arrival_name == "AALLE"
      assert result.amendment_number == "FOUR"
      assert result.artcc == "ZDV"
      assert result.star_amendment_effective_date == ~D[2025-06-12]
      assert result.rnav_flag == true
      assert result.star_computer_code == "AALLE.AALLE4"
      assert result.served_airports == "DEN"
    end

    test "handles multiple served airports" do
      multi_airport = create_sample_data(%{
        "SERVED_ARPT" => "ATL PDK FTY",
        "ARRIVAL_NAME" => "ATLANTA",
        "STAR_COMPUTER_CODE" => "ATLANTA.ATLANTA3"
      })

      result = STAR.new(multi_airport)

      assert result.served_airports == "ATL PDK FTY"
      assert result.arrival_name == "ATLANTA"
      assert result.star_computer_code == "ATLANTA.ATLANTA3"
    end

    test "handles conventional (non-RNAV) STAR procedures" do
      conventional_star = create_sample_data(%{
        "ARRIVAL_NAME" => "BLAID",
        "RNAV_FLAG" => "N",
        "STAR_COMPUTER_CODE" => "AALAN.BLAID2"
      })

      result = STAR.new(conventional_star)

      assert result.arrival_name == "BLAID"
      assert result.rnav_flag == false
      assert result.star_computer_code == "AALAN.BLAID2"
    end

    test "handles empty/nil values correctly" do
      sample_data = create_sample_data(%{
        "EFF_DATE" => "",
        "STAR_AMEND_EFF_DATE" => "",
        "RNAV_FLAG" => ""
      })

      result = STAR.new(sample_data)

      assert result.effective_date == nil
      assert result.star_amendment_effective_date == nil
      assert result.rnav_flag == nil
    end
  end

  describe "type/0" do
    test "returns correct type string" do
      assert STAR.type() == "STAR_BASE"
    end
  end

  # Helper function to create sample data with default values
  defp create_sample_data(overrides) do
    Map.merge(%{
      "EFF_DATE" => "2025/08/07",
      "ARRIVAL_NAME" => "BLAID",
      "AMENDMENT_NO" => "TWO",
      "ARTCC" => "ZLA",
      "STAR_AMEND_EFF_DATE" => "2024/01/25",
      "RNAV_FLAG" => "N",
      "STAR_COMPUTER_CODE" => "AALAN.BLAID2",
      "SERVED_ARPT" => "LAS"
    }, overrides)
  end
end