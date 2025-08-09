defmodule NASR.Entities.TowerCommunicationsFrequencies do
  @moduledoc "Entity struct for TWR3 (COMMUNICATIONS FREQUENCIES AND USE DATA) records"
  import NASR.Utils

  defstruct [
    :record_type_indicator,
    :terminal_communications_facility_identifier,
    :frequency_use_data,
    :transmitter_receiver_channel,
    :frequency_special_usage_text
  ]

  @type t() :: %__MODULE__{
    record_type_indicator: String.t() | nil,
    terminal_communications_facility_identifier: String.t() | nil,
    frequency_use_data: String.t() | nil,
    transmitter_receiver_channel: String.t() | nil,
    frequency_special_usage_text: String.t() | nil
  }

  @spec new(map()) :: t()
  def new(entry) do
    %__MODULE__{
      record_type_indicator: entry.record_identifier,
      terminal_communications_facility_identifier: entry.terminal_communications_facility_identifier,
      frequency_use_data: entry.frequency_use_data,
      transmitter_receiver_channel: entry.transmitter_receiver_channel,
      frequency_special_usage_text: entry.frequency_special_usage_text
    }
  end
end