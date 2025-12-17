defmodule NASR.Entities.AirportRunwayTest do
  use ExUnit.Case

  alias NASR.Entities.Airport.Runway

  test "parses primary and secondary surface types from hyphenated codes" do
    entity =
      Runway.new(%{
        "SITE_NO" => "123",
        "SITE_TYPE_CODE" => "A",
        "ARPT_ID" => "TEST",
        "RWY_ID" => "18/36",
        "SURFACE_TYPE_CODE" => "CONC-ASPH"
      })

    assert entity.surface_type_code == :concrete
    assert entity.secondary_surface_type_code == :asphalt
    assert entity.meta == %{}
  end

  test "parses roof-top without secondary surface" do
    entity =
      Runway.new(%{
        "SITE_NO" => "123",
        "SITE_TYPE_CODE" => "H",
        "ARPT_ID" => "ROOF",
        "RWY_ID" => "H1",
        "SURFACE_TYPE_CODE" => "ROOF-TOP"
      })

    assert entity.surface_type_code == :roof_top
    assert entity.secondary_surface_type_code == nil
  end

  test "captures unrecognized surface codes verbatim" do
    entity =
      Runway.new(%{
        "SITE_NO" => "123",
        "SITE_TYPE_CODE" => "A",
        "ARPT_ID" => "TEST",
        "RWY_ID" => "18/36",
        "SURFACE_TYPE_CODE" => "UNKNOWN"
      })

    assert entity.surface_type_code == "UNKNOWN"
    assert entity.secondary_surface_type_code == nil
  end
end
