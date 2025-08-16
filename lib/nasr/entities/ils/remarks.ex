defmodule NASR.Entities.ILS.Remarks do
  @moduledoc """
  Represents ILS Remarks from the NASR ILS_RMK data.

  This entity contains free-form text remarks that provide additional information
  about specific aspects of ILS facilities, operations, limitations, or conditions
  that are important for flight planning and operations.

  ## Fields

  * `:effective_date` - The 28 Day NASR Subscription Effective Date in format 'YYYY/MM/DD'
  * `:site_number` - Site Number assigned to the Landing Site Location
  * `:site_type_code` - Site Type Code identifying type of landing site. Values: `:airport`, `:balloonport`, `:seaplane_base`, `:gliderport`, `:heliport`, `:ultralight`
  * `:state_code` - Associated State Post Office Code standard two letter abbreviation for US States and Territories
  * `:airport_id` - Airport Identifier associated with the Landing Site
  * `:city` - Associated City Name of ILS facility
  * `:country_code` - Country Post Office Code of the Landing Site Location
  * `:runway_end_id` - Runway End Identifier (runway number and optional L/R/C designation)
  * `:ils_localizer_id` - ILS Localizer Identifier
  * `:system_type_code` - System Type Code. Values: `:ils`, `:localizer_only`, `:simplified_directional_facility`, `:localizer_directional_aid`, `:microwave_landing_system`
  * `:table_name` - NASR table associated with Remark
  * `:ils_component_type_code` - ILS Component Type Code if remark is specific to a component
  * `:reference_column_name` - NASR Column name associated with Remark (GENERAL_REMARK for non-specific remarks)
  * `:reference_column_sequence_no` - Sequence number assigned to Reference Column Remark
  * `:remark_text` - Free form text that further describes a specific information item
  """
  import NASR.Utils

  defstruct ~w(
    effective_date
    site_number
    site_type_code
    state_code
    airport_id
    city
    country_code
    runway_end_id
    ils_localizer_id
    system_type_code
    table_name
    ils_component_type_code
    reference_column_name
    reference_column_sequence_no
    remark_text
  )a

  @type t() :: %__MODULE__{
          effective_date: Date.t() | nil,
          site_number: String.t(),
          site_type_code: :airport | :balloonport | :seaplane_base | :gliderport | :heliport | :ultralight | String.t() | nil,
          state_code: String.t(),
          airport_id: String.t(),
          city: String.t(),
          country_code: String.t(),
          runway_end_id: String.t(),
          ils_localizer_id: String.t(),
          system_type_code: :ils | :localizer_only | :simplified_directional_facility | :localizer_directional_aid | :microwave_landing_system | String.t() | nil,
          table_name: String.t(),
          ils_component_type_code: String.t(),
          reference_column_name: String.t(),
          reference_column_sequence_no: integer() | nil,
          remark_text: String.t()
        }

  @spec type() :: String.t()
  def type, do: "ILS_RMK"

  @spec new(map()) :: t()
  def new(entity) do
    %__MODULE__{
      effective_date: parse_date(Map.fetch!(entity, "EFF_DATE")),
      site_number: Map.fetch!(entity, "SITE_NO"),
      site_type_code: parse_site_type_code(Map.fetch!(entity, "SITE_TYPE_CODE")),
      state_code: Map.fetch!(entity, "STATE_CODE"),
      airport_id: Map.fetch!(entity, "ARPT_ID"),
      city: Map.fetch!(entity, "CITY"),
      country_code: Map.fetch!(entity, "COUNTRY_CODE"),
      runway_end_id: Map.fetch!(entity, "RWY_END_ID"),
      ils_localizer_id: Map.fetch!(entity, "ILS_LOC_ID"),
      system_type_code: parse_system_type_code(Map.fetch!(entity, "SYSTEM_TYPE_CODE")),
      table_name: Map.fetch!(entity, "TAB_NAME"),
      ils_component_type_code: Map.fetch!(entity, "ILS_COMP_TYPE_CODE"),
      reference_column_name: Map.fetch!(entity, "REF_COL_NAME"),
      reference_column_sequence_no: safe_str_to_int(Map.fetch!(entity, "REF_COL_SEQ_NO")),
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

  defp parse_system_type_code(nil), do: nil
  defp parse_system_type_code(""), do: nil
  defp parse_system_type_code(code) when is_binary(code) do
    case String.trim(code) do
      "LS" -> :ils
      "LO" -> :localizer_only
      "SD" -> :simplified_directional_facility
      "LD" -> :localizer_directional_aid
      "ML" -> :microwave_landing_system
      other -> other
    end
  end
end