defmodule NASR.Entities.AWOS do
  @moduledoc """
  Represents ASOS/AWOS Data from the NASR AWOS data.

  This entity contains information about Automated Surface Observing System (ASOS) and
  Automated Weather Observing System (AWOS) installations, which provide continuous
  weather observations for aviation. The AWOS.csv file was designed to replace the
  legacy AWOS.txt Subscriber File.

  ## Fields

  * `:effective_date` - The 28 Day NASR Subscription Effective Date in format 'YYYY/MM/DD'
  * `:asos_awos_id` - Weather System Identifier. Unique 3-4 character alphanumeric identifier
  * `:asos_awos_type` - Weather System Type
  * `:state_code` - Associated State Code standard two letter abbreviation for US States and Territories
  * `:city` - Weather System associated City Name
  * `:country_code` - Country Code Weather System is Located
  * `:commissioned_date` - Commissioning Date (Decommissioned Weather systems are not included so Dates given are for Commissioning Dates)
  * `:navaid_flag` - Weather associated with NAVAID (boolean: true for Y, false for N)
  * `:latitude` - Weather System Latitude in Decimal Format
  * `:longitude` - Weather System Longitude in Decimal Format
  * `:elevation` - Weather System Elevation (Nearest Tenth of a Foot)
  * `:survey_method_code` - Weather System Location Determination Method. Values: `:estimated`, `:surveyed`
  * `:phone_no` - Weather System Telephone Number
  * `:second_phone_no` - Weather System Second Telephone Number
  * `:site_no` - Landing Facility Site Number when Weather System Located at Airport
  * `:site_type` - Landing Facility Type when Weather System Located at Airport. Values: `:airport`, `:balloonport`, `:seaplane_base`, `:gliderport`, `:heliport`, `:ultralight`
  * `:remark` - Remark associated with Weather System
  """
  import NASR.Utils

  defstruct ~w(
    effective_date
    asos_awos_id
    asos_awos_type
    state_code
    city
    country_code
    commissioned_date
    navaid_flag
    latitude
    longitude
    elevation
    survey_method_code
    phone_no
    second_phone_no
    site_no
    site_type
    remark
  )a

  @type t() :: %__MODULE__{
          effective_date: Date.t() | nil,
          asos_awos_id: String.t(),
          asos_awos_type: String.t(),
          state_code: String.t(),
          city: String.t(),
          country_code: String.t(),
          commissioned_date: String.t(),
          navaid_flag: boolean() | nil,
          latitude: float() | nil,
          longitude: float() | nil,
          elevation: float() | nil,
          survey_method_code: :estimated | :surveyed | String.t() | nil,
          phone_no: String.t(),
          second_phone_no: String.t(),
          site_no: String.t(),
          site_type:
            :airport | :balloonport | :seaplane_base | :gliderport | :heliport | :ultralight | String.t() | nil,
          remark: String.t()
        }

  @spec type() :: String.t()
  def type, do: "AWOS"

  @spec new(map()) :: t()
  def new(entity) do
    %__MODULE__{
      effective_date: parse_date(Map.get(entity, "EFF_DATE")),
      asos_awos_id: Map.get(entity, "ASOS_AWOS_ID"),
      asos_awos_type: Map.get(entity, "ASOS_AWOS_TYPE"),
      state_code: Map.get(entity, "STATE_CODE"),
      city: Map.get(entity, "CITY"),
      country_code: Map.get(entity, "COUNTRY_CODE"),
      commissioned_date: Map.get(entity, "COMMISSIONED_DATE"),
      navaid_flag: convert_yn(Map.get(entity, "NAVAID_FLAG")),
      latitude: safe_str_to_float(Map.get(entity, "LAT_DECIMAL")),
      longitude: safe_str_to_float(Map.get(entity, "LONG_DECIMAL")),
      elevation: safe_str_to_float(Map.get(entity, "ELEV")),
      survey_method_code: parse_survey_method_code(Map.get(entity, "SURVEY_METHOD_CODE")),
      phone_no: Map.get(entity, "PHONE_NO"),
      second_phone_no: Map.get(entity, "SECOND_PHONE_NO"),
      site_no: Map.get(entity, "SITE_NO"),
      site_type: parse_site_type_code(Map.get(entity, "SITE_TYPE_CODE")),
      remark: Map.get(entity, "REMARK")
    }
  end

  defp parse_survey_method_code(nil), do: nil
  defp parse_survey_method_code(""), do: nil

  defp parse_survey_method_code(code) when is_binary(code) do
    case String.trim(code) do
      "E" -> :estimated
      "S" -> :surveyed
      other -> other
    end
  end
end
