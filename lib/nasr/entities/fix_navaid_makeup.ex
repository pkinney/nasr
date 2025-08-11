defmodule NASR.Entities.FixNavaidMakeup do
  @moduledoc """
  Represents Fix NAVAID Makeup from the NASR FIX_NAV data.

  This entity contains information about how a fix is defined in relation to navigation aids.
  A fix can be defined by its bearing and distance from one or more NAVAIDs.

  ## Fields

  * `:fix_id` - Fixed Geographical Position Identifier (5 characters)
  * `:icao_region_code` - ICAO Code where first letter refers to country, second discerns region
  * `:state_code` - Associated State Post Office Code (standard two letter abbreviation)
  * `:country_code` - Country Post Office Code
  * `:nav_id` - NAVAID Identifier (the navigation aid used to define this fix)
  * `:nav_type` - Facility Type of the NAVAID
  * `:bearing` - Bearing, Radial, Direction or Course from the NAVAID (degrees)
  * `:distance` - DME Distance from Facility (nautical miles)
  * `:eff_date` - The 28 Day NASR Subscription Effective Date

  ## Data Source

  This data comes from the FAA's National Airspace System Resources (NASR) subscription,
  specifically from the FIX_NAV.csv file. The data is updated on a 28-day cycle.
  """
  import NASR.Utils

  defstruct ~w(
    fix_id
    icao_region_code
    state_code
    country_code
    nav_id
    nav_type
    bearing
    distance
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
      nav_id: Map.fetch!(entity, "NAV_ID"),
      nav_type: Map.fetch!(entity, "NAV_TYPE"),
      bearing: safe_str_to_float(Map.fetch!(entity, "BEARING")),
      distance: safe_str_to_float(Map.fetch!(entity, "DISTANCE")),
      eff_date: parse_date(Map.fetch!(entity, "EFF_DATE"))
    }
  end

  @spec type() :: String.t()
  def type(), do: "FIX_NAV"
end