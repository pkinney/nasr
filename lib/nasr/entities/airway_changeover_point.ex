defmodule NASR.Entities.AirwayChangeoverPoint do
  @moduledoc "Entity struct for AWY3 (CHANGEOVER TO POINT DESCRIPTION - (NAVAIDS)) records"
  import NASR.Utils

  defstruct [
    :record_type_indicator,
    :airway_designation,
    :airway_type,
    :airway_point_sequence_number,
    :changeover_navaid_identifier,
    :changeover_navaid_type,
    :changeover_point_distance,
    :record_sort_sequence_number
  ]

  @type t() :: %__MODULE__{
    record_type_indicator: String.t() | nil,
    airway_designation: String.t() | nil,
    airway_type: String.t() | nil,
    airway_point_sequence_number: integer() | nil,
    changeover_navaid_identifier: String.t() | nil,
    changeover_navaid_type: String.t() | nil,
    changeover_point_distance: integer() | nil,
    record_sort_sequence_number: integer() | nil
  }

  @spec new(map()) :: t()
  def new(entry) do
    %__MODULE__{
      record_type_indicator: entry.record_type_indicator,
      airway_designation: entry.airway_designation,
      airway_type: entry.airway_type,
      airway_point_sequence_number: safe_str_to_int(entry.airway_point_sequence_number),
      changeover_navaid_identifier: entry.navaid_facility_name,
      changeover_navaid_type: entry.navaid_facility_type,
      changeover_point_distance: safe_str_to_int(entry.airway_point_sequence_number),
      record_sort_sequence_number: safe_str_to_int(entry.record_sort_sequence_number)
    }
  end
end