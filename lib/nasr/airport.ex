defmodule NASR.Airport do
  @moduledoc false
  import NASR.Utils

  defstruct ~w(code
    type 
    name
    elevation
    nasr_site_number 
    latitude 
    longitude 
    fuel_types 
    runways
    remarks 
    attendances
    ownership 
    facility_use
    status 
    ctaf
    landing_fee
    towered 
    wx_station 
    city 
    state 
    nasr_id
    airframe_repair_service
    powerplant_repair_service
    icao_code
    direction_from_city
    distance_from_city
    transient_storage_facilities
    other_airport_services
    activation_date
    lighting_schedule
    wind_indicator
    owners_phone_number
    manager
    manager_phone_number
    unicom
    sectional
    certification_type
    wx_stations
  )a

  @type t() :: %__MODULE__{}

  @spec new(map()) :: t()
  def new(entry) do
    %__MODULE__{
      code: entry.location_identifier,
      icao_code: entry.icao_identifier,
      type: landing_facility_type(entry.landing_facility_type),
      name: Recase.to_title(entry.official_facility_name),
      nasr_id: entry.landing_facility_site_number,
      latitude: convert_seconds_to_decimal(entry.airport_reference_point_latitude_seconds),
      longitude: convert_seconds_to_decimal(entry.airport_reference_point_longitude_seconds),
      elevation: safe_str_to_float(entry.airport_elevation_nearest_tenth_of_a_foot_msl),
      ownership: convert_ownership(entry.airport_ownership_type),
      facility_use: convert_facility_use(entry.facility_use),
      status: convert_airport_status_code(entry.airport_status_code),
      fuel_types: convert_fuel_types(entry.fuel_types_available_for_public_use_at_the),
      ctaf: entry.common_traffic_advisory_frequency_ctaf,
      landing_fee: convert_yn(entry.landing_fee_charged_to_non_commercial_users_of),
      towered: convert_yn(entry.air_traffic_control_tower_located_on_airport),
      city: Recase.to_title(entry.associated_city_name),
      state: entry.associated_state_post_office_code,
      airframe_repair_service: convert_repair_service(entry.airframe_repair_service_availability_type),
      powerplant_repair_service: convert_repair_service(entry.power_plant_engine_repair_availability_type),
      direction_from_city: entry.direction_of_airport_from_central_business,
      distance_from_city: entry.distance_from_central_business_district_of,
      transient_storage_facilities: convert_transient_storage_facilities(entry.transient_storage_facilities),
      other_airport_services: entry.other_airport_services_available,
      activation_date: convert_activation_date(entry.airport_activation_date_mm_yyyy),
      lighting_schedule: entry.airport_lighting_schedule,
      wind_indicator: convert_wind_indicator(entry.wind_indicator),
      owners_phone_number: entry.owner_s_phone_number,
      manager: entry.facility_manager_s_name,
      manager_phone_number: entry.manager_s_phone_number,
      unicom: entry.unicom_frequency_available_at_the_airport,
      sectional: entry.aeronautical_sectional_chart_on_which_facility,
      certification_type: entry.airport_arff_certification_type_and_date,
      runways: [],
      remarks: [],
      attendances: [],
      wx_stations: []
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

  defp convert_fuel_types(<<fuel::binary-size(5)>> <> rest), do: [String.trim(fuel) | convert_fuel_types(rest)]

  defp convert_fuel_types(""), do: []
  defp convert_fuel_types(type), do: [String.trim(type)]

  defp convert_repair_service("MAJOR"), do: :major
  defp convert_repair_service("MINOR"), do: :minor
  defp convert_repair_service("NONE"), do: :none
  defp convert_repair_service(_), do: :unknown

  defp convert_transient_storage_facilities(list) do
    list
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.map(fn
      "TIE" -> :tie_downs
      "BUOY" -> :buoys
      "HGR" -> :hangars
      _ -> :unknown
    end)
  end

  defp convert_wind_indicator("Y"), do: :unlighted
  defp convert_wind_indicator("Y-L"), do: :lighted
  defp convert_wind_indicator("N"), do: :none
  defp convert_wind_indicator(_), do: :unknown

  defp convert_activation_date(""), do: nil
  defp convert_activation_date(nil), do: nil

  defp convert_activation_date(str) do
    case Timex.parse(str, "{0M}/{YYYY}") do
      {:ok, date} -> NaiveDateTime.to_date(date)
      _ -> nil
    end
  end
end
