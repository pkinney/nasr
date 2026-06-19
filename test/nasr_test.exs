defmodule NasrTest do
  use ExUnit.Case

  alias NASR.Entities.Airport.ArrestingSystems
  alias NASR.Entities.Airport.Runway
  alias NASR.Entities.Fix.NavaidMakeup

  setup_all do
    Application.ensure_all_started(:nasr)
    %{nasr_file_path: NASR.TestSetup.load_nasr_zip_if_needed()}
  end

  describe "stream_raw" do
    test "get a list of all types", %{nasr_file_path: path} do
      types = NASR.list_types(file: path)
      assert length(types) == 63
      assert "AWOS" in types
      assert "APT_BASE" in types
    end

    test "gets a raw stream of all data in CSV files", %{nasr_file_path: path} do
      [file: path] |> NASR.stream_raw() |> Enum.frequencies_by(& &1["__FILE__"])
    end

    test "can take a list of types", %{nasr_file_path: path} do
      count = [file: path, include: ["AWOS", "HPF_RMK"]] |> NASR.stream_raw() |> Enum.count()
      assert count < 10_000 and count > 1000
    end
  end

  describe "stream_entities" do
    test "decodes a specific type", %{nasr_file_path: path} do
      raw =
        [file: path, include: ["FIX_BASE"]]
        |> NASR.stream_raw()
        |> Stream.filter(&(&1["FIX_ID"] == "SASIE"))
        |> Enum.take(1)
        |> List.first()

      assert NASR.Entities.Fix.new(raw)
    end

    test "stream a specific type of entity based on CSV file name", %{nasr_file_path: path} do
      entities =
        [file: path, include: ["APT_ARS"]]
        |> NASR.stream_entities()
        |> Enum.take(5)

      assert Enum.all?(entities, fn e -> e.__struct__ == ArrestingSystems end)
    end

    test "stream specific types of entity based on Module", %{nasr_file_path: path} do
      entities =
        [file: path, include: [ArrestingSystems, NavaidMakeup]]
        |> NASR.stream_entities()
        |> Enum.take(5)

      assert Enum.all?(entities, fn e -> e.__struct__ in [ArrestingSystems, NavaidMakeup] end)
    end

    test "streams structs of specific types", %{nasr_file_path: path} do
      [file: path, include: ["FIX_BASE", "FIX_CHRT"]] |> NASR.stream_entities() |> Enum.to_list()
    end

    test "assigns empty meta to all streamed entities", %{nasr_file_path: path} do
      entities =
        [file: path, include: ["FIX_BASE", "FIX_CHRT"]]
        |> NASR.stream_entities()
        |> Enum.take(50)

      assert Enum.all?(entities, fn %{meta: meta} -> meta == %{} end)
    end
  end

  describe "special entities" do
    test "handles all runway surface types", %{nasr_file_path: path} do
      unknown_surfaces =
        [include: [Runway], file: path]
        |> NASR.stream_entities()
        |> Enum.map(& &1.surface_type_code)
        |> Enum.uniq()
        |> Enum.sort()
        |> Enum.reject(&is_atom(&1))

      assert unknown_surfaces == []
    end
  end
end
