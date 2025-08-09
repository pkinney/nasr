defmodule NASR.Entities.MilitaryTrainingRouteAgencyData do
  @moduledoc "Entity struct for MTR6 (AGENCY DATA) records"
  import NASR.Utils

  defstruct [
    :record_type_indicator,
    :route_type,
    :route_identifier,
    :agency_type_code,
    :agency_organization_name,
    :agency_station,
    :agency_address,
    :agency_city,
    :agency_state,
    :agency_zip_code,
    :agency_commercial_phone,
    :agency_dsn_phone,
    :agency_hours
  ]

  @type t() :: %__MODULE__{
    record_type_indicator: String.t() | nil,
    route_type: :ifr | :vfr | nil,
    route_identifier: integer() | nil,
    agency_type_code: :originating | :scheduling_1 | :scheduling_2 | :scheduling_3 | :scheduling_4 | nil,
    agency_organization_name: String.t() | nil,
    agency_station: String.t() | nil,
    agency_address: String.t() | nil,
    agency_city: String.t() | nil,
    agency_state: String.t() | nil,
    agency_zip_code: String.t() | nil,
    agency_commercial_phone: String.t() | nil,
    agency_dsn_phone: String.t() | nil,
    agency_hours: String.t() | nil
  }

  @spec new(map()) :: t()
  def new(entry) do
    %__MODULE__{
      record_type_indicator: entry.record_type_indicator,
      route_type: convert_route_type(entry.route_type),
      route_identifier: safe_str_to_int(entry.route_identifier),
      agency_type_code: convert_agency_type(entry.agency_type_code),
      agency_organization_name: entry.agency_organization_name,
      agency_station: entry.agency_station,
      agency_address: entry.agency_address,
      agency_city: entry.agency_city,
      agency_state: entry.agency_state,
      agency_zip_code: entry.agency_zip_code,
      agency_commercial_phone: entry.agency_commercial_phone,
      agency_dsn_phone: entry.agency_dsn_phone,
      agency_hours: entry.agency_hours
    }
  end

  defp convert_route_type("IR"), do: :ifr
  defp convert_route_type("VR"), do: :vfr
  defp convert_route_type(_), do: nil

  defp convert_agency_type("O"), do: :originating
  defp convert_agency_type("S1"), do: :scheduling_1
  defp convert_agency_type("S2"), do: :scheduling_2
  defp convert_agency_type("S3"), do: :scheduling_3
  defp convert_agency_type("S4"), do: :scheduling_4
  defp convert_agency_type(_), do: nil
end