defmodule Mix.Tasks.Nasr.Stats do
  @moduledoc "analyze data files gathered from NASR"
  use Mix.Task

  @impl Mix.Task
  def run(args) do
    Mix.Task.run("compile")
    __MODULE__.compiled_run(args)
  end

  def compiled_run([]) do
    zip = get_zip(File.cwd!())

    zip
    |> NASR.stream("APT")
    |> Stream.filter(fn
      %{type: :apt, location_identifier: "DTO"} -> true
      _ -> false
    end)
    |> Enum.to_list()
    |> IO.inspect()

    # zip
    # |> NASR.stream()
    # |> Stream.transform([], fn entity, acc ->
    #   if entity.type in acc do
    #     {[], acc}
    #   else
    #     IO.puts("Found new entity type: #{entity.type}")
    #     {[entity.type], [entity.type | acc]}
    #   end
    # end)
    # |> Enum.each(&IO.inspect/1)
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
