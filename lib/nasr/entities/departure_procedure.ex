defmodule NASR.Entities.DepartureProcedure do
  @moduledoc """
  Represents Departure Procedure information from the NASR DP_BASE data.

  Departure procedures (DPs), also known as Standard Instrument Departures (SIDs),
  are published departure routes that provide transition from the terminal area
  to the en route structure. They are designed to expedite clearance delivery,
  reduce pilot/controller workload, and provide obstacle clearance.

  ## Fields

  * `:effective_date` - The 28 Day NASR Subscription Effective Date in format 'YYYY/MM/DD'
  * `:departure_procedure_name` - Name of the departure procedure
  * `:amendment_number` - Amendment number for the procedure (e.g., "FIVE", "THREE")
  * `:artcc` - Air Route Traffic Control Center responsible for the procedure
  * `:departure_procedure_amendment_effective_date` - Date when the amendment became effective
  * `:rnav_flag` - Indicates if procedure is RNAV-based (boolean: true for Y, false for N)
  * `:departure_procedure_computer_code` - Computer code used for the procedure
  * `:graphical_departure_procedure_type` - Type of graphical departure procedure (SID=Standard Instrument Departure)
  * `:served_airports` - Space-separated list of airports served by this procedure
  """
  import NASR.Utils

  defstruct ~w(
    effective_date
    departure_procedure_name
    amendment_number
    artcc
    departure_procedure_amendment_effective_date
    rnav_flag
    departure_procedure_computer_code
    graphical_departure_procedure_type
    served_airports
  )a

  @type t() :: %__MODULE__{
          effective_date: Date.t() | nil,
          departure_procedure_name: String.t(),
          amendment_number: String.t(),
          artcc: String.t(),
          departure_procedure_amendment_effective_date: Date.t() | nil,
          rnav_flag: boolean() | nil,
          departure_procedure_computer_code: String.t(),
          graphical_departure_procedure_type: String.t(),
          served_airports: String.t()
        }

  @spec type() :: String.t()
  def type, do: "DP_BASE"

  @spec new(map()) :: t()
  def new(entity) do
    %__MODULE__{
      effective_date: parse_date(Map.fetch!(entity, "EFF_DATE")),
      departure_procedure_name: Map.fetch!(entity, "DP_NAME"),
      amendment_number: Map.fetch!(entity, "AMENDMENT_NO"),
      artcc: Map.fetch!(entity, "ARTCC"),
      departure_procedure_amendment_effective_date: parse_date(Map.fetch!(entity, "DP_AMEND_EFF_DATE")),
      rnav_flag: convert_yn(Map.fetch!(entity, "RNAV_FLAG")),
      departure_procedure_computer_code: Map.fetch!(entity, "DP_COMPUTER_CODE"),
      graphical_departure_procedure_type: Map.fetch!(entity, "GRAPHICAL_DP_TYPE"),
      served_airports: Map.fetch!(entity, "SERVED_ARPT")
    }
  end
end