defmodule NASR.Entities.TowerRadarData do
  @moduledoc "Entity struct for TWR5 (INDICATION OF RADAR OR TYPE OF RADAR DATA) records"
  import NASR.Utils

  defstruct [
    :record_type_indicator,
    :terminal_communications_facility_identifier,
    :radar_or_non_radar_primary_approach_call,
    :radar_approach_control_hours,
    :radar_departure_control_hours
  ]

  @type t() :: %__MODULE__{
    record_type_indicator: String.t() | nil,
    terminal_communications_facility_identifier: String.t() | nil,
    radar_or_non_radar_primary_approach_call: String.t() | nil,
    radar_approach_control_hours: String.t() | nil,
    radar_departure_control_hours: String.t() | nil
  }

  @spec new(map()) :: t()
  def new(entry) do
    %__MODULE__{
      record_type_indicator: entry.record_identifier,
      terminal_communications_facility_identifier: entry.terminal_communications_facility_identifier,
      radar_or_non_radar_primary_approach_call: entry.radar_or_non_radar_primary_approach_call,
      radar_approach_control_hours: entry.radar_hours_of_operation_1_ex_0700_2300,
      radar_departure_control_hours: entry.radar_hours_of_operation_2
    }
  end
end