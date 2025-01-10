defmodule NASR do
  @moduledoc false
  def list_layouts do
    dir = Path.join(__DIR__, "../layouts")

    dir
    |> File.ls!()
    |> Enum.filter(fn file -> String.ends_with?(file, ".txt") end)
    |> Enum.map(fn f ->
      cat = f |> String.split("_") |> List.first() |> String.upcase()
      data_file = "#{cat}.txt"
      layout_file = Path.join(dir, f)
      {cat, layout_file, data_file}
    end)
  end

  # def load do
  #   dir = Path.join(__DIR__, "../layouts")
  #
  #   pairs =
  #     dir
  #     |> File.ls!()
  #     |> Enum.filter(fn file -> String.ends_with?(file, ".txt") end)
  #     |> Enum.map(fn f ->
  #       cat = f |> String.split("_") |> List.first() |> String.upcase()
  #       data_file = "#{cat}.txt"
  #       layout_file = Path.join(dir, f)
  #       {data_file, layout_file}
  #     end)
  #     |> IO.inspect()
  #
  #   Enum.each(pairs, fn {data_file, layout_file} ->
  #     IO.inspect(layout_file)
  #     layout = NASR.Layout.load(layout_file)
  #     IO.inspect(data_file)
  #     data_file |> load(layout) |> IO.inspect()
  #   end)
  # end

  def load(zip_file_path, file, layout) do
    {:ok, zip_file} = zip_file_path |> Unzip.LocalFile.open() |> Unzip.new()

    NASR.Apt.load(zip_file, file, layout)
  end

  def build_airports(entities) do
    airports =
      entities
      |> Enum.filter(fn entity -> entity.type == :landing_facility_data end)
      |> Map.new(fn airport ->
        {airport.landing_facility_site_number, NASR.Airport.new(airport)}
      end)

    airports =
      entities
      |> Enum.filter(fn entity -> entity.type == :facility_runway_data end)
      |> Enum.reduce(airports, fn runway, airports ->
        Map.update(airports, runway.landing_facility_site_number, %{}, fn airport ->
          Map.update!(airport, :runways, &[NASR.Runway.new(runway) | &1])
        end)
      end)

    IO.inspect(airports["23750.*A"])
  end

  def safe_str_to_int(""), do: nil

  def safe_str_to_int(str) do
    cond do
      String.match?(str, ~r/^\-?\d+$/) -> String.to_integer(str)
      String.match?(str, ~r/^\-?\d+\.\d+$/) -> str |> String.to_float() |> trunc()
      true -> nil
    end
  end

  def safe_str_to_float(""), do: nil

  def safe_str_to_float(str) do
    cond do
      String.match?(str, ~r/^\-?\d+$/) -> String.to_float(str)
      String.match?(str, ~r/^\-?\d+\.\d+$/) -> String.to_float(str)
      true -> nil
    end
  end
end
