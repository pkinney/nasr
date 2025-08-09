defmodule NASR.Entities.TowerSatelliteAirportData do
  @moduledoc "Entity struct for TWR7 (SATELLITE AIRPORT DATA) records"
  import NASR.Utils

  defstruct [
    :record_type_indicator,
    :terminal_communications_facility_identifier,
    :satellite_frequency,
    :satellite_airport_location_identifier,
    :satellite_airport_name
  ]

  @type t() :: %__MODULE__{
    record_type_indicator: String.t() | nil,
    terminal_communications_facility_identifier: String.t() | nil,
    satellite_frequency: String.t() | nil,
    satellite_airport_location_identifier: String.t() | nil,
    satellite_airport_name: String.t() | nil
  }

  @spec new(map()) :: t()
  def new(entry) do
    %__MODULE__{
      record_type_indicator: entry.record_identifier,
      terminal_communications_facility_identifier: entry.terminal_communications_facility_identifier,
      satellite_frequency: entry.satellite_frequency_ex_126_1_not_truncated,
      satellite_airport_location_identifier: entry.satellite_airport_location_identifier,
      satellite_airport_name: entry.satellite_arpt_name
    }
  end
end