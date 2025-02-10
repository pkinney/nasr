defmodule Mix.Tasks.Nasr.FromUrl do
  @moduledoc "analyze data files gathered from NASR"
  use Mix.Task

  @impl Mix.Task
  def run(args) do
    Mix.Task.run("compile")
    __MODULE__.compiled_run(args)
  end

  def compiled_run([]) do
    url = "https://nfdc.faa.gov/webContent/28DaySub/28DaySubscription_Effective_2025-01-23.zip"
    Application.ensure_all_started(:req)
    Application.ensure_all_started(:briefly)

    # Application.ensure_all_started(:nasr)

    [url: url]
    |> NASR.stream_airports()
    |> Enum.each(&IO.inspect/1)
  end
end
