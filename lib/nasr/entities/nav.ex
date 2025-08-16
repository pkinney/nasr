defmodule NASR.Entities.Nav do
  @moduledoc """
  Represents Navigation Aid (NAVAID) information from the NASR NAV_BASE data.

  Navigation aids are electronic devices that provide position and navigation information
  to aircraft. The NAV_BASE file contains comprehensive information about all types of
  navigation aids including VOR, DME, TACAN, NDB, and other electronic navigation systems
  throughout the United States.

  ## Fields

  * `:effective_date` - The 28 Day NASR Subscription Effective Date in format 'YYYY/MM/DD'
  * `:nav_id` - NAVAID Facility Identifier
  * `:nav_type` - NAVAID Facility Type. Values: `:consolan`, `:dme`, `:fan_marker`, `:marine_ndb`, `:marine_ndb_dme`, `:ndb`, `:ndb_dme`, `:tacan`, `:uhf_ndb`, `:vor`, `:vortac`, `:vor_dme`, `:vot`
  * `:state_code` - Associated State Post Office Code standard two letter abbreviation for US States and Territories
  * `:city` - NAVAID Associated City Name
  * `:country_code` - Country Post Office Code NAVAID Located
  * `:nav_status` - Navigation Aid Status
  * `:name` - Name of NAVAID
  * `:state_name` - Associated State Name
  * `:region_code` - FAA Region responsible for NAVAID. Values: `:aal`, `:ace`, `:aea`, `:agl`, `:ane`, `:anm`, `:aso`, `:asw`, `:awp`
  * `:country_name` - Country Name NAVAID Located
  * `:fan_marker` - Name of FAN MARKER
  * `:owner` - A Concatenation of the NAVAID OWNER CODE - NAVAID OWNER NAME
  * `:operator` - A Concatenation of the NAVAID OPERATOR CODE - NAVAID OPERATOR NAME
  * `:nas_use_flag` - Common System Usage (boolean: true for Y, false for N)
  * `:public_use_flag` - NAVAID PUBLIC USE (boolean: true for Y, false for N)
  * `:ndb_class_code` - Class of NDB
  * `:oper_hours` - HOURS of Operation of NAVAID
  * `:high_alt_artcc_id` - Identifier of ARTCC with High Altitude Boundary That the NAVAID Falls Within
  * `:high_artcc_name` - Name of ARTCC with High Altitude Boundary That the NAVAID Falls Within
  * `:low_alt_artcc_id` - Identifier of ARTCC with Low Altitude Boundary That the NAVAID Falls Within
  * `:low_artcc_name` - Name of ARTCC with Low Altitude Boundary That the NAVAID Falls Within
  * `:latitude` - NAVAID Latitude in Decimal Format
  * `:longitude` - NAVAID Longitude in Decimal Format
  * `:survey_accuracy_code` - Latitude/Longitude Survey Accuracy Code. Values: `:unknown`, `:degree`, `:ten_minutes`, `:one_minute`, `:ten_seconds`, `:one_second_or_better`, `:nos`, `:third_order_triangulation`
  * `:tacan_dme_status` - Status of TACAN or DME Equipment
  * `:tacan_dme_latitude` - Latitude in Decimal Format of TACAN Portion of VORTAC when TACAN is not sited with VOR
  * `:tacan_dme_longitude` - Longitude in Decimal Format of TACAN Portion of VORTAC when TACAN is not sited with VOR
  * `:elevation` - Elevation in Tenth of a Foot (MSL)
  * `:magnetic_variation` - Magnetic Variation Degrees
  * `:magnetic_hemisphere` - Magnetic Variation Direction
  * `:magnetic_variation_year` - Magnetic Variation Epoch Year
  * `:simul_voice_flag` - Simultaneous Voice Feature (boolean: true for Y, false for N)
  * `:power_output` - Power Output (In Watts)
  * `:auto_voice_id_flag` - Automatic Voice Identification Feature (boolean: true for Y, false for N)
  * `:mnt_cat_code` - Monitoring Category (1, 2, 3, 4)
  * `:voice_call` - Radio Voice Call (Name) or Trans Signal
  * `:channel` - Channel (TACAN) NAVAID Transmits On
  * `:frequency` - Frequency the NAVAID Transmits On (Except TACAN)
  * `:marker_ident` - Transmitted Fan Marker/Marine Radio Beacon Identifier
  * `:marker_shape` - Fan Marker Type (E - ELLIPTICAL)
  * `:marker_bearing` - True Bearing of Major Axis of Fan Marker
  * `:alt_code` - VOR Standard Service Volume. Values: `:high`, `:low`, `:terminal`, `:vor_high`, `:vor_low`
  * `:dme_ssv` - DME Standard Service Volume. Values: `:high`, `:low`, `:terminal`, `:dme_high`, `:dme_low`
  * `:low_nav_on_high_chart_flag` - Low Altitude Facility Used in High Structure (boolean: true for Y, false for N)
  * `:z_marker_flag` - NAVAID Z Marker Available (boolean: true for Y, false for N)
  * `:fss_id` - Associated/Controlling FSS (IDENT)
  * `:fss_name` - Associated/Controlling FSS (Name)
  * `:fss_hours` - Hours of Operation of Controlling FSS
  * `:notam_id` - NOTAM Accountability Code (IDENT)
  * `:quad_ident` - Quadrant Identification and Range Leg Bearing (LFR Only)
  * `:pitch_flag` - Pitch Flag (boolean: true for Y, false for N)
  * `:catch_flag` - Catch Flag (boolean: true for Y, false for N)
  * `:sua_atcaa_flag` - SUA/ATCAA Flag (boolean: true for Y, false for N)
  * `:restriction_flag` - NAVAID Restriction Flag
  * `:hiwas_flag` - HIWAS Flag
  """
  import NASR.Utils

  defstruct ~w(
    effective_date
    nav_id
    nav_type
    state_code
    city
    country_code
    nav_status
    name
    state_name
    region_code
    country_name
    fan_marker
    owner
    operator
    nas_use_flag
    public_use_flag
    ndb_class_code
    oper_hours
    high_alt_artcc_id
    high_artcc_name
    low_alt_artcc_id
    low_artcc_name
    latitude
    longitude
    survey_accuracy_code
    tacan_dme_status
    tacan_dme_latitude
    tacan_dme_longitude
    elevation
    magnetic_variation
    magnetic_hemisphere
    magnetic_variation_year
    simul_voice_flag
    power_output
    auto_voice_id_flag
    mnt_cat_code
    voice_call
    channel
    frequency
    marker_ident
    marker_shape
    marker_bearing
    alt_code
    dme_ssv
    low_nav_on_high_chart_flag
    z_marker_flag
    fss_id
    fss_name
    fss_hours
    notam_id
    quad_ident
    pitch_flag
    catch_flag
    sua_atcaa_flag
    restriction_flag
    hiwas_flag
  )a

  @type t() :: %__MODULE__{
          effective_date: Date.t() | nil,
          nav_id: String.t(),
          nav_type: :consolan | :dme | :fan_marker | :marine_ndb | :marine_ndb_dme | :ndb | :ndb_dme | :tacan | :uhf_ndb | :vor | :vortac | :vor_dme | :vot | String.t() | nil,
          state_code: String.t(),
          city: String.t(),
          country_code: String.t(),
          nav_status: String.t(),
          name: String.t(),
          state_name: String.t(),
          region_code: :aal | :ace | :aea | :agl | :ane | :anm | :aso | :asw | :awp | String.t() | nil,
          country_name: String.t(),
          fan_marker: String.t(),
          owner: String.t(),
          operator: String.t(),
          nas_use_flag: boolean() | nil,
          public_use_flag: boolean() | nil,
          ndb_class_code: String.t(),
          oper_hours: String.t(),
          high_alt_artcc_id: String.t(),
          high_artcc_name: String.t(),
          low_alt_artcc_id: String.t(),
          low_artcc_name: String.t(),
          latitude: float() | nil,
          longitude: float() | nil,
          survey_accuracy_code: :unknown | :degree | :ten_minutes | :one_minute | :ten_seconds | :one_second_or_better | :nos | :third_order_triangulation | String.t() | nil,
          tacan_dme_status: String.t(),
          tacan_dme_latitude: float() | nil,
          tacan_dme_longitude: float() | nil,
          elevation: float() | nil,
          magnetic_variation: float() | nil,
          magnetic_hemisphere: String.t(),
          magnetic_variation_year: integer() | nil,
          simul_voice_flag: boolean() | nil,
          power_output: integer() | nil,
          auto_voice_id_flag: boolean() | nil,
          mnt_cat_code: String.t(),
          voice_call: String.t(),
          channel: integer() | nil,
          frequency: float() | nil,
          marker_ident: String.t(),
          marker_shape: String.t(),
          marker_bearing: String.t(),
          alt_code: :high | :low | :terminal | :vor_high | :vor_low | String.t() | nil,
          dme_ssv: :high | :low | :terminal | :dme_high | :dme_low | String.t() | nil,
          low_nav_on_high_chart_flag: boolean() | nil,
          z_marker_flag: boolean() | nil,
          fss_id: String.t(),
          fss_name: String.t(),
          fss_hours: String.t(),
          notam_id: String.t(),
          quad_ident: String.t(),
          pitch_flag: boolean() | nil,
          catch_flag: boolean() | nil,
          sua_atcaa_flag: boolean() | nil,
          restriction_flag: String.t(),
          hiwas_flag: String.t()
        }

  @spec type() :: String.t()
  def type, do: "NAV_BASE"

  @spec new(map()) :: t()
  def new(entity) do
    %__MODULE__{
      effective_date: parse_date(Map.fetch!(entity, "EFF_DATE")),
      nav_id: Map.fetch!(entity, "NAV_ID"),
      nav_type: parse_nav_type(Map.fetch!(entity, "NAV_TYPE")),
      state_code: Map.fetch!(entity, "STATE_CODE"),
      city: Map.fetch!(entity, "CITY"),
      country_code: Map.fetch!(entity, "COUNTRY_CODE"),
      nav_status: Map.fetch!(entity, "NAV_STATUS"),
      name: Map.fetch!(entity, "NAME"),
      state_name: Map.fetch!(entity, "STATE_NAME"),
      region_code: parse_region_code(Map.fetch!(entity, "REGION_CODE")),
      country_name: Map.fetch!(entity, "COUNTRY_NAME"),
      fan_marker: Map.fetch!(entity, "FAN_MARKER"),
      owner: Map.fetch!(entity, "OWNER"),
      operator: Map.fetch!(entity, "OPERATOR"),
      nas_use_flag: convert_yn(Map.fetch!(entity, "NAS_USE_FLAG")),
      public_use_flag: convert_yn(Map.fetch!(entity, "PUBLIC_USE_FLAG")),
      ndb_class_code: Map.fetch!(entity, "NDB_CLASS_CODE"),
      oper_hours: Map.fetch!(entity, "OPER_HOURS"),
      high_alt_artcc_id: Map.fetch!(entity, "HIGH_ALT_ARTCC_ID"),
      high_artcc_name: Map.fetch!(entity, "HIGH_ARTCC_NAME"),
      low_alt_artcc_id: Map.fetch!(entity, "LOW_ALT_ARTCC_ID"),
      low_artcc_name: Map.fetch!(entity, "LOW_ARTCC_NAME"),
      latitude: safe_str_to_float(Map.fetch!(entity, "LAT_DECIMAL")),
      longitude: safe_str_to_float(Map.fetch!(entity, "LONG_DECIMAL")),
      survey_accuracy_code: parse_survey_accuracy_code(Map.fetch!(entity, "SURVEY_ACCURACY_CODE")),
      tacan_dme_status: Map.fetch!(entity, "TACAN_DME_STATUS"),
      tacan_dme_latitude: safe_str_to_float(Map.fetch!(entity, "TACAN_DME_LAT_DECIMAL")),
      tacan_dme_longitude: safe_str_to_float(Map.fetch!(entity, "TACAN_DME_LONG_DECIMAL")),
      elevation: safe_str_to_float(Map.fetch!(entity, "ELEV")),
      magnetic_variation: safe_str_to_float(Map.fetch!(entity, "MAG_VARN")),
      magnetic_hemisphere: Map.fetch!(entity, "MAG_VARN_HEMIS"),
      magnetic_variation_year: safe_str_to_int(Map.fetch!(entity, "MAG_VARN_YEAR")),
      simul_voice_flag: convert_yn(Map.fetch!(entity, "SIMUL_VOICE_FLAG")),
      power_output: safe_str_to_int(Map.fetch!(entity, "PWR_OUTPUT")),
      auto_voice_id_flag: convert_yn(Map.fetch!(entity, "AUTO_VOICE_ID_FLAG")),
      mnt_cat_code: Map.fetch!(entity, "MNT_CAT_CODE"),
      voice_call: Map.fetch!(entity, "VOICE_CALL"),
      channel: safe_str_to_int(Map.fetch!(entity, "CHAN")),
      frequency: safe_str_to_float(Map.fetch!(entity, "FREQ")),
      marker_ident: Map.fetch!(entity, "MKR_IDENT"),
      marker_shape: Map.fetch!(entity, "MKR_SHAPE"),
      marker_bearing: Map.fetch!(entity, "MKR_BRG"),
      alt_code: parse_alt_code(Map.fetch!(entity, "ALT_CODE")),
      dme_ssv: parse_dme_ssv(Map.fetch!(entity, "DME_SSV")),
      low_nav_on_high_chart_flag: convert_yn(Map.fetch!(entity, "LOW_NAV_ON_HIGH_CHART_FLAG")),
      z_marker_flag: convert_yn(Map.fetch!(entity, "Z_MKR_FLAG")),
      fss_id: Map.fetch!(entity, "FSS_ID"),
      fss_name: Map.fetch!(entity, "FSS_NAME"),
      fss_hours: Map.fetch!(entity, "FSS_HOURS"),
      notam_id: Map.fetch!(entity, "NOTAM_ID"),
      quad_ident: Map.fetch!(entity, "QUAD_IDENT"),
      pitch_flag: convert_yn(Map.fetch!(entity, "PITCH_FLAG")),
      catch_flag: convert_yn(Map.fetch!(entity, "CATCH_FLAG")),
      sua_atcaa_flag: convert_yn(Map.fetch!(entity, "SUA_ATCAA_FLAG")),
      restriction_flag: Map.fetch!(entity, "RESTRICTION_FLAG"),
      hiwas_flag: Map.fetch!(entity, "HIWAS_FLAG")
    }
  end

  defp parse_nav_type(nil), do: nil
  defp parse_nav_type(""), do: nil
  defp parse_nav_type(type) when is_binary(type) do
    case String.trim(type) do
      "CONSOLAN" -> :consolan
      "DME" -> :dme
      "FAN MARKER" -> :fan_marker
      "MARINE NDB" -> :marine_ndb
      "MARINE NDB/DME" -> :marine_ndb_dme
      "NDB" -> :ndb
      "NDB/DME" -> :ndb_dme
      "TACAN" -> :tacan
      "UHF/NDB" -> :uhf_ndb
      "VOR" -> :vor
      "VORTAC" -> :vortac
      "VOR/DME" -> :vor_dme
      "VOT" -> :vot
      other -> other
    end
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

  defp parse_survey_accuracy_code(nil), do: nil
  defp parse_survey_accuracy_code(""), do: nil
  defp parse_survey_accuracy_code(code) when is_binary(code) do
    case String.trim(code) do
      "0" -> :unknown
      "1" -> :degree
      "2" -> :ten_minutes
      "3" -> :one_minute
      "4" -> :ten_seconds
      "5" -> :one_second_or_better
      "6" -> :nos
      "7" -> :third_order_triangulation
      other -> other
    end
  end

  defp parse_alt_code(nil), do: nil
  defp parse_alt_code(""), do: nil
  defp parse_alt_code(code) when is_binary(code) do
    case String.trim(code) do
      "H" -> :high
      "L" -> :low
      "T" -> :terminal
      "VH" -> :vor_high
      "VL" -> :vor_low
      other -> other
    end
  end

  defp parse_dme_ssv(nil), do: nil
  defp parse_dme_ssv(""), do: nil
  defp parse_dme_ssv(code) when is_binary(code) do
    case String.trim(code) do
      "H" -> :high
      "L" -> :low
      "T" -> :terminal
      "DH" -> :dme_high
      "DL" -> :dme_low
      other -> other
    end
  end
end