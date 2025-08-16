defmodule NASR.Entities.HoldingPattern.SpeedAltitude do
  @moduledoc """
  Represents Holding Pattern/Fix Speed and Altitude information from the NASR HPF_SPD_ALT data.

  This entity contains speed and altitude restrictions applicable to specific holding 
  patterns. Speed restrictions ensure that aircraft maintain appropriate airspeeds 
  for the holding pattern environment, considering factors such as aircraft category, 
  altitude, and airspace constraints.

  Altitude information defines the vertical limits within which the holding pattern 
  is authorized, ensuring appropriate obstacle clearance and separation from other 
  air traffic. These restrictions are critical for maintaining safe operations in 
  the holding pattern environment.

  ## Fields

  * `:effective_date` - The 28 Day NASR Subscription Effective Date in format 'YYYY/MM/DD'
  * `:hp_name` - Holding Pattern Name
  * `:hp_no` - Holding Pattern Number for the specific fix/navaid
  * `:state_code` - Associated State Post Office Code standard two letter abbreviation for US States and Territories
  * `:country_code` - Country Post Office Code where holding pattern is located
  * `:speed_range` - Maximum holding speed (knots indicated airspeed)
  * `:altitude` - Altitude range for holding pattern (format: "min/max" in hundreds of feet or flight levels)
  """
  import NASR.Utils

  defstruct ~w(
    effective_date
    hp_name
    hp_no
    state_code
    country_code
    speed_range
    altitude
  )a

  @type t() :: %__MODULE__{
          effective_date: Date.t() | nil,
          hp_name: String.t(),
          hp_no: integer() | nil,
          state_code: String.t(),
          country_code: String.t(),
          speed_range: integer() | nil,
          altitude: String.t()
        }

  @spec type() :: String.t()
  def type, do: "HPF_SPD_ALT"

  @spec new(map()) :: t()
  def new(entity) do
    %__MODULE__{
      effective_date: parse_date(Map.fetch!(entity, "EFF_DATE")),
      hp_name: Map.fetch!(entity, "HP_NAME"),
      hp_no: safe_str_to_int(Map.fetch!(entity, "HP_NO")),
      state_code: Map.fetch!(entity, "STATE_CODE"),
      country_code: Map.fetch!(entity, "COUNTRY_CODE"),
      speed_range: safe_str_to_int(Map.fetch!(entity, "SPEED_RANGE")),
      altitude: Map.fetch!(entity, "ALTITUDE")
    }
  end
end