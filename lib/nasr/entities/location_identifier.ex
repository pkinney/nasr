defmodule NASR.Entities.LocationIdentifier do
  @moduledoc """
  Represents Location Identifier (LID) information from the NASR LID data.

  The Location Identifier file contains information about aviation facilities and locations
  within the National Airspace System. This includes airports, heliports, navaids,
  weather stations, and other aviation-related facilities.

  ## Fields

  * `:location_id` - Location Identifier (3-5 character unique identifier)
  * `:country_code` - Country Post Office Code (usually "US")
  * `:region_code` - Regional identifier (AAL, ACE, AEA, AGL, ANM, ASO, ASW, AWP)
  * `:state` - State abbreviation
  * `:city` - Associated city name
  * `:lid_group` - Location identifier group type (Landing Facility, Navigation Aid, etc.)
  * `:facility_type` - Specific facility type (A=Airport, H=Heliport, AWOS, VOR, etc.)
  * `:facility_name` - Full name of the facility
  * `:responsible_artcc_id` - Air Route Traffic Control Center identifier
  * `:artcc_computer_id` - ARTCC computer identifier
  * `:fss_id` - Flight Service Station identifier
  * `:effective_date` - The 28 Day NASR Subscription Effective Date

  ## Location Groups

  Common LID groups include:
  * `:landing_facility` - Airports and heliports
  * `:navigation_aid` - VORs, NDBs, TACANs, etc.
  * `:control_facility` - ATC facilities
  * `:weather_reporting_station` - AWOS, ASOS stations
  * `:weather_sensor` - Weather observation equipment
  * `:instrument_landing_system` - ILS facilities
  * `:remote_communication_outlet` - RCO stations
  * `:special_use_resource` - Special use airspace
  * `:flight_service_station` - FSS facilities

  ## Facility Types

  Common facility types:
  * `A` - Airport (public use)
  * `H` - Heliport
  * `VOR` - VHF Omnidirectional Range
  * `VORTAC` - VOR/TACAN combined
  * `NDB` - Non-Directional Beacon
  * `AWOS-*` - Automated Weather Observing System variants
  * `ASOS` - Automated Surface Observing System

  ## Data Source

  This data comes from the FAA's National Airspace System Resources (NASR) subscription,
  specifically from the LID.csv file. The data is updated on a 28-day cycle.
  """
  import NASR.Utils

  defstruct ~w(
    location_id
    country_code
    region_code
    state
    city
    lid_group
    facility_type
    facility_name
    responsible_artcc_id
    artcc_computer_id
    fss_id
    effective_date
  )a

  @type t() :: %__MODULE__{
          location_id: String.t(),
          country_code: String.t(),
          region_code: String.t(),
          state: String.t(),
          city: String.t(),
          lid_group: :landing_facility | :navigation_aid | :control_facility | :weather_reporting_station | :weather_sensor | :instrument_landing_system | :remote_communication_outlet | :special_use_resource | :flight_service_station | :dod_oversea_facility | String.t() | nil,
          facility_type: String.t(),
          facility_name: String.t(),
          responsible_artcc_id: String.t(),
          artcc_computer_id: String.t(),
          fss_id: String.t(),
          effective_date: Date.t() | nil
        }

  @spec type() :: String.t()
  def type, do: "LID"

  @spec new(map()) :: t()
  def new(entity) do
    %__MODULE__{
      location_id: Map.fetch!(entity, "LOC_ID"),
      country_code: Map.fetch!(entity, "COUNTRY_CODE"),
      region_code: Map.fetch!(entity, "REGION_CODE"),
      state: Map.fetch!(entity, "STATE"),
      city: Map.fetch!(entity, "CITY"),
      lid_group: parse_lid_group(Map.fetch!(entity, "LID_GROUP")),
      facility_type: Map.fetch!(entity, "FAC_TYPE"),
      facility_name: Map.fetch!(entity, "FAC_NAME"),
      responsible_artcc_id: Map.fetch!(entity, "RESP_ARTCC_ID"),
      artcc_computer_id: Map.fetch!(entity, "ARTCC_COMPUTER_ID"),
      fss_id: Map.fetch!(entity, "FSS_ID"),
      effective_date: parse_date(Map.fetch!(entity, "EFF_DATE"))
    }
  end

  defp parse_lid_group(nil), do: nil
  defp parse_lid_group(""), do: nil

  defp parse_lid_group(group) when is_binary(group) do
    group
    |> String.trim()
    |> String.upcase()
    |> case do
      "LANDING FACILITY" -> :landing_facility
      "NAVIGATION AID" -> :navigation_aid
      "CONTROL FACILITY" -> :control_facility
      "WEATHER REPORTING STATION" -> :weather_reporting_station
      "WEATHER SENSOR" -> :weather_sensor
      "INSTRUMENT LANDING SYSTEM" -> :instrument_landing_system
      "REMOTE COMMUNICATION OUTLET" -> :remote_communication_outlet
      "SPECIAL USE RESOURCE" -> :special_use_resource
      "FLIGHT SERVICE STATION" -> :flight_service_station
      "DOD OVERSEA FACILITY" -> :dod_oversea_facility
      other -> other
    end
  end
end