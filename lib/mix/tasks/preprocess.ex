defmodule Mix.Tasks.Nasr.Preprocess do
  @moduledoc "parses the raw NASR data into Elixir terms and creates preprocessed files that speed up streaming"
  use Mix.Task

  @impl Mix.Task
  def run(args) do
    Mix.Task.run("compile")
    __MODULE__.compiled_run(args)
  end

  def compiled_run([]) do
    dir = File.cwd!()
    zip_file = get_zip(dir)

    NASR.list_layouts()
    |> Enum.sort_by(&elem(&1, 0))
    |> Enum.each(&do_parse(&1, zip_file))
  end

  def compiled_run([cat]) do
    dir = File.cwd!()
    zip_file = get_zip(dir)
    NASR.list_layouts() |> Enum.find(fn {c, _, _} -> String.downcase(cat) == String.downcase(c) end) |> do_parse(zip_file)
  end

  def do_parse({cat, layout_file, data_file}, zip_file) do
    IO.puts("Parsing #{cat} from #{zip_file}...")
    dir = File.cwd!()

    :ok = File.mkdir_p(Path.join([dir, "output"]))

    layout = NASR.Layout.load(layout_file)
    output = File.stream!(Path.join([dir, "output", "#{cat}.data"]), [:write, :binary])

    zip_file
    |> NASR.stream(data_file, layout)
    |> TermStream.serialize()
    |> Stream.into(output)
    |> Stream.run()

    IO.puts("  Done")
  end

  defp get_zip(dir) do
    dir
    |> Path.join("data")
    |> File.ls!()
    |> Enum.find(fn file -> String.starts_with?(file, "28DaySubscription") and String.ends_with?(file, ".zip") end)
    |> case do
      nil ->
        raise "no NARS zip file found in the data directory. Download the latest NASR zip file from https://www.faa.gov/air_traffic/flight_info/aeronav/aero_data/NASR_Subscription/"

      file ->
        Path.join([dir, "data", file])
    end
  end
end
