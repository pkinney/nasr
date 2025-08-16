defmodule NASR.Entities.STAR do
  @moduledoc """
  Represents Standard Terminal Arrival Route (STAR) information from the NASR STAR_BASE data.

  STARs are published arrival routes that provide transition from the en route
  structure to the terminal area. They are designed to expedite air traffic flow,
  reduce pilot/controller workload, and provide predictable routing for arrivals
  into busy terminal areas.

  ## Fields

  * `:effective_date` - The 28 Day NASR Subscription Effective Date in format 'YYYY/MM/DD'
  * `:arrival_name` - Name of the STAR procedure
  * `:amendment_number` - Amendment number for the procedure (e.g., "TWO", "FOUR")
  * `:artcc` - Air Route Traffic Control Center responsible for the procedure
  * `:star_amendment_effective_date` - Date when the amendment became effective
  * `:rnav_flag` - Indicates if procedure is RNAV-based (boolean: true for Y, false for N)
  * `:star_computer_code` - Computer code used for the STAR procedure
  * `:served_airports` - Space-separated list of airports served by this STAR
  """
  import NASR.Utils

  defstruct ~w(
    effective_date
    arrival_name
    amendment_number
    artcc
    star_amendment_effective_date
    rnav_flag
    star_computer_code
    served_airports
  )a

  @type t() :: %__MODULE__{
          effective_date: Date.t() | nil,
          arrival_name: String.t(),
          amendment_number: String.t(),
          artcc: String.t(),
          star_amendment_effective_date: Date.t() | nil,
          rnav_flag: boolean() | nil,
          star_computer_code: String.t(),
          served_airports: String.t()
        }

  @spec type() :: String.t()
  def type, do: "STAR_BASE"

  @spec new(map()) :: t()
  def new(entity) do
    %__MODULE__{
      effective_date: parse_date(Map.fetch!(entity, "EFF_DATE")),
      arrival_name: Map.fetch!(entity, "ARRIVAL_NAME"),
      amendment_number: Map.fetch!(entity, "AMENDMENT_NO"),
      artcc: Map.fetch!(entity, "ARTCC"),
      star_amendment_effective_date: parse_date(Map.fetch!(entity, "STAR_AMEND_EFF_DATE")),
      rnav_flag: convert_yn(Map.fetch!(entity, "RNAV_FLAG")),
      star_computer_code: Map.fetch!(entity, "STAR_COMPUTER_CODE"),
      served_airports: Map.fetch!(entity, "SERVED_ARPT")
    }
  end
end