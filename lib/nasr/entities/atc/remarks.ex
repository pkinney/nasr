defmodule NASR.Entities.ATC.Remarks do
  @moduledoc """
  Represents ATC Remarks from the NASR ATC_RMK data.

  This entity contains free-form text remarks that provide additional information
  about ATC facilities, procedures, frequencies, operational restrictions, or
  other important information for pilots and air traffic controllers.

  ## Fields

  * `:effective_date` - The 28 Day NASR Subscription Effective Date in format 'YYYY/MM/DD'
  * `:site_number` - Site Number assigned to the Landing Site Location
  * `:site_type_code` - Site Type Code identifying type of landing site. Values: `:airport`, `:balloonport`, `:seaplane_base`, `:gliderport`, `:heliport`, `:ultralight`
  * `:facility_type` - Type of ATC facility (ATCT=Airport Traffic Control Tower, NON-ATCT=Non-Tower, etc.)
  * `:state_code` - Associated State Post Office Code standard two letter abbreviation for US States and Territories
  * `:facility_id` - ATC Facility Identifier
  * `:city` - Associated City Name of ATC facility
  * `:country_code` - Country Post Office Code of the facility location
  * `:legacy_element_number` - Legacy element number for compatibility
  * `:table_name` - NASR table associated with Remark
  * `:reference_column_name` - NASR Column name associated with Remark
  * `:remark_number` - Sequential number for multiple remarks
  * `:remark_text` - Free form text that provides additional ATC information
  """
  import NASR.Utils

  defstruct ~w(
    effective_date
    site_number
    site_type_code
    facility_type
    state_code
    facility_id
    city
    country_code
    legacy_element_number
    table_name
    reference_column_name
    remark_number
    remark_text
  )a

  @type t() :: %__MODULE__{
          effective_date: Date.t() | nil,
          site_number: String.t(),
          site_type_code: :airport | :balloonport | :seaplane_base | :gliderport | :heliport | :ultralight | String.t() | nil,
          facility_type: String.t(),
          state_code: String.t(),
          facility_id: String.t(),
          city: String.t(),
          country_code: String.t(),
          legacy_element_number: String.t(),
          table_name: String.t(),
          reference_column_name: String.t(),
          remark_number: integer() | nil,
          remark_text: String.t()
        }

  @spec type() :: String.t()
  def type, do: "ATC_RMK"

  @spec new(map()) :: t()
  def new(entity) do
    %__MODULE__{
      effective_date: parse_date(Map.fetch!(entity, "EFF_DATE")),
      site_number: Map.fetch!(entity, "SITE_NO"),
      site_type_code: parse_site_type_code(Map.fetch!(entity, "SITE_TYPE_CODE")),
      facility_type: Map.fetch!(entity, "FACILITY_TYPE"),
      state_code: Map.fetch!(entity, "STATE_CODE"),
      facility_id: Map.fetch!(entity, "FACILITY_ID"),
      city: Map.fetch!(entity, "CITY"),
      country_code: Map.fetch!(entity, "COUNTRY_CODE"),
      legacy_element_number: Map.fetch!(entity, "LEGACY_ELEMENT_NUMBER"),
      table_name: Map.fetch!(entity, "TAB_NAME"),
      reference_column_name: Map.fetch!(entity, "REF_COL_NAME"),
      remark_number: safe_str_to_int(Map.fetch!(entity, "REMARK_NO")),
      remark_text: Map.fetch!(entity, "REMARK")
    }
  end

  defp parse_site_type_code(nil), do: nil
  defp parse_site_type_code(""), do: nil
  defp parse_site_type_code(code) when is_binary(code) do
    case String.trim(code) do
      "A" -> :airport
      "B" -> :balloonport
      "S" -> :seaplane_base
      "G" -> :gliderport
      "H" -> :heliport
      "U" -> :ultralight
      other -> other
    end
  end
end