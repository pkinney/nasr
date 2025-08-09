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
      fix_identifier: entry.record_identifier_fix_id,
      fix_state_name: entry.record_identifier_fix_state_name,
      icao_region_code: entry.icao_region_code,
      latitude_formatted: entry.geographical_latitude_of_the_fix,
      latitude_seconds: entry.geographical_latitude_of_the_fix,
      longitude_formatted: entry.geographical_longitude_of_the_fix,
      longitude_seconds: entry.geographical_longitude_of_the_fix,
      usage_data: entry.fix_use,
      nas_identifier: entry.national_airspace_system_nas_identifier_for,
      high_artcc_identifier: entry.denotes_high_artcc_area_of_jurisdiction,
      high_artcc_name: entry.denotes_high_artcc_area_of_jurisdiction,
      low_artcc_identifier: entry.denotes_low_artcc_area_of_jurisdiction,
      low_artcc_name: entry.denotes_low_artcc_area_of_jurisdiction,
      country_code: entry.icao_region_code,
      country_name: entry.fix_country_name_outside_conus,
      pitch_flag: convert_yn(entry.pitch_y_yes_or_n_no),
      catch_flag: convert_yn(entry.catch_y_yes_or_n_no),
      sua_atcaa_flag: convert_yn(entry.sua_atcaa_y_yes_or_n_no)
    }
  end
end
