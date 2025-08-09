defmodule NASR.Entities.NavigationAidFanMarkers do
  @moduledoc "Entity struct for NAV5 (FAN MARKERS ASSOCIATED WITH NAVAID) records"
  import NASR.Utils

  defstruct [
    :record_type_indicator,
    :navaid_facility_identifier,
    :navaid_facility_type,
    :fan_marker_data
  ]

  @type t() :: %__MODULE__{
    record_type_indicator: String.t() | nil,
    navaid_facility_identifier: String.t() | nil,
    navaid_facility_type: String.t() | nil,
    fan_marker_data: String.t() | nil
  }

  @spec new(map()) :: t()
  def new(entry) do
    %__MODULE__{
      record_type_indicator: entry.record_type_indicator,
      navaid_facility_identifier: entry.navaid_facility_identifier,
      navaid_facility_type: entry.navaid_facitity_type_ex_vor_dme,
      fan_marker_data: entry.fan_marker_information_text
    }
  end
end