defmodule NASR.Apt do
  @moduledoc false

  def load(zip_file, apt_file, layout) do
    zip_file
    |> Unzip.file_stream!(apt_file)
    |> Stream.map(fn c -> IO.iodata_to_binary(c) end)
    |> NimbleCSV.RFC4180.to_line_stream()
    |> Stream.map(fn line ->
      String.trim_trailing(line, "\r\n")
    end)
    |> Stream.map(fn line -> decode_line(line, layout) end)
    |> Stream.reject(&is_nil(&1))
    |> Enum.to_list()
    |> IO.inspect()
  end

  defp decode_line(line, layout) do
    type = String.slice(line, 0, layout.key_length)

    layout.fields
    |> Enum.filter(fn {heading, _, _, _, _, _} -> heading == Map.get(layout.types, type) end)
    |> Map.new(fn {_, just, type, len, start, key} -> {key, extract(line, {just, type, len, start})} end)
    |> Map.put(:type, Map.get(layout.types, type))
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
