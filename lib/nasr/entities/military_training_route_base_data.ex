defmodule NASR.Entities.MilitaryTrainingRouteBaseData do
  @moduledoc "Entity struct for MTR1 (BASE ROUTE DATA) records"
  import NASR.Utils

  defstruct [
    :record_type_indicator,
    :route_type,
    :route_identifier,
    :publication_effective_date,
    :faa_region_code,
    :artcc_identifiers,
    :fss_identifiers,
    :times_of_use_text,
    :sort_sequence_number
  ]

  @type t() :: %__MODULE__{
    record_type_indicator: String.t() | nil,
    route_type: :ifr | :vfr | nil,
    route_identifier: integer() | nil,
    publication_effective_date: Date.t() | nil,
    faa_region_code: String.t() | nil,
    artcc_identifiers: [String.t()] | nil,
    fss_identifiers: [String.t()] | nil,
    times_of_use_text: String.t() | nil,
    sort_sequence_number: integer() | nil
  }

  @spec new(map()) :: t()
  def new(entry) do
    %__MODULE__{
      record_type_indicator: entry.record_type_indicator,
      route_type: convert_route_type(entry.route_type),
      route_identifier: safe_str_to_int(entry.route_identifier),
      publication_effective_date: parse_date_yyyymmdd(entry.publication_effective_date),
      faa_region_code: entry.faa_region_code,
      artcc_identifiers: parse_identifier_list(entry.artcc_identifiers, 4),
      fss_identifiers: parse_identifier_list(entry.fss_identifiers, 4),
      times_of_use_text: entry.times_of_use_text,
      sort_sequence_number: safe_str_to_int(entry.sort_sequence_number)
    }
  end

  defp convert_route_type("IR"), do: :ifr
  defp convert_route_type("VR"), do: :vfr
  defp convert_route_type(_), do: nil

  defp parse_date_yyyymmdd(""), do: nil
  defp parse_date_yyyymmdd(nil), do: nil
  defp parse_date_yyyymmdd(date_str) when is_binary(date_str) and byte_size(date_str) == 8 do
    year = String.slice(date_str, 0, 4)
    month = String.slice(date_str, 4, 2)
    day = String.slice(date_str, 6, 2)
    parse_date("#{month}/#{day}/#{year}")
  end
  defp parse_date_yyyymmdd(_), do: nil

  defp parse_identifier_list(nil, _), do: []
  defp parse_identifier_list("", _), do: []
  defp parse_identifier_list(str, chunk_size) when is_binary(str) do
    str
    |> String.trim()
    |> String.graphemes()
    |> Enum.chunk_every(chunk_size)
    |> Enum.map(&Enum.join/1)
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
  end
end