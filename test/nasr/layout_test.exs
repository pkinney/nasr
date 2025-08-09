defmodule NASR.Layout.ParserTest do
  use ExUnit.Case

  alias NASR.Layout.Parser

  test "parses a type line" do
    assert Parser.decode_line("[TYPE|type]") == {:type, "TYPE", :type}
  end

  test "parses a single type line" do
    assert Parser.decode_line("[type]") == {:single_type, :type}
  end

  test "parses a date line" do
    assert Parser.decode_line("_date 2023-10-01") == {:effective_date, "2023-10-01"}
  end

  test "parses a length line" do
    assert Parser.decode_line("_length 00001") == {:length, "00001"}
  end

  test "parses a spec line" do
    assert Parser.decode_line("L AN   04 00001  NONE    RECORD TYPE INDICATOR.") ==
             {:spec, "L", "AN", 4, 1, :record_type_indicator}

    assert Parser.decode_line("L AN   04 00001  N/A     RECORD TYPE INDICATOR.") ==
             {:spec, "L", "AN", 4, 1, :record_type_indicator}
  end

  test "parses at least one line from all layout files" do
    dir = Path.join(__DIR__, "../../priv/layouts")

    dir
    |> File.ls!()
    |> Enum.filter(fn file -> String.ends_with?(file, ".txt") end)
    |> Enum.each(fn file ->
      specs =
        dir
        |> Path.join(file)
        |> File.read!()
        |> String.split("\n")
        |> Enum.map(fn line ->
          Parser.decode_line(line)
        end)
        |> Enum.reject(&is_nil(&1))
        |> Enum.filter(fn line -> elem(line, 0) == :spec end)

      assert length(specs) > 5
    end)
  end
end
