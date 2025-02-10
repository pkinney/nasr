defmodule NASR.Server do
  @moduledoc false
  use GenServer

  require Logger

  @spec start_link(keyword()) :: GenServer.on_start()
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  # TODO: get/list functions

  @impl true
  def init(:ok) do
    Logger.info("[NASR] Starting server...")
    files = list_data_files()

    if files == [] do
      Logger.error("[NASR] No data files found. Run `mix nasr.parse` to parse the latest NASR data.")
      raise "no data files found"
    else
      Logger.debug("[NASR] Found #{length(files)} data files: #{Enum.join(files, ", ")}")
    end

    start = System.monotonic_time()

    :ets.new(:nasr, [:bag, :named_table, :public])

    count =
      files |> Enum.map(fn file -> Task.async(fn -> load_file(file) end) end) |> Task.await_many(:infinity) |> Enum.sum()

    duration = System.convert_time_unit(System.monotonic_time() - start, :native, :millisecond)

    Logger.debug("[NASR] Loaded #{count} entities in #{duration}ms...")

    {:ok, nil}
  end

  defp list_data_files do
    dir = File.cwd!()

    dir
    |> Path.join("output")
    |> File.ls!()
    |> Enum.filter(fn file -> String.ends_with?(file, ".data") end)
  end

  defp load_file(file) do
    Logger.debug("[NASR] Loading #{file}...")

    # tables =
    #   :ets.all() |> Enum.filter(&(is_atom(&1) and &1 |> Atom.to_string() |> String.starts_with?("nasr_"))) |> IO.inspect()

    count =
      [File.cwd!(), "output", file]
      |> Path.join()
      |> File.stream!(512 * 1024, [:read, :binary])
      |> TermStream.deserialize()
      |> Stream.each(fn entity -> :ets.insert(:nasr, {entity.type, entity}) end)
      |> Enum.count()

    Logger.debug("[NASR] Loaded #{count} entities from #{file}...")
    count
    # |> Stream.transform(tables, fn entity, tables ->
    #   table_name = String.to_atom("nasr_#{entity.type}")
    #
    #   unless table_name in tables do
    #     :ets.new(table_name, [:set, :named_table])
    #   end
    #
    #   :ets.insert(table_name, entity)
    #
    #   {[], [table_name | tables]}
    # end)
  end
end
