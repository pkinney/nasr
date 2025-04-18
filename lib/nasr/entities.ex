defmodule NASR.Entities do
  @moduledoc false

  def stream(zip_file, apt_file, layout) do
    zip_file
    |> Unzip.file_stream!(apt_file)
    |> Stream.map(fn c -> IO.iodata_to_binary(c) end)
    |> NimbleCSV.RFC4180.to_line_stream()
    |> Stream.map(fn line ->
      String.trim_trailing(line, "\r\n")
    end)
    |> Stream.map(fn line -> decode_line(line, layout) end)
    |> Stream.reject(&is_nil(&1))
  end

  def load(zip_file, apt_file, layout) do
    Enum.to_list(stream(zip_file, apt_file, layout))
  end

  defp decode_line(line, layout) do
    type_string = line |> String.slice(0, layout.key_length) |> String.trim()
    type = Map.get(layout.types, type_string)

    if type == nil do
      IO.puts("Unknown type #{inspect(type_string)} in line: #{line}")
    end

    layout.fields
    |> Enum.filter(fn {heading, _, _, _, _, _} -> heading == type end)
    |> Map.new(fn {_, just, type, len, start, key} -> {key, extract(line, {just, type, len, start})} end)
    |> Map.put(:type, type)
  end

  defp extract(line, {"L", "AN", len, start}) do
    line |> String.slice(start - 1, len) |> String.trim_trailing()
  end

  defp extract(line, {"R", "AN", len, start}) do
    line |> String.slice(start - 1, len) |> String.trim_leading()
  end

  defp extract(line, {"L", "N", len, start}) do
    line |> String.slice(start - 1, len) |> String.trim_trailing()
  end

  defp extract(line, {"R", "N", len, start}) do
    line |> String.slice(start - 1, len) |> String.trim_leading()
  end
end
