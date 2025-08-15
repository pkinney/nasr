defmodule NASR.Entities.Fix.ChartingInformation do
  @moduledoc """
  Represents Fix Charting Information from the NASR FIX_CHRT data.

  This entity contains information about which charts a specific fix appears on.
  Each record represents one chart type that displays the fix.

  ## Fields

  * `:fix_id` - Fixed Geographical Position Identifier (5 characters)
  * `:icao_region_code` - ICAO Code where first letter refers to country, second discerns region
  * `:state_code` - Associated State Post Office Code (standard two letter abbreviation)
  * `:country_code` - Country Post Office Code
  * `:charting_type_desc` - Chart on which Fix is to be depicted (e.g., "CONTROLLER LOW", "ENROUTE LOW", "IAP", "STAR")
  * `:eff_date` - The 28 Day NASR Subscription Effective Date

  ## Data Source

  This data comes from the FAA's National Airspace System Resources (NASR) subscription,
  specifically from the FIX_CHRT.csv file. The data is updated on a 28-day cycle.
  """
  import NASR.Utils

  defstruct ~w(
    fix_id
    icao_region_code
    state_code
    country_code
    charting_type_desc
    eff_date
  )a

  @type t() :: %__MODULE__{}

  @spec new(map()) :: t()
  def new(entity) do
    %__MODULE__{
      fix_id: Map.fetch!(entity, "FIX_ID"),
      icao_region_code: Map.fetch!(entity, "ICAO_REGION_CODE"),
      state_code: Map.fetch!(entity, "STATE_CODE"),
      country_code: Map.fetch!(entity, "COUNTRY_CODE"),
      charting_type_desc: Map.fetch!(entity, "CHARTING_TYPE_DESC"),
      eff_date: parse_date(Map.fetch!(entity, "EFF_DATE"))
    }
  end

  @spec type() :: String.t()
  def type(), do: "FIX_CHRT"
end