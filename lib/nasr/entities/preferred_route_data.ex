defmodule NASR.Entities.PreferredRouteData do
  @moduledoc "Entity struct for PFR1 (BASE ROUTE DATA) records"
  import NASR.Utils
  
  defstruct [
    :record_type_indicator,
    :origin_facility_location_identifier,
    :destination_facility_location_identifier,
    :type_of_preferred_route_code,
    :route_identifier_sequence_number,
    :type_of_preferred_route_description,
    :preferred_route_area_description,
    :preferred_route_altitude_description,
    :aircraft_allowed_limitations_description,
    :effective_hours_gmt_description_1,
    :effective_hours_gmt_description_2,
    :effective_hours_gmt_description_3,
    :route_direction_limitations_description,
    :nar_type_common_non_common,
    :designator,
    :destination_city
  ]
  
  @type t() :: %__MODULE__{
    record_type_indicator: String.t() | nil,
    origin_facility_location_identifier: String.t() | nil,
    destination_facility_location_identifier: String.t() | nil,
    type_of_preferred_route_code: String.t() | nil,
    route_identifier_sequence_number: String.t() | nil,
    type_of_preferred_route_description: String.t() | nil,
    preferred_route_area_description: String.t() | nil,
    preferred_route_altitude_description: String.t() | nil,
    aircraft_allowed_limitations_description: String.t() | nil,
    effective_hours_gmt_description_1: String.t() | nil,
    effective_hours_gmt_description_2: String.t() | nil,
    effective_hours_gmt_description_3: String.t() | nil,
    route_direction_limitations_description: String.t() | nil,
    nar_type_common_non_common: String.t() | nil,
    designator: String.t() | nil,
    destination_city: String.t() | nil
  }
  
  @spec new(map()) :: t()
  def new(entry) do
    %__MODULE__{
      record_type_indicator: entry.record_type_indicator,
      origin_facility_location_identifier: entry.origin_facility_location_identifier,
      destination_facility_location_identifier: entry.destination_facility_location_identifier,
      type_of_preferred_route_code: entry.type_of_preferred_route_code,
      route_identifier_sequence_number: entry.route_identifier_sequence_number_1_99,
      type_of_preferred_route_description: entry.type_of_preferred_route_description,
      preferred_route_area_description: entry.preferred_route_area_description,
      preferred_route_altitude_description: entry.preferred_route_altitude_description,
      aircraft_allowed_limitations_description: entry.aircraft_allowed_limitations_description,
      effective_hours_gmt_description_1: entry.effective_hours_gmt_description_1,
      effective_hours_gmt_description_2: entry.effective_hours_gmt_description_2,
      effective_hours_gmt_description_3: entry.effective_hours_gmt_description_3,
      route_direction_limitations_description: entry.route_direction_limitations_description,
      nar_type_common_non_common: entry.nar_type_common_non_common,
      designator: entry.designator,
      destination_city: entry.destination_city
    }
  end
end