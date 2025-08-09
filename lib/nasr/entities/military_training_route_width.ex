defmodule NASR.Entities.MilitaryTrainingRouteWidth do
  @moduledoc "Entity struct for MTR3 (ROUTE WIDTH DESCRIPTION TEXT) records"
  import NASR.Utils

  defstruct [
    :record_type_indicator,
    :route_type,
    :route_identifier,
    :route_width_description_text,
    :sort_sequence_number
  ]

  @type t() :: %__MODULE__{
    record_type_indicator: String.t() | nil,
    route_type: :ifr | :vfr | nil,
    route_identifier: integer() | nil,
    route_width_description_text: String.t() | nil,
    sort_sequence_number: integer() | nil
  }

  @spec new(map()) :: t()
  def new(entry) do
    %__MODULE__{
      record_type_indicator: entry.record_type_indicator,
      route_type: convert_route_type(entry.route_type),
      route_identifier: safe_str_to_int(entry.route_identifier),
      route_width_description_text: entry.route_width_description_text,
      sort_sequence_number: safe_str_to_int(entry.sort_sequence_number)
    }
  end

  defp convert_route_type("IR"), do: :ifr
  defp convert_route_type("VR"), do: :vfr
  defp convert_route_type(_), do: nil
end