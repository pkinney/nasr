defmodule NASR.Airport do
  @moduledoc false
  defstruct ~w(id
    type 
    name elevation nasr_site_number latitude longitude fuel_types runways remarks attendances ownership facility_use status ctaf
  landing_fee towered wx_station)a

  @type t() :: %__MODULE__{}

  @spec new(map()) :: t()
  def new(entry) do
    %__MODULE__{
      id: entry.location_identifier,
      type: landing_facility_type(entry.landing_facility_type),
      name: Recase.to_title(entry.official_facility_name),
      nasr_site_number: entry.landing_facility_site_number,
      latitude: NASR.convert_seconds_to_decimal(entry.airport_reference_point_longitude_seconds),
      longitude: NASR.convert_seconds_to_decimal(entry.airport_reference_point_latitude_seconds),
      elevation: NASR.safe_str_to_float(entry.airport_elevation_nearest_tenth_of_a_foot_msl),
      ownership: convert_ownership(entry.airport_ownership_type),
      facility_use: convert_facility_use(entry.facility_use),
      status: convert_airport_status_code(entry.airport_status_code),
      fuel_types: convert_fuel_types(entry.fuel_types_available_for_public_use_at_the),
      ctaf: entry.common_traffic_advisory_frequency_ctaf,
      landing_fee: NASR.convert_yn(entry.landing_fee_charged_to_non_commercial_users_of),
      towered: NASR.convert_yn(entry.air_traffic_control_tower_located_on_airport),
      runways: [],
      remarks: [],
      attendances: []
    }
  end

  defp landing_facility_type("AIRPORT"), do: :airport
  defp landing_facility_type("HELIPORT"), do: :heliport
  defp landing_facility_type("SEAPLANE BASE"), do: :seaplane_base
  defp landing_facility_type("GLIDERPORT"), do: :gliderport
  defp landing_facility_type("ULTRALIGHT"), do: :ultralight
  defp landing_facility_type("BALLOONPORT"), do: :balloonport

  defp convert_ownership("PU"), do: :public
  defp convert_ownership("PR"), do: :private
  defp convert_ownership("MA"), do: :air_force
  defp convert_ownership("MN"), do: :navy
  defp convert_ownership("MR"), do: :army
  defp convert_ownership("CG"), do: :coast_guard

  defp convert_facility_use("PU"), do: :public
  defp convert_facility_use("PR"), do: :private

  defp convert_airport_status_code("O"), do: :operational
  defp convert_airport_status_code("CI"), do: :closed_indefinitely
  defp convert_airport_status_code("CP"), do: :closed_permanently

  defp convert_fuel_types(<<fuel::binary-size(5)>> <> rest), do: [fuel | convert_fuel_types(rest)]
  defp convert_fuel_types(""), do: []
  defp convert_fuel_types(type), do: [type]
end
