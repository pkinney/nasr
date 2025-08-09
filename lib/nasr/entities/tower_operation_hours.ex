defmodule NASR.Entities.TowerOperationHours do
  @moduledoc "Entity struct for TWR2 (OPERATION HOURS DATA) records"
  import NASR.Utils

  defstruct [
    :record_type_indicator,
    :terminal_communications_facility_identifier,
    :hours_of_operation_military,
    :hours_of_operation_all_day,
    :hours_of_operation_common_traffic_advisory
  ]

  @type t() :: %__MODULE__{
    record_type_indicator: String.t() | nil,
    terminal_communications_facility_identifier: String.t() | nil,
    hours_of_operation_military: String.t() | nil,
    hours_of_operation_all_day: String.t() | nil,
    hours_of_operation_common_traffic_advisory: String.t() | nil
  }

  @spec new(map()) :: t()
  def new(entry) do
    %__MODULE__{
      record_type_indicator: entry.record_type_indicator,
      terminal_communications_facility_identifier: entry.terminal_communications_facility_identifier,
      hours_of_operation_military: entry.hours_of_operation_military,
      hours_of_operation_all_day: entry.hours_of_operation_all_day,
      hours_of_operation_common_traffic_advisory: entry.hours_of_operation_common_traffic_advisory
    }
  end
end