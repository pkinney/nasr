defmodule NASR.Entities.MaximumAuthorizedAltitude.Remarks do
  @moduledoc """
  Represents Maximum Authorized Altitude Remarks from the NASR MAA_RMK data.

  This entity contains free-form text remarks that provide additional information
  about specific aspects of Maximum Authorized Altitude areas, including operational
  details, usage restrictions, activation procedures, aircraft types, and other
  important considerations that may not be captured in the structured data fields.

  Remarks often include information about specific aircraft operations, time-based
  restrictions, activation procedures via NOTAM, coordination requirements, and
  detailed operational parameters for special use airspace areas.

  ## Fields

  * `:effective_date` - The 28 Day NASR Subscription Effective Date in format 'YYYY/MM/DD'
  * `:maa_id` - Maximum Authorized Altitude Identifier
  * `:table_name` - NASR table associated with Remark
  * `:reference_column_name` - NASR Column name associated with Remark (GENERAL_REMARK for non-specific remarks)
  * `:reference_column_sequence_no` - Sequence number assigned to Reference Column Remark
  * `:remark_text` - Free form text that further describes a specific information item
  """
  import NASR.Utils

  defstruct ~w(
    effective_date
    maa_id
    table_name
    reference_column_name
    reference_column_sequence_no
    remark_text
  )a

  @type t() :: %__MODULE__{
          effective_date: Date.t() | nil,
          maa_id: String.t(),
          table_name: String.t(),
          reference_column_name: String.t(),
          reference_column_sequence_no: integer() | nil,
          remark_text: String.t()
        }

  @spec type() :: String.t()
  def type, do: "MAA_RMK"

  @spec new(map()) :: t()
  def new(entity) do
    %__MODULE__{
      effective_date: parse_date(Map.fetch!(entity, "EFF_DATE")),
      maa_id: Map.fetch!(entity, "MAA_ID"),
      table_name: Map.fetch!(entity, "TAB_NAME"),
      reference_column_name: Map.fetch!(entity, "REF_COL_NAME"),
      reference_column_sequence_no: safe_str_to_int(Map.fetch!(entity, "REF_COL_SEQ_NO")),
      remark_text: Map.fetch!(entity, "REMARK")
    }
  end
end