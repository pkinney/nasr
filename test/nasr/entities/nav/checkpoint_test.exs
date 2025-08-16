defmodule NASR.Entities.Nav.CheckpointTest do
  use ExUnit.Case
  alias NASR.Entities.Nav.Checkpoint

  describe "new/1" do
    test "creates Checkpoint struct from NAV_CKPT sample data" do
      sample_data = create_sample_data(%{})

      result = Checkpoint.new(sample_data)

      assert result.effective_date == ~D[2025-08-07]
      assert result.nav_id == "ACK"
      assert result.nav_type == "VOR/DME"
      assert result.state_code == "MA"
      assert result.city == "NANTUCKET"
      assert result.country_code == "US"
      assert result.altitude == nil
      assert result.bearing == 242
      assert result.air_ground_code == :ground
      assert result.checkpoint_description == "1.9 NM ON RUNUP AREA AT APCH END RWY 24."
      assert result.airport_id == "ACK"
      assert result.state_checkpoint_code == "MA"
    end

    test "handles air/ground codes" do
      air_ground_codes = [
        {"A", :air},
        {"G", :ground},
        {"G1", :ground_one}
      ]

      for {input, expected} <- air_ground_codes do
        sample_data = create_sample_data(%{"AIR_GND_CODE" => input})
        result = Checkpoint.new(sample_data)
        assert result.air_ground_code == expected
      end
    end

    test "handles air checkpoint with altitude" do
      air_checkpoint = create_sample_data(%{
        "ALTITUDE" => "5000",
        "AIR_GND_CODE" => "A",
        "CHK_DESC" => "5.2 NM ENE AT 5000 FT"
      })

      result = Checkpoint.new(air_checkpoint)
      assert result.altitude == 5000
      assert result.air_ground_code == :air
      assert result.checkpoint_description == "5.2 NM ENE AT 5000 FT"
    end

    test "handles empty/nil values correctly" do
      sample_data = create_sample_data(%{
        "ALTITUDE" => "",
        "BRG" => "",
        "AIR_GND_CODE" => "",
        "CHK_DESC" => "",
        "ARPT_ID" => ""
      })

      result = Checkpoint.new(sample_data)

      assert result.altitude == nil
      assert result.bearing == nil
      assert result.air_ground_code == nil
      assert result.checkpoint_description == ""
      assert result.airport_id == ""
    end

    test "handles bearing values" do
      sample_data = create_sample_data(%{"BRG" => "090"})
      result = Checkpoint.new(sample_data)
      assert result.bearing == 90

      sample_data = create_sample_data(%{"BRG" => "360"})
      result = Checkpoint.new(sample_data)
      assert result.bearing == 360
    end
  end

  describe "type/0" do
    test "returns correct type string" do
      assert Checkpoint.type() == "NAV_CKPT"
    end
  end

  # Helper function to create sample data with default values
  defp create_sample_data(overrides) do
    Map.merge(%{
      "EFF_DATE" => "2025/08/07",
      "NAV_ID" => "ACK",
      "NAV_TYPE" => "VOR/DME",
      "STATE_CODE" => "MA",
      "CITY" => "NANTUCKET",
      "COUNTRY_CODE" => "US",
      "ALTITUDE" => "",
      "BRG" => "242",
      "AIR_GND_CODE" => "G",
      "CHK_DESC" => "1.9 NM ON RUNUP AREA AT APCH END RWY 24.",
      "ARPT_ID" => "ACK",
      "STATE_CHK_CODE" => "MA"
    }, overrides)
  end
end