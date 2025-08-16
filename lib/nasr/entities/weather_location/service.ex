defmodule NASR.Entities.WeatherLocation.Service do
  @moduledoc """
  Represents Weather Reporting Location Service data from the NASR WXL_SVC data.

  This entity contains information about the specific weather services available
  at each weather reporting location. Different locations provide different types
  of weather products including METAR observations, pilot reports, NOTAMs,
  surface analysis, and upper air data. This data helps pilots and dispatchers
  understand what weather information is available from each location.

  ## Fields

  * `:effective_date` - The 28 Day NASR Subscription Effective Date in format 'YYYY/MM/DD'
  * `:weather_id` - Weather Location Identifier. Unique 3-4 character alphanumeric identifier
  * `:city` - Associated City Name where weather location is situated
  * `:state_code` - Associated State Code standard two letter abbreviation for US States and Territories
  * `:country_code` - Country Code where weather location is situated
  * `:service_type` - Weather Service Type Code. Values: `:metar`, `:speci`, `:notam`, `:ua`, `:sa`, `:pirep`
  * `:service_area` - Weather Service Affected Area or coverage description
  """
  import NASR.Utils

  defstruct ~w(
    effective_date
    weather_id
    city
    state_code
    country_code
    service_type
    service_area
  )a

  @type t() :: %__MODULE__{
          effective_date: Date.t() | nil,
          weather_id: String.t(),
          city: String.t(),
          state_code: String.t(),
          country_code: String.t(),
          service_type: :metar | :speci | :notam | :ua | :sa | :pirep | String.t() | nil,
          service_area: String.t()
        }

  @spec type() :: String.t()
  def type(), do: "WXL_SVC"

  @spec new(map()) :: t()
  def new(entity) do
    %__MODULE__{
      effective_date: parse_date(Map.fetch!(entity, "EFF_DATE")),
      weather_id: Map.fetch!(entity, "WEA_ID"),
      city: Map.fetch!(entity, "CITY"),
      state_code: Map.fetch!(entity, "STATE_CODE"),
      country_code: Map.fetch!(entity, "COUNTRY_CODE"),
      service_type: parse_service_type(Map.fetch!(entity, "WEA_SVC_TYPE_CODE")),
      service_area: Map.fetch!(entity, "WEA_AFFECT_AREA")
    }
  end

  defp parse_service_type(nil), do: nil
  defp parse_service_type(""), do: nil
  defp parse_service_type(type) when is_binary(type) do
    case String.trim(String.upcase(type)) do
      "METAR" -> :metar
      "SPECI" -> :speci
      "NOTAM" -> :notam
      "UA" -> :ua
      "SA" -> :sa
      "PIREP" -> :pirep
      other -> other
    end
  end
end