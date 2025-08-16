defmodule NASR.Entities.HoldingPattern.Remarks do
  @moduledoc """
  Represents Holding Pattern/Fix Remarks from the NASR HPF_RMK data.

  This entity contains free-form text remarks that provide additional information
  about specific aspects of holding patterns, including charting symbols, special
  operating procedures, restrictions, or other operational considerations that
  may not be captured in the structured data fields.

  Remarks often include information about chart icons, special symbology used 
  on published charts, operational restrictions, or references to specific chart 
  publications where the holding pattern appears.

  ## Fields

  * `:effective_date` - The 28 Day NASR Subscription Effective Date in format 'YYYY/MM/DD'
  * `:hp_name` - Holding Pattern Name
  * `:hp_no` - Holding Pattern Number for the specific fix/navaid
  * `:state_code` - Associated State Post Office Code standard two letter abbreviation for US States and Territories
  * `:country_code` - Country Post Office Code where holding pattern is located
  * `:table_name` - NASR table associated with Remark
  * `:reference_column_name` - NASR Column name associated with Remark (GENERAL_REMARK for non-specific remarks)
  * `:reference_column_sequence_no` - Sequence number assigned to Reference Column Remark
  * `:remark_text` - Free form text that further describes a specific information item
  """
  import NASR.Utils

  defstruct ~w(
    effective_date
    hp_name
    hp_no
    state_code
    country_code
    table_name
    reference_column_name
    reference_column_sequence_no
    remark_text
  )a

  @type t() :: %__MODULE__{
          effective_date: Date.t() | nil,
          hp_name: String.t(),
          hp_no: integer() | nil,
          state_code: String.t(),
          country_code: String.t(),
          table_name: String.t(),
          reference_column_name: String.t(),
          reference_column_sequence_no: integer() | nil,
          remark_text: String.t()
        }

  @spec type() :: String.t()
  def type, do: "HPF_RMK"

  @spec new(map()) :: t()
  def new(entity) do
    %__MODULE__{
      effective_date: parse_date(Map.fetch!(entity, "EFF_DATE")),
      hp_name: Map.fetch!(entity, "HP_NAME"),
      hp_no: safe_str_to_int(Map.fetch!(entity, "HP_NO")),
      state_code: Map.fetch!(entity, "STATE_CODE"),
      country_code: Map.fetch!(entity, "COUNTRY_CODE"),
      table_name: Map.fetch!(entity, "TAB_NAME"),
      reference_column_name: Map.fetch!(entity, "REF_COL_NAME"),
      reference_column_sequence_no: safe_str_to_int(Map.fetch!(entity, "REF_COL_SEQ_NO")),
      remark_text: Map.fetch!(entity, "REMARK")
    }
  end
end