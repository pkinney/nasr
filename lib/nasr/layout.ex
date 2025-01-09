defmodule NASR.Layout do
  @moduledoc false
  def load(layout_file) do
    layout_file
    |> File.stream!(:line)
    |> Stream.map(fn line ->
      String.trim_trailing(line, "\r\n")
    end)
    |> Stream.map(fn line -> decode_field_spec(line) end)
    |> Stream.reject(&is_nil(&1))
    |> Enum.to_list()
    |> Enum.reduce({%{types: %{}, fields: []}, nil}, fn
      {:effective_date, date}, {acc, heading} ->
        {Map.put(acc, :effective_date, date), heading}

      {:length, l}, {acc, heading} ->
        {Map.put(acc, :length, l), heading}

      {:type, key, type}, {acc, _} ->
        {Map.put(acc, :types, Map.put(acc.types, key, type)), type}

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

  defp decode_field_spec(line) do
    cond do
      String.match?(line, ~r/^\[[\w ]+\|\w+\]/) ->
        %{"key" => key, "type" => type} =
          Regex.named_captures(~r/^\[(?<key>([\w ]+))\|(?<type>(\w+))\]/, line)

        {:type, key, String.to_atom(type)}

      String.starts_with?(line, "_date") ->
        date =
          line
          |> String.trim()
          |> String.split()
          |> List.last()

        {:effective_date, date}

      String.starts_with?(line, "_length") ->
        l =
          line
          |> String.trim()
          |> String.split()
          |> List.last()

        {:length, l}

      String.match?(line, ~r/[L|R] +(AN| N) +\d{4} +\d{5}/) ->
        [just, type, len, start, _ | rest] = String.split(line)
        len = String.to_integer(len)
        start = String.to_integer(start)

        name =
          rest
          |> Enum.join("_")
          |> String.downcase()
          |> String.replace(~r/[\(\)\.\/,']/, "")
          |> String.replace("-", "_")
          |> String.to_atom()

        {:spec, just, type, len, start, name}

      true ->
        nil
    end
  end
end
