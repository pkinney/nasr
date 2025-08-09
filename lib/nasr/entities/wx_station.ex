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
      landing_facility_site_number: entity.landing_facility_site_number_when_station_located,
      ident: entity.wx_sensor_ident,
      sensor_type: entity.wx_sensor_type,
      frequency: entity.station_frequency,
      second_frequency: entity.second_station_frequency,
      telephone_number: entity.station_telephone_number,
      city: entity.station_city,
      state: entity.station_state_post_office_code_ex_il,
      elevation: safe_str_to_int(entity.elevation),
      commissioning_status: convert_yn(entity.commissioning_status),
      navaid: convert_yn(entity.navaid_flag___wx_sensor_associated_with_navaid),
      longitude: convert_dms_to_decimal(entity.station_longitude),
      latitude: convert_dms_to_decimal(entity.station_latitude)
    }
  end
end
