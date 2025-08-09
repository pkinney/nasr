defmodule NASR.Entities.TowerRemarks do
  @moduledoc "Entity struct for TWR6 (TERMINAL COMMUNICATIONS FACILITY REMARKS DATA) records"
  import NASR.Utils

  defstruct [
    :record_type_indicator,
    :terminal_communications_facility_identifier,
    :tower_element_number,
    :tower_remarks
  ]

  @type t() :: %__MODULE__{
    record_type_indicator: String.t() | nil,
    terminal_communications_facility_identifier: String.t() | nil,
    tower_element_number: String.t() | nil,
    tower_remarks: String.t() | nil
  }

  @spec new(map()) :: t()
  def new(entry) do
    %__MODULE__{
      record_type_indicator: entry.record_identifier,
      terminal_communications_facility_identifier: entry.terminal_communications_facility_identifier,
      tower_element_number: entry.tower_element_number,
      tower_remarks: entry.tower_remark_text
    }
  end
end