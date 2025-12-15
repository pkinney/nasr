defmodule NASR.Entities.Nav.Remarks do
  @moduledoc """
  Represents Navigation Aid Remarks from the NASR NAV_RMK data.

  This entity contains free-form text remarks that provide additional information
  about specific aspects of navigation aid facilities, operations, or conditions.

  ## Fields

  * `:effective_date` - The 28 Day NASR Subscription Effective Date in format 'YYYY/MM/DD'
  * `:nav_id` - NAVAID Facility Identifier
  * `:nav_type` - NAVAID Facility Type
  * `:state_code` - Associated State Post Office Code standard two letter abbreviation for US States and Territories
  * `:city` - NAVAID Associated City Name
  * `:country_code` - Country Post Office Code NAVAID Located
  * `:table_name` - NASR table associated with Remark
  * `:reference_column_name` - NASR Column name associated with Remark (GENERAL_REMARK for non-specific remarks)
  * `:reference_column_sequence_no` - Sequence number assigned to Reference Column Remark
  * `:remark_text` - Free form text that further describes a specific information item
  """
  import NASR.Utils

  defstruct [
    :effective_date,
    :nav_id,
    :nav_type,
    :state_code,
    :city,
    :country_code,
    :table_name,
    :reference_column_name,
    :reference_column_sequence_no,
    :remark_text,
    meta: %{}
  ]

  @type t() :: %__MODULE__{
          effective_date: Date.t() | nil,
          nav_id: String.t(),
          nav_type: String.t(),
          state_code: String.t(),
          city: String.t(),
          country_code: String.t(),
          table_name: String.t(),
          reference_column_name: String.t(),
          reference_column_sequence_no: integer() | nil,
          remark_text: String.t(),
          meta: map()
        }

  @spec type() :: String.t()
  def type, do: "NAV_RMK"

  @spec new(map()) :: t()
  def new(entity) do
    %__MODULE__{
      effective_date: parse_date(Map.get(entity, "EFF_DATE")),
      nav_id: Map.get(entity, "NAV_ID"),
      nav_type: Map.get(entity, "NAV_TYPE"),
      state_code: Map.get(entity, "STATE_CODE"),
      city: Map.get(entity, "CITY"),
      country_code: Map.get(entity, "COUNTRY_CODE"),
      table_name: Map.get(entity, "TAB_NAME"),
      reference_column_name: Map.get(entity, "REF_COL_NAME"),
      reference_column_sequence_no: safe_str_to_int(Map.get(entity, "REF_COL_SEQ_NO")),
      remark_text: Map.get(entity, "REMARK")
    }
  end
end
