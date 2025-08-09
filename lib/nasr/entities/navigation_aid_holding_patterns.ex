defmodule NASR.Entities.NavigationAidHoldingPatterns do
  @moduledoc "Entity struct for NAV4 (HOLDING PATTERNS (HPF) ASSOCIATED WITH NAVAID) records"
  import NASR.Utils

  defstruct [
    :record_type_indicator,
    :navaid_facility_identifier,
    :navaid_facility_type,
    :holding_pattern_data
  ]

  @type t() :: %__MODULE__{
    record_type_indicator: String.t() | nil,
    navaid_facility_identifier: String.t() | nil,
    navaid_facility_type: String.t() | nil,
    holding_pattern_data: String.t() | nil
  }

  @spec new(map()) :: t()
  def new(entry) do
    %__MODULE__{
      record_type_indicator: entry.record_type_indicator,
      navaid_facility_identifier: entry.navaid_facility_identifier,
      navaid_facility_type: entry.navaid_facitity_type_ex_vor_dme,
      holding_pattern_data: entry.holding_pattern_information_text
    }
  end
end