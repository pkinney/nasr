defmodule NASR.Entities.MilitaryTrainingRoute.StandardOperatingProcedureTest do
  use ExUnit.Case

  describe "new/1" do
    test "creates struct from MTR SOP data sample" do
      sample_data = create_sample_data(%{})

      result = NASR.Entities.MilitaryTrainingRoute.StandardOperatingProcedure.new(sample_data)

      assert result.eff_date == ~D[2025-08-07]
      assert result.route_type_code == :ir
      assert result.route_id == "002"
      assert result.artcc == "ZTL"
      assert result.sop_seq_no == 4
      assert result.sop_text == "(1)     ROUTE RESERVATION AND BRIEF REQUIRED."
    end

    test "handles route type codes correctly" do
      test_cases = [
        {"IR", :ir},
        {"VR", :vr},
        {"SR", :sr},
        {"AR", :ar},
        {"", nil},
        {nil, nil}
      ]

      for {input, expected} <- test_cases do
        sample_data = create_sample_data(%{"ROUTE_TYPE_CODE" => input})
        result = NASR.Entities.MilitaryTrainingRoute.StandardOperatingProcedure.new(sample_data)
        assert result.route_type_code == expected
      end
    end

    test "handles numeric fields correctly" do
      sample_data = create_sample_data(%{
        "SOP_SEQ_NO" => "10"
      })

      result = NASR.Entities.MilitaryTrainingRoute.StandardOperatingProcedure.new(sample_data)

      assert result.sop_seq_no == 10
    end

    test "handles empty and nil string values correctly" do
      sample_data = create_sample_data(%{
        "SOP_TEXT" => nil
      })

      result = NASR.Entities.MilitaryTrainingRoute.StandardOperatingProcedure.new(sample_data)

      assert result.sop_text == nil
    end

    test "parses dates correctly" do
      sample_data = create_sample_data(%{
        "EFF_DATE" => "2024/03/15"
      })

      result = NASR.Entities.MilitaryTrainingRoute.StandardOperatingProcedure.new(sample_data)

      assert result.eff_date == ~D[2024-03-15]
    end

    test "handles communication procedure" do
      sample_data = create_sample_data(%{
        "ROUTE_TYPE_CODE" => "IR",
        "ROUTE_ID" => "002",
        "ARTCC" => "ZTL",
        "SOP_SEQ_NO" => "5",
        "SOP_TEXT" => "(2)     MONITOR ATLANTA ARTCC ON 254.3 AT B."
      })

      result = NASR.Entities.MilitaryTrainingRoute.StandardOperatingProcedure.new(sample_data)

      assert result.route_type_code == :ir
      assert result.route_id == "002"
      assert result.artcc == "ZTL"
      assert result.sop_seq_no == 5
      assert result.sop_text == "(2)     MONITOR ATLANTA ARTCC ON 254.3 AT B."
    end

    test "handles contact procedure" do
      sample_data = create_sample_data(%{
        "ROUTE_TYPE_CODE" => "IR",
        "ROUTE_ID" => "002",
        "ARTCC" => "ZTL",
        "SOP_SEQ_NO" => "10",
        "SOP_TEXT" => "(3)     CONTACT ATLANTA ARTCC ON 379.95 PASSING F. IF NO CONTACT,"
      })

      result = NASR.Entities.MilitaryTrainingRoute.StandardOperatingProcedure.new(sample_data)

      assert result.route_type_code == :ir
      assert result.route_id == "002"
      assert result.artcc == "ZTL"
      assert result.sop_seq_no == 10
      assert result.sop_text == "(3)     CONTACT ATLANTA ARTCC ON 379.95 PASSING F. IF NO CONTACT,"
    end

    test "handles continuation procedure" do
      sample_data = create_sample_data(%{
        "ROUTE_TYPE_CODE" => "IR",
        "ROUTE_ID" => "002",
        "ARTCC" => "ZTL",
        "SOP_SEQ_NO" => "11",
        "SOP_TEXT" => "         TRY ASHEVILLE APP CON ON 351.8 OR 124.65 FOR FURTHER IFR"
      })

      result = NASR.Entities.MilitaryTrainingRoute.StandardOperatingProcedure.new(sample_data)

      assert result.route_type_code == :ir
      assert result.route_id == "002"
      assert result.artcc == "ZTL"
      assert result.sop_seq_no == 11
      assert result.sop_text == "TRY ASHEVILLE APP CON ON 351.8 OR 124.65 FOR FURTHER IFR"
    end

    test "handles visual route procedure" do
      sample_data = create_sample_data(%{
        "ROUTE_TYPE_CODE" => "VR",
        "ROUTE_ID" => "1234",
        "ARTCC" => "ZDC",
        "SOP_SEQ_NO" => "5",
        "SOP_TEXT" => "(1)     VFR CONDITIONS REQUIRED. MAINTAIN 500 FEET AGL OR HIGHER."
      })

      result = NASR.Entities.MilitaryTrainingRoute.StandardOperatingProcedure.new(sample_data)

      assert result.route_type_code == :vr
      assert result.route_id == "1234"
      assert result.artcc == "ZDC"
      assert result.sop_seq_no == 5
      assert result.sop_text == "(1)     VFR CONDITIONS REQUIRED. MAINTAIN 500 FEET AGL OR HIGHER."
    end

    test "handles slow route procedure" do
      sample_data = create_sample_data(%{
        "ROUTE_TYPE_CODE" => "SR",
        "ROUTE_ID" => "5678",
        "ARTCC" => "ZJX",
        "SOP_SEQ_NO" => "5",
        "SOP_TEXT" => "(1)     ROUTE AUTHORIZED FOR ROTORCRAFT AND PROPELLER AIRCRAFT ONLY."
      })

      result = NASR.Entities.MilitaryTrainingRoute.StandardOperatingProcedure.new(sample_data)

      assert result.route_type_code == :sr
      assert result.route_id == "5678"
      assert result.artcc == "ZJX"
      assert result.sop_seq_no == 5
      assert result.sop_text == "(1)     ROUTE AUTHORIZED FOR ROTORCRAFT AND PROPELLER AIRCRAFT ONLY."
    end

    test "handles air refueling route procedure" do
      sample_data = create_sample_data(%{
        "ROUTE_TYPE_CODE" => "AR",
        "ROUTE_ID" => "9999",
        "ARTCC" => "ZKC",
        "SOP_SEQ_NO" => "5",
        "SOP_TEXT" => "(1)     AERIAL REFUELING OPERATIONS. TANKER AND RECEIVER SEPARATION REQUIRED."
      })

      result = NASR.Entities.MilitaryTrainingRoute.StandardOperatingProcedure.new(sample_data)

      assert result.route_type_code == :ar
      assert result.route_id == "9999"
      assert result.artcc == "ZKC"
      assert result.sop_seq_no == 5
      assert result.sop_text == "(1)     AERIAL REFUELING OPERATIONS. TANKER AND RECEIVER SEPARATION REQUIRED."
    end

    test "handles multiple ARTCC jurisdictions" do
      sample_data = create_sample_data(%{
        "ARTCC" => "ZTL ZJX"
      })

      result = NASR.Entities.MilitaryTrainingRoute.StandardOperatingProcedure.new(sample_data)

      assert result.artcc == "ZTL ZJX"
    end
  end

  describe "type/0" do
    test "returns correct CSV filename" do
      assert NASR.Entities.MilitaryTrainingRoute.StandardOperatingProcedure.type() == "MTR_SOP"
    end
  end

  # Helper function to create comprehensive sample data with sensible defaults
  defp create_sample_data(overrides) do
    Map.merge(%{
      "EFF_DATE" => "2025/08/07",
      "ROUTE_TYPE_CODE" => "IR",
      "ROUTE_ID" => "002",
      "ARTCC" => "ZTL",
      "SOP_SEQ_NO" => "4",
      "SOP_TEXT" => "(1)     ROUTE RESERVATION AND BRIEF REQUIRED."
    }, overrides)
  end
end