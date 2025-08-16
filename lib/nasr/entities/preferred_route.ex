defmodule NASR.Entities.PreferredRoute do
  @moduledoc """
  Represents Preferred Route Base information from the NASR PFR_BASE data.

  This entity contains information about preferred routes which are published
  instrument flight rule (IFR) routes between specific airports that have been
  established through operational analysis and coordination among Air Route
  Traffic Control Centers (ARTCCs), approach control facilities, and airport
  traffic control towers.

  Preferred routes are designed to minimize aircraft delays, reduce controller
  workload, and provide predictable routing for air traffic control and pilots.
  They include Terminal Area Charts (TEC) routes, which are pre-coordinated
  routes within or between terminal areas.

  The PFR_BASE file contains the base information for each preferred route,
  including origin and destination airports, route characteristics, and
  operational parameters.

  ## Fields

  * `:eff_date` - Effective Date of the route information
  * `:origin_id` - Origin Airport Identifier
  * `:origin_city` - Origin Airport City
  * `:origin_state_code` - Origin Airport State Code (US State/Territory abbreviation)
  * `:origin_country_code` - Origin Airport Country Code
  * `:dstn_id` - Destination Airport Identifier
  * `:dstn_city` - Destination Airport City
  * `:dstn_state_code` - Destination Airport State Code
  * `:dstn_country_code` - Destination Airport Country Code
  * `:pfr_type_code` - Preferred Route Type Code (e.g., "TEC" for Terminal Area Chart routes)
  * `:route_no` - Route Number for multiple routes between same origin/destination pair
  * `:special_area_descrip` - Special Area Description for route restrictions or conditions
  * `:alt_descrip` - Altitude Description specifying altitude constraints
  * `:aircraft` - Aircraft Type restrictions or specifications
  * `:hours` - Hours of operation or time restrictions
  * `:route_dir_descrip` - Route Direction Description
  * `:designator` - Route Designator
  * `:nar_type` - North Atlantic Route (NAR) Type designation
  * `:inland_fac_fix` - Inland Facility Fix
  * `:coastal_fix` - Coastal Fix for oceanic routes
  * `:destination` - Destination specification
  * `:route_string` - Complete route string with waypoints and airways

  ## Aviation Context

  Preferred routes serve several important functions in the National Airspace System:

  - **Traffic Flow Management**: Standardized routing reduces complexity and improves predictability
  - **Delay Reduction**: Pre-coordinated routes minimize the need for tactical route amendments
  - **Controller Workload**: Standard routes reduce coordination requirements between facilities
  - **Pilot Planning**: Published routes assist in flight planning and reduce clearance delivery time
  - **Terminal Area Efficiency**: TEC routes provide efficient routing within complex terminal areas

  Route types include:
  - **TEC Routes**: Terminal Area Chart routes for flights within or between terminal areas
  - **High Altitude Routes**: For flights above FL240
  - **Low Altitude Routes**: For flights below FL240
  - **RNAV Routes**: Area Navigation routes using GPS/RNAV capabilities
  """

  import NASR.Utils

  @type t() :: %__MODULE__{
          eff_date: Date.t() | nil,
          origin_id: String.t() | nil,
          origin_city: String.t() | nil,
          origin_state_code: String.t() | nil,
          origin_country_code: String.t() | nil,
          dstn_id: String.t() | nil,
          dstn_city: String.t() | nil,
          dstn_state_code: String.t() | nil,
          dstn_country_code: String.t() | nil,
          pfr_type_code: atom() | nil,
          route_no: integer() | nil,
          special_area_descrip: String.t() | nil,
          alt_descrip: String.t() | nil,
          aircraft: String.t() | nil,
          hours: String.t() | nil,
          route_dir_descrip: String.t() | nil,
          designator: String.t() | nil,
          nar_type: String.t() | nil,
          inland_fac_fix: String.t() | nil,
          coastal_fix: String.t() | nil,
          destination: String.t() | nil,
          route_string: String.t() | nil
        }

  defstruct [
    :eff_date,
    :origin_id,
    :origin_city,
    :origin_state_code,
    :origin_country_code,
    :dstn_id,
    :dstn_city,
    :dstn_state_code,
    :dstn_country_code,
    :pfr_type_code,
    :route_no,
    :special_area_descrip,
    :alt_descrip,
    :aircraft,
    :hours,
    :route_dir_descrip,
    :designator,
    :nar_type,
    :inland_fac_fix,
    :coastal_fix,
    :destination,
    :route_string
  ]

  @spec type() :: String.t()
  def type, do: "PFR_BASE"

  @spec new(map()) :: t()
  def new(data), do: from_csv(data)

  @spec from_csv(map()) :: t()
  def from_csv(data) do
    %__MODULE__{
      eff_date: parse_date(data["EFF_DATE"]),
      origin_id: clean_string(data["ORIGIN_ID"]),
      origin_city: clean_string(data["ORIGIN_CITY"]),
      origin_state_code: clean_string(data["ORIGIN_STATE_CODE"]),
      origin_country_code: clean_string(data["ORIGIN_COUNTRY_CODE"]),
      dstn_id: clean_string(data["DSTN_ID"]),
      dstn_city: clean_string(data["DSTN_CITY"]),
      dstn_state_code: clean_string(data["DSTN_STATE_CODE"]),
      dstn_country_code: clean_string(data["DSTN_COUNTRY_CODE"]),
      pfr_type_code: parse_route_type(data["PFR_TYPE_CODE"]),
      route_no: safe_str_to_int(data["ROUTE_NO"]),
      special_area_descrip: clean_string(data["SPECIAL_AREA_DESCRIP"]),
      alt_descrip: clean_string(data["ALT_DESCRIP"]),
      aircraft: clean_string(data["AIRCRAFT"]),
      hours: clean_string(data["HOURS"]),
      route_dir_descrip: clean_string(data["ROUTE_DIR_DESCRIP"]),
      designator: clean_string(data["DESIGNATOR"]),
      nar_type: clean_string(data["NAR_TYPE"]),
      inland_fac_fix: clean_string(data["INLAND_FAC_FIX"]),
      coastal_fix: clean_string(data["COASTAL_FIX"]),
      destination: clean_string(data["DESTINATION"]),
      route_string: clean_string(data["ROUTE_STRING"])
    }
  end

  defp clean_string(""), do: nil
  defp clean_string(nil), do: nil
  defp clean_string(str), do: String.trim(str)

  defp parse_route_type("TEC"), do: :tec
  defp parse_route_type("NAR"), do: :nar
  defp parse_route_type("PREF"), do: :pref
  defp parse_route_type("HIGH"), do: :high
  defp parse_route_type("LOW"), do: :low
  defp parse_route_type("RNAV"), do: :rnav
  defp parse_route_type(nil), do: nil
  defp parse_route_type(""), do: nil
  defp parse_route_type(code) when is_binary(code), do: String.downcase(code) |> String.to_atom()
  defp parse_route_type(_), do: nil
end