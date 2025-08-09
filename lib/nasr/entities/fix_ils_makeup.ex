defmodule NASR.Entities.FixILSMakeup do
  @moduledoc "Entity struct for FIX3 (FIX ILS MAKEUP TEXT) records"
  import NASR.Utils

  defstruct [
    :record_type_indicator,
    :fix_identifier,
    :fix_state_name,
    :icao_region_code,
    :ils_makeup_text
  ]

  @type t() :: %__MODULE__{
    record_type_indicator: String.t() | nil,
    fix_identifier: String.t() | nil,
    fix_state_name: String.t() | nil,
    icao_region_code: String.t() | nil,
    ils_makeup_text: String.t() | nil
  }

  @spec new(map()) :: t()
  def new(entry) do
    %__MODULE__{
      record_type_indicator: entry.record_type_indicator,
      fix_identifier: entry.record_identifier_fix_name,
      fix_state_name: entry.record_identifier_fix_state_name,
      icao_region_code: entry.icao_region_code,
      ils_makeup_text: entry."3_or_4_letter_ident_facility_type_direction_or_course"
    }
  end
end