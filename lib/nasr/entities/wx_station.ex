defmodule NASR.Entities.WxStation do
  @moduledoc false
  import NASR.Utils

  defstruct [
    :landing_facility_site_number,
    :ident,
    :sensor_type,
    :frequency,
    :second_frequency,
    :telephone_number,
    :city,
    :state,
    :elevation,
    :commissioning_status,
    :navaid,
    :longitude,
    :latitude,
    remarks: []
  ]

  @type t() :: %__MODULE__{}

  @spec new(map()) :: t()
  def new(entity) do
    %__MODULE__{
      landing_facility_site_number: nil,
      ident: entity.weather_reporting_location_identifier,
      sensor_type: entity.collective_weather_service_type,
      frequency: nil,
      second_frequency: nil,
      telephone_number: nil,
      city: entity.associated_city,
      state: entity.associated_state_post_office_code,
      elevation: safe_str_to_int(entity.weather_reporting_location_elevation___value),
      commissioning_status: nil,
      navaid: nil,
      longitude: parse_wx_coordinate(entity.longitude_of_the_weather_reporting_location),
      latitude: parse_wx_coordinate(entity.latitude_of_the_weather_reporting_location)
    }
  end

  defp parse_wx_coordinate(nil), do: nil
  defp parse_wx_coordinate(""), do: nil
  defp parse_wx_coordinate(coord_str) when is_binary(coord_str) do
    # Try standard DMS first
    try do
      convert_dms_to_decimal(coord_str)
    rescue
      _ -> nil
    end
  end
  defp parse_wx_coordinate(_), do: nil
end
