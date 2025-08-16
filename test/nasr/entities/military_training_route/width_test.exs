defmodule NASR.Entities.MilitaryTrainingRoute.WidthTest do
  use ExUnit.Case

  describe "new/1" do
    test "creates struct from MTR width data sample" do
      sample_data = create_sample_data(%{})

      result = NASR.Entities.MilitaryTrainingRoute.Width.new(sample_data)

      assert result.eff_date == ~D[2025-08-07]
      assert result.route_type_code == :ir
      assert result.route_id == "002"
      assert result.artcc == "ZTL"
      assert result.width_seq_no == 5
      assert result.width_text == "5 NM EITHER SIDE OF CENTERLINE FOR THE ENTIRE ROUTE."
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
        result = NASR.Entities.MilitaryTrainingRoute.Width.new(sample_data)
        assert result.route_type_code == expected
      end
    end

    test "handles numeric fields correctly" do
      sample_data = create_sample_data(%{
        "WIDTH_SEQ_NO" => "10"
      })

      result = NASR.Entities.MilitaryTrainingRoute.Width.new(sample_data)

      assert result.width_seq_no == 10
    end

    test "handles empty and nil string values correctly" do
      sample_data = create_sample_data(%{
        "WIDTH_TEXT" => nil
      })

      result = NASR.Entities.MilitaryTrainingRoute.Width.new(sample_data)

      assert result.width_text == nil
    end

    test "parses dates correctly" do
      sample_data = create_sample_data(%{
        "EFF_DATE" => "2024/03/15"
      })

      result = NASR.Entities.MilitaryTrainingRoute.Width.new(sample_data)

      assert result.eff_date == ~D[2024-03-15]
    end

    test "handles varying width by segment" do
      sample_data = create_sample_data(%{
        "ROUTE_TYPE_CODE" => "IR",
        "ROUTE_ID" => "012",
        "ARTCC" => "ZDC",
        "WIDTH_SEQ_NO" => "5",
        "WIDTH_TEXT" => "5 NM EITHER SIDE OF CENTERLINE FROM  A TO B;"
      })

      result = NASR.Entities.MilitaryTrainingRoute.Width.new(sample_data)

      assert result.route_type_code == :ir
      assert result.route_id == "012"
      assert result.artcc == "ZDC"
      assert result.width_seq_no == 5
      assert result.width_text == "5 NM EITHER SIDE OF CENTERLINE FROM  A TO B;"
    end

    test "handles complex width specification" do
      sample_data = create_sample_data(%{
        "ROUTE_TYPE_CODE" => "IR",
        "ROUTE_ID" => "012",
        "ARTCC" => "ZDC",
        "WIDTH_SEQ_NO" => "10",
        "WIDTH_TEXT" => "4 NM EITHER SIDE OF CENTERLINE FROM B TO E; 3 NM LEFT AND 1 NM"
      })

      result = NASR.Entities.MilitaryTrainingRoute.Width.new(sample_data)

      assert result.route_type_code == :ir
      assert result.route_id == "012"
      assert result.artcc == "ZDC"
      assert result.width_seq_no == 10
      assert result.width_text == "4 NM EITHER SIDE OF CENTERLINE FROM B TO E; 3 NM LEFT AND 1 NM"
    end

    test "handles asymmetric width specification" do
      sample_data = create_sample_data(%{
        "ROUTE_TYPE_CODE" => "IR",
        "ROUTE_ID" => "012",
        "ARTCC" => "ZDC",
        "WIDTH_SEQ_NO" => "15",
        "WIDTH_TEXT" => "RIGHT OF CENTERLINE FROM E TO F; 3 NM LEFT OF CENTERLINE FROM F"
      })

      result = NASR.Entities.MilitaryTrainingRoute.Width.new(sample_data)

      assert result.route_type_code == :ir
      assert result.route_id == "012"
      assert result.artcc == "ZDC"
      assert result.width_seq_no == 15
      assert result.width_text == "RIGHT OF CENTERLINE FROM E TO F; 3 NM LEFT OF CENTERLINE FROM F"
    end

    test "handles visual route width specification" do
      sample_data = create_sample_data(%{
        "ROUTE_TYPE_CODE" => "VR",
        "ROUTE_ID" => "1234",
        "ARTCC" => "ZDC",
        "WIDTH_SEQ_NO" => "5",
        "WIDTH_TEXT" => "2 NM EITHER SIDE OF CENTERLINE FOR ENTIRE ROUTE."
      })

      result = NASR.Entities.MilitaryTrainingRoute.Width.new(sample_data)

      assert result.route_type_code == :vr
      assert result.route_id == "1234"
      assert result.artcc == "ZDC"
      assert result.width_seq_no == 5
      assert result.width_text == "2 NM EITHER SIDE OF CENTERLINE FOR ENTIRE ROUTE."
    end

    test "handles slow route width specification" do
      sample_data = create_sample_data(%{
        "ROUTE_TYPE_CODE" => "SR",
        "ROUTE_ID" => "5678",
        "ARTCC" => "ZJX",
        "WIDTH_SEQ_NO" => "5",
        "WIDTH_TEXT" => "1 NM EITHER SIDE OF CENTERLINE FOR ROTORCRAFT OPERATIONS."
      })

      result = NASR.Entities.MilitaryTrainingRoute.Width.new(sample_data)

      assert result.route_type_code == :sr
      assert result.route_id == "5678"
      assert result.artcc == "ZJX"
      assert result.width_seq_no == 5
      assert result.width_text == "1 NM EITHER SIDE OF CENTERLINE FOR ROTORCRAFT OPERATIONS."
    end

    test "handles air refueling route width specification" do
      sample_data = create_sample_data(%{
        "ROUTE_TYPE_CODE" => "AR",
        "ROUTE_ID" => "9999",
        "ARTCC" => "ZKC",
        "WIDTH_SEQ_NO" => "5",
        "WIDTH_TEXT" => "10 NM EITHER SIDE OF CENTERLINE FOR AERIAL REFUELING OPERATIONS."
      })

      result = NASR.Entities.MilitaryTrainingRoute.Width.new(sample_data)

      assert result.route_type_code == :ar
      assert result.route_id == "9999"
      assert result.artcc == "ZKC"
      assert result.width_seq_no == 5
      assert result.width_text == "10 NM EITHER SIDE OF CENTERLINE FOR AERIAL REFUELING OPERATIONS."
    end

    test "handles multiple ARTCC jurisdictions" do
      sample_data = create_sample_data(%{
        "ARTCC" => "ZTL ZJX"
      })

      result = NASR.Entities.MilitaryTrainingRoute.Width.new(sample_data)

      assert result.artcc == "ZTL ZJX"
    end

    test "handles high sequence numbers" do
      sample_data = create_sample_data(%{
        "WIDTH_SEQ_NO" => "25"
      })

      result = NASR.Entities.MilitaryTrainingRoute.Width.new(sample_data)

      assert result.width_seq_no == 25
    end

    test "handles detailed segment width specifications" do
      sample_data = create_sample_data(%{
        "WIDTH_TEXT" => "6 NM EITHER SIDE FROM A TO B; 4 NM EITHER SIDE FROM B TO C; 2 NM EITHER SIDE FROM C TO D."
      })

      result = NASR.Entities.MilitaryTrainingRoute.Width.new(sample_data)

      assert result.width_text == "6 NM EITHER SIDE FROM A TO B; 4 NM EITHER SIDE FROM B TO C; 2 NM EITHER SIDE FROM C TO D."
    end

    test "handles width specifications with altitude considerations" do
      sample_data = create_sample_data(%{
        "WIDTH_TEXT" => "5 NM EITHER SIDE OF CENTERLINE BELOW FL180; 10 NM EITHER SIDE ABOVE FL180."
      })

      result = NASR.Entities.MilitaryTrainingRoute.Width.new(sample_data)

      assert result.width_text == "5 NM EITHER SIDE OF CENTERLINE BELOW FL180; 10 NM EITHER SIDE ABOVE FL180."
    end

    test "handles continuation of width text" do
      sample_data = create_sample_data(%{
        "WIDTH_SEQ_NO" => "20",
        "WIDTH_TEXT" => "TO G; 5 NM EITHER SIDE OF CENTERLINE FROM G TO END."
      })

      result = NASR.Entities.MilitaryTrainingRoute.Width.new(sample_data)

      assert result.width_seq_no == 20
      assert result.width_text == "TO G; 5 NM EITHER SIDE OF CENTERLINE FROM G TO END."
    end
  end

  describe "type/0" do
    test "returns correct CSV filename" do
      assert NASR.Entities.MilitaryTrainingRoute.Width.type() == "MTR_WDTH"
    end
  end

  # Helper function to create comprehensive sample data with sensible defaults
  defp create_sample_data(overrides) do
    Map.merge(%{
      "EFF_DATE" => "2025/08/07",
      "ROUTE_TYPE_CODE" => "IR",
      "ROUTE_ID" => "002",
      "ARTCC" => "ZTL",
      "WIDTH_SEQ_NO" => "5",
      "WIDTH_TEXT" => "5 NM EITHER SIDE OF CENTERLINE FOR THE ENTIRE ROUTE."
    }, overrides)
  end
end