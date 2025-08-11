defmodule NasrTest do
  use ExUnit.Case

  setup_all do
    Application.ensure_all_started(:nasr)
    %{nasr_file_path: NASR.TestSetup.load_nasr_zip_if_needed()}
  end

  describe "stream_raw" do
    test "get a list of all types", %{nasr_file_path: path} do
      types = NASR.list_types(file: path)
      assert length(types) == 63
      assert Enum.member?(types, "AWOS")
      assert Enum.member?(types, "APT_BASE")
    end

    test "gets a raw stream of all data in CSV files", %{nasr_file_path: path} do
      [file: path] |> NASR.stream_raw() |> Enum.frequencies_by(& &1["__FILE__"]) |> IO.inspect()
    end

    test "can take a list of types", %{nasr_file_path: path} do
      count = [file: path, include: ["AWOS", "HPF_RMK"]] |> NASR.stream_raw() |> Enum.count()
      assert count < 10_000 and count > 1000
    end
  end

  describe "stream_structs" do
    test "decodes a specific type", %{nasr_file_path: path} do
      raw =
        [file: path, include: ["FIX_BASE"]]
        |> NASR.stream_raw()
        |> Stream.filter(&(&1["FIX_ID"] == "SASIE"))
        |> Enum.take(1)
        |> List.first()

      # [file: path, include: ["APT_BASE"]] |> NASR.stream_structs() |> Enum.find()
      NASR.Entities.Fix.new(raw)
    end

    test "streams structs of specific types", %{nasr_file_path: path} do
      [file: path, include: ["FIX_BASE", "FIX_CHRT"]] |> NASR.stream_structs() |> Enum.to_list() |> IO.inspect()
    end
  end
end
