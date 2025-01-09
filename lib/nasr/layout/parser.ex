defmodule NASR.Layout.Parser do
  @moduledoc false
  def decode_line(line) do
    cond do
      String.match?(line, ~r/^\[\w+\]/) ->
        %{"type" => type} =
          Regex.named_captures(~r/^\[(?<type>(\w+))\]/, line)

        {:single_type, String.to_atom(type)}

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

      String.match?(line, ~r/[L|R]\s+(AN|N)\s*\d+\s+\d+/) ->
        %{"just" => just, "type" => type, "len" => len, "start" => start, "rest" => rest} =
          Regex.named_captures(
            ~r/^(?<just>(L|R))\s+(?<type>(AN|N))\s*(?<len>(\d+))\s+(?<start>(\d+))\s+[^\s\\]+\s+(?<rest>(.*))$/,
            line
          )

        len = String.to_integer(len)
        start = String.to_integer(start)

        name =
          rest
          |> strip_non_utf()
          |> String.replace("-", "_")
          |> String.replace(~r/[^\w\s]+/, " ")
          |> String.trim()
          |> String.replace(~r/[\s]+/, "_")
          |> String.downcase()
          |> String.to_atom()

        {:spec, just, type, len, start, name}

      true ->
        nil
    end
  end

  defp strip_non_utf(str, acc \\ [])
  defp strip_non_utf(<<x::utf8>> <> rest, acc), do: strip_non_utf(rest, [x | acc])
  defp strip_non_utf(<<_>> <> rest, acc), do: strip_non_utf(rest, acc)

  defp strip_non_utf("", acc) do
    acc
    |> :lists.reverse()
    |> List.to_string()
  end
end
