defmodule NASR.Entities.AirwayPointRemarks do
  @moduledoc "Entity struct for AWY4 (AIRWAY POINT REMARKS TEXT) records"
  import NASR.Utils

  defstruct [
    :record_type_indicator,
    :airway_designation,
    :airway_type,
    :airway_point_sequence_number,
    :airway_remarks_text,
    :record_sort_sequence_number
  ]

  @type t() :: %__MODULE__{
    record_type_indicator: String.t() | nil,
    airway_designation: String.t() | nil,
    airway_type: String.t() | nil,
    airway_point_sequence_number: integer() | nil,
    airway_remarks_text: String.t() | nil,
    record_sort_sequence_number: integer() | nil
  }

  @spec new(map()) :: t()
  def new(entry) do
    %__MODULE__{
      record_type_indicator: entry.record_type_indicator,
      airway_designation: entry.airway_designation,
      airway_type: entry.airway_type,
      airway_point_sequence_number: safe_str_to_int(entry.airway_point_sequence_number),
      airway_remarks_text: entry.airway_remarks_text,
      record_sort_sequence_number: safe_str_to_int(entry.record_sort_sequence_number)
    }
  end
end