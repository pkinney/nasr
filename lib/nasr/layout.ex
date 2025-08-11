defmodule NASR.Layout do
  @moduledoc false
  require Logger

  def parse(text, category \\ "UNK") do
    text
    |> extract_elements()
    |> parse_elements()
    |> split_element_types(category)
  end

  def extract_elements(text) do
    text
    |> String.split("\n")
    |> Enum.map(fn line ->
      line |> String.trim_trailing("\r\n") |> String.trim_trailing("\r")
    end)
    |> Enum.filter(fn line ->
      String.trim(line) != ""
    end)
    |> Enum.chunk_while(
      {[], false},
      fn line, {acc, in_record?} ->
        cond do
          String.match?(line, ~r/^[L|R]\s+(AN|N)\s*\d+\s+\d+\s+/) ->
            # This line starts a new record
            if in_record? do
              {:cont, acc |> Enum.reverse() |> Enum.join("\n"), {[line], true}}
            else
              {:cont, {[line], true}}
            end

          String.match?(line, ~r/^\s+/) ->
            if in_record? do
              {:cont, {[line | acc], true}}
            else
              {:cont, {acc, false}}
            end

          true ->
            if in_record? do
              {:cont, acc |> Enum.reverse() |> Enum.join("\n"), {[], false}}
            else
              {:cont, {[], false}}
            end
        end
      end,
      fn
        {acc, true} ->
          # Process the chunk of lines that belong together
          {:cont, acc |> Enum.reverse() |> Enum.join("\n"), {acc, true}}

        {acc, false} ->
          {:cont, {acc, false}}
      end
    )
  end

  def parse_elements(element_texts) do
    element_texts
    |> Enum.map(fn text ->
      [first_line | other_lines] = String.split(text, "\n")

      ~r/^(?<just>(L|R))\s+(?<type>(AN|N))\s*(?<len>(\d+))\s+(?<start>(\d+))\s+(?<elem>([\w\d\/]+))\s+(?<rest>(.*))$/
      |> Regex.named_captures(first_line)
      |> case do
        %{"just" => just, "type" => type, "len" => len, "start" => start, "elem" => elem, "rest" => rest} ->
          len = String.to_integer(len)
          start = String.to_integer(start)

          # [[{index, _}] | _] = Regex.scan(~r/#{Regex.escape(rest)}/, text, return: :index)

          # other_lines =
          #   Enum.map(other_lines, fn line ->
          #     line = String.replace(line, "\t", "        ")
          #     String.slice(line, index, String.length(line) - index)
          #   end)

          description = Enum.join([rest] ++ other_lines, "\n")

          %{just: just, type: type, len: len, start: start, elem: elem, description: description, type?: start == 1}

        other ->
          Logger.warning("[#{__MODULE__}] Invalid element format: #{inspect(first_line)}")
          nil
      end
    end)
    |> Enum.reject(&is_nil/1)
  end

  def split_element_types(elements, category) do
    elements
    |> Enum.chunk_while(
      [],
      fn element, acc ->
        case element do
          %{start: 1} ->
            {:cont, Enum.reverse(acc), [element]}

          _ ->
            {:cont, [element | acc]}
        end
      end,
      fn acc -> {:cont, Enum.reverse(acc), []} end
    )
    |> Enum.filter(fn
      [] -> false
      _ -> true
    end)
    |> Enum.map(fn chunk ->
      case extract_type(chunk, category) do
        nil ->
          nil

        type ->
          Logger.info("[#{__MODULE__}] [Cat: #{category}] Found type: #{type} with #{length(chunk)} elements")
          {category, type, chunk}
      end
    end)
    |> Enum.reject(&is_nil/1)
    |> Enum.map(fn {cat, type, elements} ->
      {cat, type, coerce_elements(elements, cat, type)}
    end)
  end

  # defp extract_type([%{elem: "DLID"} | _], "WXL"), do: "WXL"
  # defp extract_type(_, "WXL"), do: nil

  # defp extract_type(_, "COM"), do: "COM"

  # defp extract_type(chunk, "LID") do
  #   if Enum.any?(chunk, fn element -> element.elem == "II2" end) do
  #     {nil, "LID1"}
  #   else
  #     "LID2"
  #   end
  # end

  defp extract_type(chunk, _) do
    first =
      Enum.find(chunk, fn element ->
        element.type?
      end)

    [_, line | _] = String.split(first.description, "\n")
    type_line = String.trim(line)
    [[type]] = Regex.scan(~r/^\w+/, type_line)
    type
  end

  defp coerce_elements(elements, _category, type) do
    none_regex = ~r/^(N\/?A)|(NONE)$/

    elements
    |> Enum.with_index()
    |> Enum.map(fn {element, index} ->
      cond do
        element.type? && Regex.match?(none_regex, element.elem) ->
          Map.put(element, :elem, "TYPE")

        element.elem == "DLID" ->
          element

        Regex.match?(none_regex, element.elem) ->
          Map.put(element, :elem, "#{type}_#{index}")

        true ->
          element
      end
    end)
  end
end
