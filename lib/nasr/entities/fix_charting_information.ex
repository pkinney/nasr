defmodule NASR.Entities.FixChartingInformation do
  @moduledoc "Entity struct for FIX5 (CHARTING INFORMATION) records"
  import NASR.Utils

  defstruct [
    :record_type_indicator,
    :fix_identifier,
    :fix_state_name,
    :icao_region_code,
    :charting_information_text
  ]

  @type t() :: %__MODULE__{
    record_type_indicator: String.t() | nil,
    fix_identifier: String.t() | nil,
    fix_state_name: String.t() | nil,
    icao_region_code: String.t() | nil,
    charting_information_text: String.t() | nil
  }

  @spec new(map()) :: t()
  def new(entry) do
    %__MODULE__{
      record_type_indicator: entry.record_type_indicator,
      fix_identifier: entry.record_identifier_fix_name,
      fix_state_name: entry.record_identifier_fix_state_name,
      icao_region_code: entry.icao_region_code,
      charting_information_text: entry.chart_on_which_fix_is_to_be_depicted
    }
  end
end