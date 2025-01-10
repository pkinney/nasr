defmodule Mix.Tasks.Nasr.Analyze do
  @moduledoc "analyze data files gathered from NASR"
  use Mix.Task

  @impl Mix.Task
  def run(args) do
    Mix.Task.run("compile")
    __MODULE__.compiled_run(args)
  end

  def compiled_run([]) do
    dir = File.cwd!()

    groups =
      dir
      |> Path.join("output")
      |> File.ls!()
      |> Enum.filter(fn file -> String.ends_with?(file, ".data") end)
      |> Enum.sort()
      |> Enum.map(fn file ->
        IO.puts("Loading #{file}...")
        {file, [dir, "output", file] |> Path.join() |> File.read!() |> :erlang.binary_to_term()}
      end)

    group_types =
      Enum.map(groups, fn {group, entities} ->
        types = entities |> Enum.map(&Map.get(&1, :type)) |> Enum.uniq()
        {group, types}
      end)

    Enum.each(group_types, fn {group, types} ->
      IO.puts("#{group} has #{length(types)} types: [#{Enum.join(Enum.map(types, &inspect/1), ", ")}]")

      group_types
      |> Enum.filter(fn {g, _} -> g != group end)
      |> Enum.each(fn {g, t} ->
        if Enum.any?(t, &(&1 in types)) do
          IO.puts("  #{g} has some of the same types")
        end
      end)
    end)
  end
end
