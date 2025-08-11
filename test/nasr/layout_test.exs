defmodule NASR.LayoutTest do
  use ExUnit.Case

  setup_all do
    Application.ensure_all_started(:nasr)

    # Ensure data directory exists and download NASR file if needed
    data_dir = "data"
    nasr_file_path = Path.join(data_dir, "nasr.zip")

    File.mkdir_p!(data_dir)

    if !File.exists?(nasr_file_path) do
      IO.puts("Downloading NASR file to: #{nasr_file_path}")
      downloaded_file = NASR.Utils.download(NASR.Utils.get_current_nasr_url())
      File.cp!(downloaded_file, nasr_file_path)
      File.rm!(downloaded_file)
    end

    %{layout_ex1: File.read!("test/support/layout_ex1.txt"), nasr_file_path: nasr_file_path}
  end

  describe "split up a layout file" do
    test "separate layout file into logical groups" do
      layout = """
      ************************************************************************
      *          L A N D I N G   F A C I L I T Y   D A T A                   *
      ************************************************************************

      L AN 0003 00001  N/A     RECORD TYPE INDICATOR.
                                  APT: BASIC LANDING FACILITY DATA

      L AN 0004 00028  E7      LOCATION IDENTIFIER
                                  UNIQUE 3-4 CHARACTER ALPHANUMERIC IDENTIFIER
                                  ASSIGNED TO THE LANDING FACILITY.
                                  (EX. 'ORD' FOR CHICAGO O'HARE)

      *********************************************************************

                  'HP1' RECORD TYPE - BASE HOLDING PATTERN DATA

      *********************************************************************

      J  T   L   S L   E N
      U  Y   E   T O   L U
      S  P   N   A C   E M
      T  E   G   R A   M B
              T   T T   E E
              H     I   N R
                    O   T
                    N           FIELD DESCRIPTION

      L  AN  04 00001  NONE    RECORD TYPE INDICATOR.
                                  HP1: BASE HP DATA
      L  AN0080 00005  NONE    HOLDING PATTERN NAME (NAVAID NAME FACILITY TYPE*ST
                                        CODE) OR (FIX NAME FIX TYPE*STATE CODE*ICAO REGION CODE)
      """

      layout = NASR.Layout.extract_elements(layout)

      assert length(layout) == 4

      assert Enum.all?(layout, fn line ->
               String.match?(line, ~r/^L\s+AN\s*\d+\s+\d+\s+/)
             end)
    end

    test "parse element lines" do
      elements = [
        "L AN 0003 00001  N/A     RECORD TYPE INDICATOR.\n                            APT: BASIC LANDING FACILITY DATA",
        "L AN 0004 00028  E7      LOCATION IDENTIFIER\n                            UNIQUE 3-4 CHARACTER ALPHANUMERIC IDENTIFIER\n                            ASSIGNED TO THE LANDING FACILITY.\n                            (EX. 'ORD' FOR CHICAGO O'HARE)",
        "L  AN  04 00001  NONE    RECORD TYPE INDICATOR.\n                            HP1: BASE HP DATA",
        "L  AN0080 00005  NONE    HOLDING PATTERN NAME (NAVAID NAME FACILITY TYPE*ST\n                                  CODE) OR (FIX NAME FIX TYPE*STATE CODE*ICAO REGION CODE)"
      ]

      parsed_elements = NASR.Layout.parse_elements(elements)
      assert length(parsed_elements) == 4

      assert List.last(parsed_elements).start == 5

      assert List.last(parsed_elements).type == "AN"
      assert List.last(parsed_elements).len == 80

      assert List.last(parsed_elements).description |> String.split("\n") |> Enum.map(&String.trim(&1)) ==
               [
                 "HOLDING PATTERN NAME (NAVAID NAME FACILITY TYPE*ST",
                 "CODE) OR (FIX NAME FIX TYPE*STATE CODE*ICAO REGION CODE)"
               ]

      assert List.last(parsed_elements).elem == "NONE"
      assert List.last(parsed_elements).just == "L"
    end

    test "split element lines into types" do
      elements =
        NASR.Layout.parse_elements([
          "L AN 0003 00001  N/A     RECORD TYPE INDICATOR.\n                            APT: BASIC LANDING FACILITY DATA",
          "L AN 0004 00028  E7      LOCATION IDENTIFIER\n                            UNIQUE 3-4 CHARACTER ALPHANUMERIC IDENTIFIER\n                            ASSIGNED TO THE LANDING FACILITY.\n                            (EX. 'ORD' FOR CHICAGO O'HARE)",
          "L  AN  04 00001  NONE    RECORD TYPE INDICATOR.\n                            HP1: BASE HP DATA",
          "L  AN0080 00005  NONE    HOLDING PATTERN NAME (NAVAID NAME FACILITY TYPE*ST\n                                  CODE) OR (FIX NAME FIX TYPE*STATE CODE*ICAO REGION CODE)"
        ])

      types = NASR.Layout.split_element_types(elements)
      assert length(Map.values(types)) == 2
      assert Map.has_key?(types, "APT")
      assert Map.has_key?(types, "HP1")
    end
  end

  describe "integratoin test" do
    test "load layout file and parse elements", %{nasr_file_path: nasr_file_path} do
      layouts = NASR.load_layouts(file: nasr_file_path)

      types =
        layouts
        |> Enum.sort()
        |> Enum.each(fn {cat, type, elements} ->
          IO.puts("#{type} (#{cat})")
          Enum.each(elements, fn element -> IO.puts("  " <> element.elem) end)
        end)

      IO.inspect(length(layouts))
    end
  end
end
