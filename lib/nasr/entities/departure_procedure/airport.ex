defmodule NASR.Entities.DepartureProcedure.Airport do
  @moduledoc """
  Represents Departure Procedure Airport information from the NASR DP_APT data.

  This entity contains information about which airports and runway ends
  are associated with specific departure procedures, including the procedure
  body name and sequence information.

  ## Fields

  * `:effective_date` - The 28 Day NASR Subscription Effective Date in format 'YYYY/MM/DD'
  * `:departure_procedure_name` - Name of the departure procedure
  * `:artcc` - Air Route Traffic Control Center responsible for the procedure
  * `:departure_procedure_computer_code` - Computer code used for the procedure
  * `:body_name` - Name of the procedure body/transition
  * `:body_sequence` - Sequence number for the procedure body
  * `:airport_id` - Airport identifier where this procedure is available
  * `:runway_end_id` - Runway end identifier (or "ALL" for all runways)
  """
  import NASR.Utils

  defstruct ~w(
    effective_date
    departure_procedure_name
    artcc
    departure_procedure_computer_code
    body_name
    body_sequence
    airport_id
    runway_end_id
  )a

  @type t() :: %__MODULE__{
          effective_date: Date.t() | nil,
          departure_procedure_name: String.t(),
          artcc: String.t(),
          departure_procedure_computer_code: String.t(),
          body_name: String.t(),
          body_sequence: integer() | nil,
          airport_id: String.t(),
          runway_end_id: String.t()
        }

  @spec type() :: String.t()
  def type, do: "DP_APT"

  @spec new(map()) :: t()
  def new(entity) do
    %__MODULE__{
      effective_date: parse_date(Map.fetch!(entity, "EFF_DATE")),
      departure_procedure_name: Map.fetch!(entity, "DP_NAME"),
      artcc: Map.fetch!(entity, "ARTCC"),
      departure_procedure_computer_code: Map.fetch!(entity, "DP_COMPUTER_CODE"),
      body_name: Map.fetch!(entity, "BODY_NAME"),
      body_sequence: safe_str_to_int(Map.fetch!(entity, "BODY_SEQ")),
      airport_id: Map.fetch!(entity, "ARPT_ID"),
      runway_end_id: Map.fetch!(entity, "RWY_END_ID")
    }
  end
end