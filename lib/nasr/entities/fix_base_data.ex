defmodule NASR.Entities.FixBaseData do
  @moduledoc "Entity struct for FIX1 (BASE FIX DATA) records"
  import NASR.Utils

  defstruct [
    :record_type_indicator,
    :fix_identifier,
    :fix_state_name,
    :icao_region_code,
    :latitude_formatted,
    :latitude_seconds,
    :longitude_formatted,
    :longitude_seconds,
    :usage_data,
    :nas_identifier,
    :high_artcc_identifier,
    :high_artcc_name,
    :low_artcc_identifier,
    :low_artcc_name,
    :country_code,
    :country_name,
    :pitch_flag,
    :catch_flag,
    :sua_atcaa_flag
  ]

  @type t() :: %__MODULE__{
    record_type_indicator: String.t() | nil,
    fix_identifier: String.t() | nil,
    fix_state_name: String.t() | nil,
    icao_region_code: String.t() | nil,
    latitude_formatted: String.t() | nil,
    latitude_seconds: String.t() | nil,
    longitude_formatted: String.t() | nil,
    longitude_seconds: String.t() | nil,
    usage_data: String.t() | nil,
    nas_identifier: String.t() | nil,
    high_artcc_identifier: String.t() | nil,
    high_artcc_name: String.t() | nil,
    low_artcc_identifier: String.t() | nil,
    low_artcc_name: String.t() | nil,
    country_code: String.t() | nil,
    country_name: String.t() | nil,
    pitch_flag: boolean() | nil,
    catch_flag: boolean() | nil,
    sua_atcaa_flag: boolean() | nil
  }

  @spec new(map()) :: t()
  def new(entry) do
    %__MODULE__{
      record_type_indicator: entry.record_type_indicator,
      fix_identifier: entry.fix_identifier_record_identifier,
      fix_state_name: entry.fix_state_name,
      icao_region_code: entry.icao_region_code,
      latitude_formatted: entry.latitude_formatted,
      latitude_seconds: entry.latitude_all_seconds,
      longitude_formatted: entry.longitude_formatted,
      longitude_seconds: entry.longitude_all_seconds,
      usage_data: entry.usage_data,
      nas_identifier: entry.nas_identifier,
      high_artcc_identifier: entry.high_artcc_identifier,
      high_artcc_name: entry.high_artcc_name,
      low_artcc_identifier: entry.low_artcc_identifier,
      low_artcc_name: entry.low_artcc_name,
      country_code: entry.country_code,
      country_name: entry.country_name,
      pitch_flag: convert_yn(entry.pitch_flag),
      catch_flag: convert_yn(entry.catch_flag),
      sua_atcaa_flag: convert_yn(entry.sua_atcaa_flag)
    }
  end
end