defmodule NASR.Entities.ParachuteJumpingArea.Contact do
  @moduledoc """
  Represents Parachute Jumping Area Contact information from the NASR PJA_CON data.

  This entity contains communication frequency and contact information for
  Parachute Jumping Areas (PJAs). It specifies which air traffic control
  facilities and frequencies should be used when operating in or near
  parachute jumping areas.

  ## Contact Types

  * **Commercial Frequencies** - Frequencies for civilian aircraft operations
  * **Military Frequencies** - Frequencies for military aircraft operations
  * **Charted Frequencies** - Frequencies published on aeronautical charts

  ## Fields

  * `:effective_date` - The 28 Day NASR Subscription Effective Date in format 'YYYY/MM/DD'
  * `:pja_id` - Parachute Jumping Area identifier (references PJA_BASE)
  * `:facility_id` - Air traffic control facility identifier
  * `:facility_name` - Name of the air traffic control facility
  * `:location_id` - Location identifier for the facility
  * `:commercial_frequency` - Commercial communication frequency in MHz
  * `:commercial_chart_flag` - Whether commercial frequency is charted (boolean)
  * `:military_frequency` - Military communication frequency in MHz
  * `:military_chart_flag` - Whether military frequency is charted (boolean)
  * `:sector` - Sector designation within the facility
  * `:contact_frequency_altitude` - Altitude restrictions for frequency usage
  """
  import NASR.Utils

  defstruct ~w(
    effective_date
    pja_id
    facility_id
    facility_name
    location_id
    commercial_frequency
    commercial_chart_flag
    military_frequency
    military_chart_flag
    sector
    contact_frequency_altitude
  )a

  @type t() :: %__MODULE__{
          effective_date: Date.t() | nil,
          pja_id: String.t(),
          facility_id: String.t(),
          facility_name: String.t(),
          location_id: String.t(),
          commercial_frequency: float() | nil,
          commercial_chart_flag: boolean() | nil,
          military_frequency: float() | nil,
          military_chart_flag: boolean() | nil,
          sector: String.t(),
          contact_frequency_altitude: String.t()
        }

  @spec type() :: String.t()
  def type, do: "PJA_CON"

  @spec new(map()) :: t()
  def new(entity) do
    %__MODULE__{
      effective_date: parse_date(Map.fetch!(entity, "EFF_DATE")),
      pja_id: Map.fetch!(entity, "PJA_ID"),
      facility_id: Map.fetch!(entity, "FAC_ID"),
      facility_name: Map.fetch!(entity, "FAC_NAME"),
      location_id: Map.fetch!(entity, "LOC_ID"),
      commercial_frequency: safe_str_to_float(Map.fetch!(entity, "COMMERCIAL_FREQ")),
      commercial_chart_flag: convert_yn(Map.fetch!(entity, "COMMERCIAL_CHART_FLAG")),
      military_frequency: safe_str_to_float(Map.fetch!(entity, "MIL_FREQ")),
      military_chart_flag: convert_yn(Map.fetch!(entity, "MIL_CHART_FLAG")),
      sector: Map.fetch!(entity, "SECTOR"),
      contact_frequency_altitude: Map.fetch!(entity, "CONTACT_FREQ_ALTITUDE")
    }
  end
end