defmodule NASR.Entities.FlightServiceStation.Remarks do
  @moduledoc """
  Represents Flight Service Station Remarks from the NASR FSS_RMK data.

  This entity contains free-form text remarks that provide additional information
  about Flight Service Station facilities, communication frequencies, operational
  procedures, service limitations, or other important information for pilots.
  These remarks supplement the base FSS data with operational details and special
  instructions.

  ## Fields

  * `:effective_date` - The 28 Day NASR Subscription Effective Date in format 'YYYY/MM/DD'
  * `:fss_id` - Flight Service Station Identifier. Unique 3-4 character alphanumeric identifier
  * `:name` - Flight Service Station Name
  * `:city` - Associated City Name where FSS is located
  * `:state_code` - Associated State Code standard two letter abbreviation for US States and Territories
  * `:country_code` - Country Code where FSS is located
  * `:reference_column_name` - NASR Column name associated with Remark (e.g., GENERAL_REMARK, PHONE_NO)
  * `:reference_column_sequence` - Sequential number for multiple remarks on the same column
  * `:remark_text` - Free form text that provides additional FSS information, frequencies, procedures, or operational notes
  """
  import NASR.Utils

  defstruct ~w(
    effective_date
    fss_id
    name
    city
    state_code
    country_code
    reference_column_name
    reference_column_sequence
    remark_text
  )a

  @type t() :: %__MODULE__{
          effective_date: Date.t() | nil,
          fss_id: String.t(),
          name: String.t(),
          city: String.t(),
          state_code: String.t(),
          country_code: String.t(),
          reference_column_name: String.t(),
          reference_column_sequence: integer() | nil,
          remark_text: String.t()
        }

  @spec type() :: String.t()
  def type(), do: "FSS_RMK"

  @spec new(map()) :: t()
  def new(entity) do
    %__MODULE__{
      effective_date: parse_date(Map.fetch!(entity, "EFF_DATE")),
      fss_id: Map.fetch!(entity, "FSS_ID"),
      name: Map.fetch!(entity, "NAME"),
      city: Map.fetch!(entity, "CITY"),
      state_code: Map.fetch!(entity, "STATE_CODE"),
      country_code: Map.fetch!(entity, "COUNTRY_CODE"),
      reference_column_name: Map.fetch!(entity, "REF_COL_NAME"),
      reference_column_sequence: safe_str_to_int(Map.fetch!(entity, "REF_COL_SEQ_NO")),
      remark_text: Map.fetch!(entity, "REMARK")
    }
  end
end