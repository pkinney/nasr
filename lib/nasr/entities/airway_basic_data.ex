defmodule NASR.Entities.AirwayBasicData do
  @moduledoc "Entity struct for AWY1 (BASIC AND MINIMUM ENROUTE ALTITUDE (MEA) DATA FOR EACH AIRWAY POINT/SEGMENT) records"
  import NASR.Utils

  defstruct [
    :record_type_indicator,
    :airway_designation,
    :airway_type,
    :airway_point_sequence_number,
    :minimum_enroute_altitude,
    :maximum_authorized_altitude,
    :moca_minimum_obstruction_clearance_altitude,
    :changeover_distance,
    :rnp_format,
    :record_sort_sequence_number
  ]

  @type t() :: %__MODULE__{
    record_type_indicator: String.t() | nil,
    airway_designation: String.t() | nil,
    airway_type: String.t() | nil,
    airway_point_sequence_number: integer() | nil,
    minimum_enroute_altitude: integer() | nil,
    maximum_authorized_altitude: integer() | nil,
    moca_minimum_obstruction_clearance_altitude: integer() | nil,
    changeover_distance: integer() | nil,
    rnp_format: float() | nil,
    record_sort_sequence_number: integer() | nil
  }

  @spec new(map()) :: t()
  def new(entry) do
    %__MODULE__{
      record_type_indicator: entry.record_type_indicator,
      airway_designation: entry.reserved_next_mea_point_part95,
      airway_type: entry.airway_type,
      airway_point_sequence_number: safe_str_to_int(entry.airway_point_sequence_number),
      minimum_enroute_altitude: safe_str_to_int(entry.point_to_point_minimum_enroute_altitude_mea),
      maximum_authorized_altitude: safe_str_to_int(entry.point_to_point_maximum_authorized_altitude),
      moca_minimum_obstruction_clearance_altitude: safe_str_to_int(entry.point_to_point_minimum_obstruction_clearance),
      changeover_distance: safe_str_to_int(entry.distance_from_this_point_to_the_changeover),
      rnp_format: safe_str_to_float(entry.rnp_format_xx_xx),
      record_sort_sequence_number: safe_str_to_int(entry.record_sort_sequence_number)
    }
  end
end