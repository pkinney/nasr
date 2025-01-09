defmodule NASR do
  @moduledoc """
  Documentation for `NASR`.
  """

  def load(file, layout) do
    zip_file_path = "./data/28DaySubscription_Effective_2024-12-26.zip"
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
