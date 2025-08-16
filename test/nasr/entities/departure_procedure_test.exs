defmodule NASR.Entities.DepartureProcedureTest do
  use ExUnit.Case
  alias NASR.Entities.DepartureProcedure

  describe "new/1" do
    test "creates DepartureProcedure struct from DP_BASE sample data" do
      sample_data = create_sample_data(%{})

      result = DepartureProcedure.new(sample_data)

      assert result.effective_date == ~D[2025-08-07]
      assert result.departure_procedure_name == "ACCRA"
      assert result.amendment_number == "FIVE"
      assert result.artcc == "ZAU"
      assert result.departure_procedure_amendment_effective_date == ~D[2020-03-26]
      assert result.rnav_flag == true
      assert result.departure_procedure_computer_code == "ACCRA5.ACCRA"
      assert result.graphical_departure_procedure_type == "SID"
      assert result.served_airports == "57C BUU ENW ETB HXF MKE MWC RAC UES"
    end

    test "handles RNAV flag conversions" do
      rnav_yes = create_sample_data(%{"RNAV_FLAG" => "Y"})
      rnav_no = create_sample_data(%{"RNAV_FLAG" => "N"})

      result_yes = DepartureProcedure.new(rnav_yes)
      result_no = DepartureProcedure.new(rnav_no)

      assert result_yes.rnav_flag == true
      assert result_no.rnav_flag == false
    end

    test "handles different amendment numbers" do
      amendments = ["ONE", "TWO", "THREE", "FOUR", "FIVE", "SIX"]

      for amendment <- amendments do
        sample_data = create_sample_data(%{"AMENDMENT_NO" => amendment})
        result = DepartureProcedure.new(sample_data)
        assert result.amendment_number == amendment
      end
    end

    test "handles different ARTCCs" do
      artccs = ["ZAU", "ZSU", "ZNY", "ZLA", "ZDC"]

      for artcc <- artccs do
        sample_data = create_sample_data(%{"ARTCC" => artcc})
        result = DepartureProcedure.new(sample_data)
        assert result.artcc == artcc
      end
    end

    test "handles multiple served airports" do
      multi_airport = create_sample_data(%{
        "SERVED_ARPT" => "ATL PDK FTY RYY",
        "DP_NAME" => "ATLANTA",
        "DP_COMPUTER_CODE" => "ATLANTA3.ATLANTA"
      })

      result = DepartureProcedure.new(multi_airport)

      assert result.served_airports == "ATL PDK FTY RYY"
      assert result.departure_procedure_name == "ATLANTA"
      assert result.departure_procedure_computer_code == "ATLANTA3.ATLANTA"
    end

    test "handles single served airport" do
      single_airport = create_sample_data(%{
        "SERVED_ARPT" => "SJU",
        "DP_NAME" => "ACONY",
        "AMENDMENT_NO" => "THREE"
      })

      result = DepartureProcedure.new(single_airport)

      assert result.served_airports == "SJU"
      assert result.departure_procedure_name == "ACONY"
      assert result.amendment_number == "THREE"
    end

    test "handles empty/nil values correctly" do
      sample_data = create_sample_data(%{
        "EFF_DATE" => "",
        "DP_AMEND_EFF_DATE" => "",
        "RNAV_FLAG" => ""
      })

      result = DepartureProcedure.new(sample_data)

      assert result.effective_date == nil
      assert result.departure_procedure_amendment_effective_date == nil
      assert result.rnav_flag == nil
    end
  end

  describe "type/0" do
    test "returns correct type string" do
      assert DepartureProcedure.type() == "DP_BASE"
    end
  end

  # Helper function to create sample data with default values
  defp create_sample_data(overrides) do
    Map.merge(%{
      "EFF_DATE" => "2025/08/07",
      "DP_NAME" => "ACCRA",
      "AMENDMENT_NO" => "FIVE",
      "ARTCC" => "ZAU",
      "DP_AMEND_EFF_DATE" => "2020/03/26",
      "RNAV_FLAG" => "Y",
      "DP_COMPUTER_CODE" => "ACCRA5.ACCRA",
      "GRAPHICAL_DP_TYPE" => "SID",
      "SERVED_ARPT" => "57C BUU ENW ETB HXF MKE MWC RAC UES"
    }, overrides)
  end
end