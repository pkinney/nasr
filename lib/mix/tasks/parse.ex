defmodule Mix.Tasks.Nasr.Parse do
  @moduledoc "tasks for parsing NASR files and generating elixir terms from the raw data"
  use Mix.Task

  @impl Mix.Task
  def run(args) do
    Mix.Task.run("compile")
    __MODULE__.compiled_run(args)
  end

  def compiled_run([]) do
    dir = File.cwd!()
    zip_file = get_zip(dir)

    NASR.list_layouts() |> Enum.sort_by(&elem(&1, 0)) |> Enum.each(&do_parse(&1, zip_file))
  end

  def compiled_run([cat]) do
    dir = File.cwd!()
    zip_file = get_zip(dir)
    NASR.list_layouts() |> Enum.find(fn {c, _, _} -> String.downcase(cat) == String.downcase(c) end) |> do_parse(zip_file)
  end

  def do_parse({cat, layout_file, data_file}, zip_file) do
    IO.puts("Parsing #{cat} (data_file) from #{zip_file}...")
    dir = File.cwd!()

    :ok = File.mkdir_p(Path.join([dir, "output"]))
    layout = NASR.Layout.load(layout_file)
    entities = NASR.load(zip_file, data_file, layout)
    :ok = File.write!(Path.join([dir, "output", "#{cat}.data"]), :erlang.term_to_binary(entities))
  end

  defp get_zip(dir) do
    dir
    |> Path.join("data")
    |> File.ls!()
    |> Enum.find(fn file -> String.ends_with?(file, ".zip") end)
    |> case do
      nil ->
        raise "no NARS zip file found in the data directory. Download the latest NASR zip file from https://www.faa.gov/air_traffic/flight_info/aeronav/aero_data/NASR_Subscription/"

      file ->
        Path.join([dir, "data", file])
    end
  end
end
