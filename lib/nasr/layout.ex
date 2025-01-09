defmodule NASR.Layout do
  @moduledoc false
  def load(layout_file) do
    layout_file
    |> File.stream!(:line)
    |> Stream.map(fn line ->
      String.trim_trailing(line, "\r\n")
    end)
    |> Stream.map(fn line -> __MODULE__.Parser.decode_line(line) end)
    |> Stream.reject(&is_nil(&1))
    |> Enum.to_list()
    |> Enum.reduce({%{types: %{}, fields: []}, nil}, fn
      {:effective_date, date}, {acc, heading} ->
        {Map.put(acc, :effective_date, date), heading}

      {:length, l}, {acc, heading} ->
        {Map.put(acc, :length, l), heading}

      {:type, key, type}, {acc, _} ->
        {Map.put(acc, :types, Map.put(acc.types, key, type)), type}

      {:single_type, type}, {acc, _} ->
        {Map.put(acc, :types, Map.put(acc.types, "", type)), type}

      {:spec, just, type, len, start, name}, {acc, heading} ->
        {Map.put(
           acc,
           :fields,
           acc.fields ++ [{heading, just, type, len, start, name}]
         ), heading}
    end)
    |> elem(0)
    |> then(fn layout ->
      l = layout.types |> Map.keys() |> Enum.map(&String.length/1) |> Enum.max()
      Map.put(layout, :key_length, l)
    end)
  end
end
