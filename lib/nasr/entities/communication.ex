defmodule NASR.Entities.Communication do
  @moduledoc """
  Represents Communication frequency data from the NASR COM data.

  This entity contains information about communication outlets and frequencies
  for remote communication facilities, typically used for air traffic services
  in remote areas. Communication outlets are facilities that provide air traffic
  communication services to aircraft operating in areas where direct communication
  with primary facilities is not possible.

  ## Fields

  * `:effective_date` - The 28 Day NASR Subscription Effective Date in format 'YYYY/MM/DD'
  * `:comm_loc_id` - Communication Location Identifier
  * `:comm_type` - Communication Type (e.g., RCO - Remote Communication Outlet)
  * `:nav_id` - Associated Navigation Aid Identifier
  * `:nav_type` - Associated Navigation Aid Type
  * `:city` - Communication facility associated City Name
  * `:state_code` - Associated State Code standard two letter abbreviation for US States and Territories
  * `:region_code` - FAA Region responsible for facility. Values: `:aal`, `:ace`, `:aea`, `:agl`, `:ane`, `:anm`, `:aso`, `:asw`, `:awp`
  * `:country_code` - Country Code facility is Located
  * `:comm_outlet_name` - Communication Outlet Name
  * `:lat_deg` - Latitude Degrees
  * `:lat_min` - Latitude Minutes
  * `:lat_sec` - Latitude Seconds
  * `:lat_hemis` - Latitude Hemisphere (N/S)
  * `:latitude` - Latitude in Decimal Format
  * `:long_deg` - Longitude Degrees
  * `:long_min` - Longitude Minutes
  * `:long_sec` - Longitude Seconds
  * `:long_hemis` - Longitude Hemisphere (E/W)
  * `:longitude` - Longitude in Decimal Format
  * `:facility_id` - Associated Facility Identifier
  * `:facility_name` - Associated Facility Name
  * `:alt_fss_id` - Alternate Flight Service Station Identifier
  * `:alt_fss_name` - Alternate Flight Service Station Name
  * `:oper_hours` - Hours of Operation
  * `:comm_status_code` - Communication Status Code. Values: `:active`, `:inactive`
  * `:comm_status_date` - Communication Status Date
  * `:remark` - Remarks associated with Communication facility
  """
  import NASR.Utils

  defstruct ~w(
    effective_date
    comm_loc_id
    comm_type
    nav_id
    nav_type
    city
    state_code
    region_code
    country_code
    comm_outlet_name
    lat_deg
    lat_min
    lat_sec
    lat_hemis
    latitude
    long_deg
    long_min
    long_sec
    long_hemis
    longitude
    facility_id
    facility_name
    alt_fss_id
    alt_fss_name
    oper_hours
    comm_status_code
    comm_status_date
    remark
  )a

  @type t() :: %__MODULE__{
          effective_date: Date.t() | nil,
          comm_loc_id: String.t(),
          comm_type: String.t(),
          nav_id: String.t(),
          nav_type: String.t(),
          city: String.t(),
          state_code: String.t(),
          region_code: :aal | :ace | :aea | :agl | :ane | :anm | :aso | :asw | :awp | String.t() | nil,
          country_code: String.t(),
          comm_outlet_name: String.t(),
          lat_deg: integer() | nil,
          lat_min: integer() | nil,
          lat_sec: float() | nil,
          lat_hemis: String.t(),
          latitude: float() | nil,
          long_deg: integer() | nil,
          long_min: integer() | nil,
          long_sec: float() | nil,
          long_hemis: String.t(),
          longitude: float() | nil,
          facility_id: String.t(),
          facility_name: String.t(),
          alt_fss_id: String.t(),
          alt_fss_name: String.t(),
          oper_hours: String.t(),
          comm_status_code: :active | :inactive | String.t() | nil,
          comm_status_date: String.t(),
          remark: String.t()
        }

  @spec type() :: String.t()
  def type(), do: "COM"

  @spec new(map()) :: t()
  def new(entity) do
    %__MODULE__{
      effective_date: parse_date(Map.fetch!(entity, "EFF_DATE")),
      comm_loc_id: Map.fetch!(entity, "COMM_LOC_ID"),
      comm_type: Map.fetch!(entity, "COMM_TYPE"),
      nav_id: Map.fetch!(entity, "NAV_ID"),
      nav_type: Map.fetch!(entity, "NAV_TYPE"),
      city: Map.fetch!(entity, "CITY"),
      state_code: Map.fetch!(entity, "STATE_CODE"),
      region_code: parse_region_code(Map.fetch!(entity, "REGION_CODE")),
      country_code: Map.fetch!(entity, "COUNTRY_CODE"),
      comm_outlet_name: Map.fetch!(entity, "COMM_OUTLET_NAME"),
      lat_deg: safe_str_to_int(Map.fetch!(entity, "LAT_DEG")),
      lat_min: safe_str_to_int(Map.fetch!(entity, "LAT_MIN")),
      lat_sec: safe_str_to_float(Map.fetch!(entity, "LAT_SEC")),
      lat_hemis: Map.fetch!(entity, "LAT_HEMIS"),
      latitude: safe_str_to_float(Map.fetch!(entity, "LAT_DECIMAL")),
      long_deg: safe_str_to_int(Map.fetch!(entity, "LONG_DEG")),
      long_min: safe_str_to_int(Map.fetch!(entity, "LONG_MIN")),
      long_sec: safe_str_to_float(Map.fetch!(entity, "LONG_SEC")),
      long_hemis: Map.fetch!(entity, "LONG_HEMIS"),
      longitude: safe_str_to_float(Map.fetch!(entity, "LONG_DECIMAL")),
      facility_id: Map.fetch!(entity, "FACILITY_ID"),
      facility_name: Map.fetch!(entity, "FACILITY_NAME"),
      alt_fss_id: Map.fetch!(entity, "ALT_FSS_ID"),
      alt_fss_name: Map.fetch!(entity, "ALT_FSS_NAME"),
      oper_hours: Map.fetch!(entity, "OPR_HRS"),
      comm_status_code: parse_comm_status_code(Map.fetch!(entity, "COMM_STATUS_CODE")),
      comm_status_date: Map.fetch!(entity, "COMM_STATUS_DATE"),
      remark: Map.fetch!(entity, "REMARK")
    }
  end

  defp parse_region_code(nil), do: nil
  defp parse_region_code(""), do: nil
  defp parse_region_code(code) when is_binary(code) do
    case String.trim(code) do
      "AAL" -> :aal
      "ACE" -> :ace
      "AEA" -> :aea
      "AGL" -> :agl
      "ANE" -> :ane
      "ANM" -> :anm
      "ASO" -> :aso
      "ASW" -> :asw
      "AWP" -> :awp
      other -> other
    end
  end

  defp parse_comm_status_code(nil), do: nil
  defp parse_comm_status_code(""), do: nil
  defp parse_comm_status_code(code) when is_binary(code) do
    case String.trim(code) do
      "A" -> :active
      "I" -> :inactive
      other -> other
    end
  end
end