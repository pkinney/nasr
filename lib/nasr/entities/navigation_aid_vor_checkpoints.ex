defmodule NASR.Entities.NavigationAidVORCheckpoints do
  @moduledoc "Entity struct for NAV6 (VOR RECEIVER CHECKPOINTS ASSOCIATED WITH NAVAID) records"
  import NASR.Utils

  defstruct [
    :record_type_indicator,
    :navaid_facility_identifier,
    :navaid_facility_type,
    :checkpoint_data
  ]

  @type t() :: %__MODULE__{
    record_type_indicator: String.t() | nil,
    navaid_facility_identifier: String.t() | nil,
    navaid_facility_type: String.t() | nil,
    checkpoint_data: String.t() | nil
  }

  @spec new(map()) :: t()
  def new(entry) do
    %__MODULE__{
      record_type_indicator: entry.record_type_indicator,
      navaid_facility_identifier: entry.navaid_facility_identifier,
      navaid_facility_type: entry.navaid_facitity_type_ex_vor_dme,
      checkpoint_data: entry.vor_receiver_checkpoint_information_text
    }
  end
end