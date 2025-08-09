defmodule NASR.Entities.AirwayPointDescription do
  @moduledoc "Entity struct for AWY2 (AIRWAY POINT DESCRIPTION) records"
  import NASR.Utils

  defstruct [
    :record_type_indicator,
    :airway_designation,
    :airway_type,
    :airway_point_sequence_number,
    :navaid_facility_identifier,
    :fix_identifier,
    :fix_state_name,
    :waypoint_description_code,
    :record_sort_sequence_number
  ]

  @type t() :: %__MODULE__{
    record_type_indicator: String.t() | nil,
    airway_designation: String.t() | nil,
    airway_type: String.t() | nil,
    airway_point_sequence_number: integer() | nil,
    navaid_facility_identifier: String.t() | nil,
    fix_identifier: String.t() | nil,
    fix_state_name: String.t() | nil,
    waypoint_description_code: String.t() | nil,
    record_sort_sequence_number: integer() | nil
  }

  @spec new(map()) :: t()
  def new(entry) do
    %__MODULE__{
      record_type_indicator: entry.record_type_indicator,
      airway_designation: entry.airway_designation,
      airway_type: entry.airway_type,
      airway_point_sequence_number: safe_str_to_int(entry.airway_point_sequence_number),
      navaid_facility_identifier: entry.navaid_identifier_ex_sts_hvr,
      fix_identifier: entry.navaid_facility_fix_name,
      fix_state_name: entry.navaid_facility_fix_state_p_o_code,
      waypoint_description_code: entry.fix_type___publication_category,
      record_sort_sequence_number: safe_str_to_int(entry.record_sort_sequence_number)
    }
  end
end