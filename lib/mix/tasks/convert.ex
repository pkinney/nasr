# mix task
defmodule Mix.Tasks.Nasr.Convert do
  @moduledoc false
  use Mix.Task

  def run(args) do
    Mix.Task.run("compile")
    __MODULE__.compiled_run(args)
  end

  def compiled_run(_args) do
    dir = File.cwd!()

    entities =
      dir
      |> Path.join("output")
      |> File.ls!()
      |> Enum.filter(fn file -> String.ends_with?(file, ".data") end)
      |> Enum.flat_map(fn file ->
        IO.puts("Loading #{file}...")
        [dir, "output", file] |> Path.join() |> File.read!() |> :erlang.binary_to_term()
      end)

    IO.puts("")
    IO.puts("Loaded #{length(entities)} entities...")
    IO.puts("")

    airports =
      entities
      |> Enum.filter(fn entity -> entity.type == :apt end)
      |> Map.new(fn airport ->
        {airport.landing_facility_site_number, NASR.Airport.new(airport)}
      end)

    airports =
      entities
      |> Enum.filter(fn entity -> entity.type == :apt_rwy end)
      |> Enum.reduce(airports, fn runway, airports ->
        Map.update(airports, runway.landing_facility_site_number, %{}, fn airport ->
          Map.update!(airport, :runways, &[NASR.Runway.new(runway) | &1])
        end)
      end)

    airports =
      entities
      |> Enum.filter(fn entity -> entity.type == :apt_rmk end)
      |> Enum.reduce(airports, fn remark, airports ->
        Map.update(airports, remark.landing_facility_site_number, %{}, fn airport ->
          Map.update!(airport, :remarks, &[remark.remark_text | &1])
        end)
      end)

    airports =
      entities
      |> Enum.filter(fn entity -> entity.type == :apt_att end)
      |> Enum.reduce(airports, fn attendence, airports ->
        Map.update(airports, attendence.landing_facility_site_number, %{}, fn airport ->
          Map.update!(airport, :attendances, &[attendence.airport_attendance_schedule_when_minimum | &1])
        end)
      end)

    wx_stations =
      entities
      |> Enum.filter(fn entity -> entity.type == :awos1 end)
      |> Map.new(fn entity -> {entity.wx_sensor_ident, NASR.WxStation.new(entity)} end)

    wx_stations =
      entities
      |> Enum.filter(fn entity -> entity.type == :awos2 end)
      |> Enum.reduce(wx_stations, fn remark, stations ->
        Map.update!(stations, remark.wx_sensor_ident, fn station ->
          Map.update!(station, :remarks, &[remark.asos_awos_remarks_free_form_text | &1])
        end)
      end)
      |> Map.values()

    airports =
      Enum.reduce(wx_stations, airports, fn station, airports ->
        Map.update(airports, station.landing_facility_site_number, %{}, fn airport ->
          Map.put(airport, :wx_station, station)
        end)
      end)

    IO.inspect(Enum.find(airports, fn {_, airport} -> airport.id == "DTO" end))

    IO.puts("Writing #{map_size(airports)} airports...")
  end
end
