defmodule NASR.Entities.PreferredRoute.RemoteFormatTest do
  use ExUnit.Case

  describe "new/1" do
    test "creates struct from preferred route remote format data sample" do
      sample_data = create_sample_data(%{})

      result = NASR.Entities.PreferredRoute.RemoteFormat.new(sample_data)

      assert result.orig == "ABE"
      assert result.route_string == "ABE FJC ARD CYN ACY"
      assert result.dest == "ACY"
      assert result.hours1 == nil
      assert result.type == :tec
      assert result.area == nil
      assert result.altitude == "5000"
      assert result.aircraft == nil
      assert result.direction == nil
      assert result.seq == 1
      assert result.dcntr == "ZNY"
      assert result.acntr == "ZDC"
    end

    test "handles route type codes correctly" do
      test_cases = [
        {"TEC", :tec},
        {"NAR", :nar},
        {"PREF", :pref},
        {"HIGH", :high},
        {"LOW", :low},
        {"RNAV", :rnav},
        {"", nil},
        {nil, nil}
      ]

      for {input, expected} <- test_cases do
        sample_data = create_sample_data(%{"Type" => input})
        result = NASR.Entities.PreferredRoute.RemoteFormat.new(sample_data)
        assert result.type == expected
      end
    end

    test "handles numeric fields correctly" do
      sample_data = create_sample_data(%{
        "Seq" => "2"
      })

      result = NASR.Entities.PreferredRoute.RemoteFormat.new(sample_data)

      assert result.seq == 2
    end

    test "handles empty and nil string values correctly" do
      sample_data = create_sample_data(%{
        "Hours1" => "",
        "Area" => nil,
        "Aircraft" => "",
        "Direction" => nil
      })

      result = NASR.Entities.PreferredRoute.RemoteFormat.new(sample_data)

      assert result.hours1 == nil
      assert result.area == nil
      assert result.aircraft == nil
      assert result.direction == nil
    end

    test "handles TEC route with special area description" do
      sample_data = create_sample_data(%{
        "Orig" => "ABE",
        "Route String" => "ABE FJC LAAYK ALB",
        "Dest" => "ALB",
        "Area" => "TO ALB,SCH",
        "Altitude" => "7000",
        "Seq" => "1",
        "DCNTR" => "ZNY",
        "ACNTR" => "ZBW"
      })

      result = NASR.Entities.PreferredRoute.RemoteFormat.new(sample_data)

      assert result.orig == "ABE"
      assert result.route_string == "ABE FJC LAAYK ALB"
      assert result.dest == "ALB"
      assert result.area == "TO ALB,SCH"
      assert result.altitude == "7000"
      assert result.seq == 1
      assert result.dcntr == "ZNY"
      assert result.acntr == "ZBW"
    end

    test "handles complex route string" do
      sample_data = create_sample_data(%{
        "Orig" => "ABE",
        "Route String" => "ABE FJC T299 HUO IGN PWL BRISS BDL",
        "Dest" => "BDL",
        "Altitude" => "5000",
        "DCNTR" => "ZNY",
        "ACNTR" => "ZBW"
      })

      result = NASR.Entities.PreferredRoute.RemoteFormat.new(sample_data)

      assert result.orig == "ABE"
      assert result.route_string == "ABE FJC T299 HUO IGN PWL BRISS BDL"
      assert result.dest == "BDL"
      assert result.altitude == "5000"
      assert result.dcntr == "ZNY"
      assert result.acntr == "ZBW"
    end

    test "handles different center combinations" do
      sample_data = create_sample_data(%{
        "DCNTR" => "ZDC",
        "ACNTR" => "ZNY"
      })

      result = NASR.Entities.PreferredRoute.RemoteFormat.new(sample_data)

      assert result.dcntr == "ZDC"
      assert result.acntr == "ZNY"
    end

    test "handles same center for departure and arrival" do
      sample_data = create_sample_data(%{
        "DCNTR" => "ZNY",
        "ACNTR" => "ZNY"
      })

      result = NASR.Entities.PreferredRoute.RemoteFormat.new(sample_data)

      assert result.dcntr == "ZNY"
      assert result.acntr == "ZNY"
    end

    test "handles high sequence numbers" do
      sample_data = create_sample_data(%{
        "Seq" => "5"
      })

      result = NASR.Entities.PreferredRoute.RemoteFormat.new(sample_data)

      assert result.seq == 5
    end
  end

  describe "type/0" do
    test "returns correct CSV filename" do
      assert NASR.Entities.PreferredRoute.RemoteFormat.type() == "PFR_RMT_FMT"
    end
  end

  # Helper function to create comprehensive sample data with sensible defaults
  defp create_sample_data(overrides) do
    Map.merge(%{
      "Orig" => "ABE",
      "Route String" => "ABE FJC ARD CYN ACY",
      "Dest" => "ACY",
      "Hours1" => "",
      "Type" => "TEC",
      "Area" => "",
      "Altitude" => "5000",
      "Aircraft" => "",
      "Direction" => "",
      "Seq" => "1",
      "DCNTR" => "ZNY",
      "ACNTR" => "ZDC"
    }, overrides)
  end
end