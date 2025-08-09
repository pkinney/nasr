defmodule NASR.Entities.TowerSatelliteAirportServices do
  @moduledoc "Entity struct for TWR4 (SERVICES PROVIDED TO SATELLITE AIRPORT DATA) records"
  import NASR.Utils

  defstruct [
    :record_type_indicator,
    :terminal_communications_facility_identifier,
    :master_airport_services,
    :master_airport_location_identifier
  ]

  @type t() :: %__MODULE__{
    record_type_indicator: String.t() | nil,
    terminal_communications_facility_identifier: String.t() | nil,
    master_airport_services: String.t() | nil,
    master_airport_location_identifier: String.t() | nil
  }

  @spec new(map()) :: t()
  def new(entry) do
    %__MODULE__{
      record_type_indicator: entry.record_type_indicator,
      terminal_communications_facility_identifier: entry.terminal_communications_facility_identifier,
      master_airport_services: entry.master_airport_services,
      master_airport_location_identifier: entry.master_airport_location_identifier
    }
  end
end