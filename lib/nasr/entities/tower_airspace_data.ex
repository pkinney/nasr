defmodule NASR.Entities.TowerAirspaceData do
  @moduledoc "Entity struct for TWR8 (CLASS B/C/D/E AIRSPACE AND AIRSPACE HOURS DATA) records"
  import NASR.Utils

  defstruct [
    :record_type_indicator,
    :terminal_communications_facility_identifier,
    :class_b_airspace,
    :class_c_airspace,
    :class_d_airspace,
    :class_e_airspace,
    :airspace_hours
  ]

  @type t() :: %__MODULE__{
    record_type_indicator: String.t() | nil,
    terminal_communications_facility_identifier: String.t() | nil,
    class_b_airspace: boolean() | nil,
    class_c_airspace: boolean() | nil,
    class_d_airspace: boolean() | nil,
    class_e_airspace: boolean() | nil,
    airspace_hours: String.t() | nil
  }

  @spec new(map()) :: t()
  def new(entry) do
    %__MODULE__{
      record_type_indicator: entry.record_identifier,
      terminal_communications_facility_identifier: entry.terminal_communications_facility_identifier,
      class_b_airspace: convert_yn(entry.class_b_airspace),
      class_c_airspace: convert_yn(entry.class_c_airspace),
      class_d_airspace: convert_yn(entry.class_d_airspace),
      class_e_airspace: convert_yn(entry.class_e_airspace),
      airspace_hours: entry.airspace_hours
    }
  end
end