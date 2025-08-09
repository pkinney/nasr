defmodule NASR.Entities.NavigationAidRemarks do
  @moduledoc "Entity struct for NAV2 (NAVAID REMARKS) records"
  import NASR.Utils

  defstruct [
    :record_type_indicator,
    :navaid_facility_identifier,
    :navaid_facility_type,
    :navaid_remarks
  ]

  @type t() :: %__MODULE__{
    record_type_indicator: String.t() | nil,
    navaid_facility_identifier: String.t() | nil,
    navaid_facility_type: String.t() | nil,
    navaid_remarks: String.t() | nil
  }

  @spec new(map()) :: t()
  def new(entry) do
    %__MODULE__{
      record_type_indicator: entry.record_type_indicator,
      navaid_facility_identifier: entry.navaid_facility_identifier,
      navaid_facility_type: entry.navaid_facitity_type_ex_vor_dme,
      navaid_remarks: entry.navaid_remarks_free_form_text
    }
  end
end