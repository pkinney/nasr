defmodule NASR.Entities.FixRemarks do
  @moduledoc "Entity struct for FIX4 (REMARKS TEXT) records"
  import NASR.Utils

  defstruct [
    :record_type_indicator,
    :fix_identifier,
    :fix_state_name,
    :icao_region_code,
    :remark_text
  ]

  @type t() :: %__MODULE__{
    record_type_indicator: String.t() | nil,
    fix_identifier: String.t() | nil,
    fix_state_name: String.t() | nil,
    icao_region_code: String.t() | nil,
    remark_text: String.t() | nil
  }

  @spec new(map()) :: t()
  def new(entry) do
    %__MODULE__{
      record_type_indicator: entry.record_type_indicator,
      fix_identifier: entry.fix_identifier_record_identifier,
      fix_state_name: entry.fix_state_name_record_identifier,
      icao_region_code: entry.icao_region_code_record_identifier,
      remark_text: entry.remark_text
    }
  end
end