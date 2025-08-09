defmodule Mix.Tasks.Nasr.Stats do
  @moduledoc "analyze data files gathered from NASR"
  use Mix.Task

  require Logger

  @impl Mix.Task
  def run(args) do
    Mix.Task.run("compile")
    __MODULE__.compiled_run(args)
  end

  def compiled_run([]) do
    Application.ensure_all_started(:nasr)
    IO.puts("Collecting statistics from NASR data...")

    # Use stream_raw to get all entries and count by type
    type_counts =
      Enum.reduce(NASR.stream_raw(), %{}, fn entity, acc ->
        Map.update(acc, entity.type, 1, &(&1 + 1))
      end)

    # Sort by type name and print results
    IO.puts("\nEntry type counts:")
    IO.puts("==================")

    type_counts
    |> Enum.sort_by(fn {type, _count} -> to_string(type) end)
    |> Enum.each(fn {type, count} ->
      IO.puts("  #{type |> to_string() |> String.upcase()}: #{count}")
    end)

    total = Enum.sum(Map.values(type_counts))
    IO.puts("==================")
    IO.puts("Total entries: #{total}")
  end
end
