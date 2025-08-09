defmodule NASR.Entities.TowerATISData do
  @moduledoc "Entity struct for TWR9 (AUTOMATIC TERMINAL INFORMATION SYSTEM (ATIS) DATA) records"
  import NASR.Utils

  defstruct [
    :record_type_indicator,
    :terminal_communications_facility_identifier,
    :atis_serial_number,
    :atis_hours_of_operation,
    :atis_frequency,
    :atis_phone_number
  ]

  @type t() :: %__MODULE__{
    record_type_indicator: String.t() | nil,
    terminal_communications_facility_identifier: String.t() | nil,
    atis_serial_number: integer() | nil,
    atis_hours_of_operation: String.t() | nil,
    atis_frequency: String.t() | nil,
    atis_phone_number: String.t() | nil
  }

  @spec new(map()) :: t()
  def new(entry) do
    %__MODULE__{
      record_type_indicator: entry.record_identifier,
      terminal_communications_facility_identifier: entry.terminal_communications_facility_identifier,
      atis_serial_number: safe_str_to_int(entry.atis_serial_number),
      atis_hours_of_operation: entry.atis_hours_of_operation,
      atis_frequency: entry.atis_frequency,
      atis_phone_number: entry.atis_phone_number
    }
  end
end