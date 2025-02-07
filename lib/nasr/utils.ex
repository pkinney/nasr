defmodule NASR.Utils do
  @moduledoc false
  def list_files(dir) do
    dir
    |> File.ls!()
    |> Enum.filter(fn file -> String.ends_with?(file, ".zip") end)
    |> Enum.map(fn file -> Path.join(dir, file) end)
  end

  def safe_str_to_int(""), do: nil

  def safe_str_to_int(str) do
    cond do
      String.match?(str, ~r/^\-?\d+$/) -> String.to_integer(str)
      String.match?(str, ~r/^\-?\d+\.\d+$/) -> str |> String.to_float() |> trunc()
      true -> nil
    end
  end

  def safe_str_to_float(""), do: nil

  def safe_str_to_float(str) do
    cond do
      String.match?(str, ~r/^\-?\d+$/) -> String.to_float(str)
      String.match?(str, ~r/^\-?\d+\.\d+$/) -> String.to_float(str)
      true -> nil
    end
  end

  def convert_seconds_to_decimal(seconds) do
    {seconds, dir} = Float.parse(seconds)
    deg = seconds / 3600.0

    case dir do
      "N" -> deg
      "S" -> -deg
      "E" -> deg
      "W" -> -deg
    end
  end

  def convert_dms_to_decimal(""), do: nil

  def convert_dms_to_decimal(str) do
    [deg, min, sec] = String.split(str, "-")
    deg = safe_str_to_int(deg)
    min = safe_str_to_int(min)

    {sec, dir} = Float.parse(sec)

    deg = deg + min / 60.0 + sec / 3600.0

    case dir do
      "N" -> deg
      "S" -> -deg
      "E" -> deg
      "W" -> -deg
    end
  end

  def convert_yn("Y"), do: true
  def convert_yn("N"), do: false
  def convert_yn(_), do: nil
end
