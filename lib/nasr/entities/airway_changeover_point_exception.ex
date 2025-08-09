defmodule NASR.Entities.AirwayChangeoverPointException do
  @moduledoc "Entity struct for AWY5 (CHANGEOVER POINT EXCEPTION TEXT) records"
  import NASR.Utils

  defstruct [
    :record_type_indicator,
    :airway_designation,
    :airway_type,
    :airway_point_sequence_number,
    :changeover_point_exception_text,
    :record_sort_sequence_number
  ]

  @type t() :: %__MODULE__{
    record_type_indicator: String.t() | nil,
    airway_designation: String.t() | nil,
    airway_type: String.t() | nil,
    airway_point_sequence_number: integer() | nil,
    changeover_point_exception_text: String.t() | nil,
    record_sort_sequence_number: integer() | nil
  }

  @spec new(map()) :: t()
  def new(entry) do
    %__MODULE__{
      record_type_indicator: entry.record_type_indicator,
      airway_designation: entry.airway_designation,
      airway_type: entry.airway_type,
      airway_point_sequence_number: safe_str_to_int(entry.airway_point_sequence_number),
      changeover_point_exception_text: entry.changeover_point_exception_text,
      record_sort_sequence_number: safe_str_to_int(entry.record_sort_sequence_number)
    }
  end
end