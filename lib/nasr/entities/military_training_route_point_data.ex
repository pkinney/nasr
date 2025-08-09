defmodule NASR.Entities.MilitaryTrainingRoutePointData do
  @moduledoc "Entity struct for MTR5 (ROUTE POINT DATA) records"
  import NASR.Utils

  defstruct [
    :record_type_indicator,
    :route_type,
    :route_identifier,
    :point_sequence_number,
    :latitude_formatted,
    :latitude_seconds,
    :longitude_formatted,
    :longitude_seconds,
    :navaid_identifier,
    :navaid_radial,
    :navaid_distance,
    :point_description_text,
    :sort_sequence_number
  ]

  @type t() :: %__MODULE__{
    record_type_indicator: String.t() | nil,
    route_type: :ifr | :vfr | nil,
    route_identifier: integer() | nil,
    point_sequence_number: integer() | nil,
    latitude_formatted: String.t() | nil,
    latitude_seconds: String.t() | nil,
    longitude_formatted: String.t() | nil,
    longitude_seconds: String.t() | nil,
    navaid_identifier: String.t() | nil,
    navaid_radial: integer() | nil,
    navaid_distance: float() | nil,
    point_description_text: String.t() | nil,
    sort_sequence_number: integer() | nil
  }

  @spec new(map()) :: t()
  def new(entry) do
    %__MODULE__{
      record_type_indicator: entry.record_type_indicator,
      route_type: convert_route_type(entry.route_type),
      route_identifier: safe_str_to_int(entry.route_identifier),
      point_sequence_number: entry.route_point_id_a_b_c_etc,
      latitude_formatted: entry.latitude_location_of_point,
      latitude_seconds: entry.latitude_location_of_point,
      longitude_formatted: entry.longitude_location_of_point,
      longitude_seconds: entry.longitude_location_of_point,
      navaid_identifier: entry.ident_of_related_navaid,
      navaid_radial: safe_str_to_int(entry.bearing_of_navaid_from_point),
      navaid_distance: safe_str_to_float(entry.distance_of_navaid_from_point),
      point_description_text: entry.segment_description_text_leading_up_to_the_point,
      sort_sequence_number: safe_str_to_int(entry.record_sort_sequence_number)
    }
  end

  defp convert_route_type("IR"), do: :ifr
  defp convert_route_type("VR"), do: :vfr
  defp convert_route_type(_), do: nil
end