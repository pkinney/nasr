defmodule NASR.Entities.MilitaryTrainingRoute.TerrainTest do
  use ExUnit.Case

  describe "new/1" do
    test "creates struct from MTR terrain data sample" do
      sample_data = create_sample_data(%{})

      result = NASR.Entities.MilitaryTrainingRoute.Terrain.new(sample_data)

      assert result.eff_date == ~D[2025-08-07]
      assert result.route_type_code == :ir
      assert result.route_id == "002"
      assert result.artcc == "ZTL"
      assert result.terrain_seq_no == 5
      assert result.terrain_text == "AUTHORIZED FROM A TO H."
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
        result = NASR.Entities.MilitaryTrainingRoute.Terrain.new(sample_data)
        assert result.route_type_code == expected
      end
    end

    test "handles numeric fields correctly" do
      sample_data = create_sample_data(%{
        "TERRAIN_SEQ_NO" => "10"
      })

      result = NASR.Entities.MilitaryTrainingRoute.Terrain.new(sample_data)

      assert result.terrain_seq_no == 10
    end

    test "handles empty and nil string values correctly" do
      sample_data = create_sample_data(%{
        "TERRAIN_TEXT" => nil
      })

      result = NASR.Entities.MilitaryTrainingRoute.Terrain.new(sample_data)

      assert result.terrain_text == nil
    end

    test "parses dates correctly" do
      sample_data = create_sample_data(%{
        "EFF_DATE" => "2024/03/15"
      })

      result = NASR.Entities.MilitaryTrainingRoute.Terrain.new(sample_data)

      assert result.eff_date == ~D[2024-03-15]
    end

    test "handles multiple segment authorization" do
      sample_data = create_sample_data(%{
        "ROUTE_TYPE_CODE" => "IR",
        "ROUTE_ID" => "012",
        "ARTCC" => "ZDC",
        "TERRAIN_SEQ_NO" => "5",
        "TERRAIN_TEXT" => "AUTHORIZED FROM A TO E, AND FROM A TO FA."
      })

      result = NASR.Entities.MilitaryTrainingRoute.Terrain.new(sample_data)

      assert result.route_type_code == :ir
      assert result.route_id == "012"
      assert result.artcc == "ZDC"
      assert result.terrain_seq_no == 5
      assert result.terrain_text == "AUTHORIZED FROM A TO E, AND FROM A TO FA."
    end

    test "handles command directive authorization" do
      sample_data = create_sample_data(%{
        "ROUTE_TYPE_CODE" => "IR",
        "ROUTE_ID" => "016",
        "ARTCC" => "ZJX",
        "TERRAIN_SEQ_NO" => "5",
        "TERRAIN_TEXT" => "AUTHORIZED FROM A TO G IAW COMMAND DIRECTIVES."
      })

      result = NASR.Entities.MilitaryTrainingRoute.Terrain.new(sample_data)

      assert result.route_type_code == :ir
      assert result.route_id == "016"
      assert result.artcc == "ZJX"
      assert result.terrain_seq_no == 5
      assert result.terrain_text == "AUTHORIZED FROM A TO G IAW COMMAND DIRECTIVES."
    end

    test "handles entire route authorization" do
      sample_data = create_sample_data(%{
        "ROUTE_TYPE_CODE" => "IR",
        "ROUTE_ID" => "017",
        "ARTCC" => "ZJX ZTL",
        "TERRAIN_SEQ_NO" => "5",
        "TERRAIN_TEXT" => "AUTHORIZED FOR ENTIRE ROUTE."
      })

      result = NASR.Entities.MilitaryTrainingRoute.Terrain.new(sample_data)

      assert result.route_type_code == :ir
      assert result.route_id == "017"
      assert result.artcc == "ZJX ZTL"
      assert result.terrain_seq_no == 5
      assert result.terrain_text == "AUTHORIZED FOR ENTIRE ROUTE."
    end

    test "handles visual route terrain authorization" do
      sample_data = create_sample_data(%{
        "ROUTE_TYPE_CODE" => "VR",
        "ROUTE_ID" => "1234",
        "ARTCC" => "ZDC",
        "TERRAIN_SEQ_NO" => "5",
        "TERRAIN_TEXT" => "AUTHORIZED FROM A TO F. MAINTAIN 500 FEET AGL MINIMUM."
      })

      result = NASR.Entities.MilitaryTrainingRoute.Terrain.new(sample_data)

      assert result.route_type_code == :vr
      assert result.route_id == "1234"
      assert result.artcc == "ZDC"
      assert result.terrain_seq_no == 5
      assert result.terrain_text == "AUTHORIZED FROM A TO F. MAINTAIN 500 FEET AGL MINIMUM."
    end

    test "handles slow route terrain authorization" do
      sample_data = create_sample_data(%{
        "ROUTE_TYPE_CODE" => "SR",
        "ROUTE_ID" => "5678",
        "ARTCC" => "ZJX",
        "TERRAIN_SEQ_NO" => "5",
        "TERRAIN_TEXT" => "AUTHORIZED FROM A TO C. ROTORCRAFT OPERATIONS ONLY."
      })

      result = NASR.Entities.MilitaryTrainingRoute.Terrain.new(sample_data)

      assert result.route_type_code == :sr
      assert result.route_id == "5678"
      assert result.artcc == "ZJX"
      assert result.terrain_seq_no == 5
      assert result.terrain_text == "AUTHORIZED FROM A TO C. ROTORCRAFT OPERATIONS ONLY."
    end

    test "handles air refueling route terrain authorization" do
      sample_data = create_sample_data(%{
        "ROUTE_TYPE_CODE" => "AR",
        "ROUTE_ID" => "9999",
        "ARTCC" => "ZKC",
        "TERRAIN_SEQ_NO" => "5",
        "TERRAIN_TEXT" => "AUTHORIZED FROM A TO D FOR AERIAL REFUELING OPERATIONS."
      })

      result = NASR.Entities.MilitaryTrainingRoute.Terrain.new(sample_data)

      assert result.route_type_code == :ar
      assert result.route_id == "9999"
      assert result.artcc == "ZKC"
      assert result.terrain_seq_no == 5
      assert result.terrain_text == "AUTHORIZED FROM A TO D FOR AERIAL REFUELING OPERATIONS."
    end

    test "handles multiple ARTCC jurisdictions" do
      sample_data = create_sample_data(%{
        "ARTCC" => "ZTL ZJX ZDC"
      })

      result = NASR.Entities.MilitaryTrainingRoute.Terrain.new(sample_data)

      assert result.artcc == "ZTL ZJX ZDC"
    end

    test "handles high sequence numbers" do
      sample_data = create_sample_data(%{
        "TERRAIN_SEQ_NO" => "25"
      })

      result = NASR.Entities.MilitaryTrainingRoute.Terrain.new(sample_data)

      assert result.terrain_seq_no == 25
    end

    test "handles complex terrain descriptions" do
      sample_data = create_sample_data(%{
        "TERRAIN_TEXT" => "AUTHORIZED FROM A TO B AT FL180-FL250, FROM B TO C AT FL150-FL200."
      })

      result = NASR.Entities.MilitaryTrainingRoute.Terrain.new(sample_data)

      assert result.terrain_text == "AUTHORIZED FROM A TO B AT FL180-FL250, FROM B TO C AT FL150-FL200."
    end
  end

  describe "type/0" do
    test "returns correct CSV filename" do
      assert NASR.Entities.MilitaryTrainingRoute.Terrain.type() == "MTR_TERR"
    end
  end

  # Helper function to create comprehensive sample data with sensible defaults
  defp create_sample_data(overrides) do
    Map.merge(%{
      "EFF_DATE" => "2025/08/07",
      "ROUTE_TYPE_CODE" => "IR",
      "ROUTE_ID" => "002",
      "ARTCC" => "ZTL",
      "TERRAIN_SEQ_NO" => "5",
      "TERRAIN_TEXT" => "AUTHORIZED FROM A TO H."
    }, overrides)
  end
end