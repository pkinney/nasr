defmodule NASR.Entities.FixNavaidMakeup do
  @moduledoc "Entity struct for FIX2 (FIX NAVAID MAKEUP TEXT) records"
  import NASR.Utils

  defstruct [
    :record_type_indicator,
    :fix_identifier,
    :fix_state_name,
    :icao_region_code,
    :navaid_makeup_text
  ]

  @type t() :: %__MODULE__{
    record_type_indicator: String.t() | nil,
    fix_identifier: String.t() | nil,
    fix_state_name: String.t() | nil,
    icao_region_code: String.t() | nil,
    navaid_makeup_text: String.t() | nil
  }

  @spec new(map()) :: t()
  def new(entry) do
    %__MODULE__{
      record_type_indicator: entry.record_type_indicator,
      fix_identifier: entry.record_identifier_fix_name,
      fix_state_name: entry.record_identifier_fix_state_name,
      icao_region_code: entry.icao_region_code,
      navaid_makeup_text: entry.location_identifier_facility_type_and_radial
    }
  end
end