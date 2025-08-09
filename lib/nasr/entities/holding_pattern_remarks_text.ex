defmodule NASR.Entities.HoldingPatternRemarksText do
  @moduledoc "Entity struct for HP4 records"
  import NASR.Utils

  defstruct [
    :record_type_indicator,
    :field_label,
    :holding_pattern_name,
    :pattern_number,
    :remarks,
    :type,
    :raw_data
  ]

  @type t() :: %__MODULE__{
          record_type_indicator: String.t() | nil,
          field_label: String.t() | nil,
          holding_pattern_name: String.t() | nil,
          pattern_number: String.t() | nil,
          remarks: String.t() | nil,
          type: atom(),
          raw_data: map() | nil
        }

  @spec new(map()) :: t()
  def new(entry) do
    %__MODULE__{
      record_type_indicator: entry.record_type_indicator,
      field_label: entry.field_label,
      holding_pattern_name: entry.holding_pattern_name_navaid_name_facility_type_st,
      pattern_number: entry.pattern_number_to_uniquely_identify_holding_pattern,
      remarks: entry.descriptive_remarks,
      type: entry.type,
      raw_data: entry
    }
  end
end
