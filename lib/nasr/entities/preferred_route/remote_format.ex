defmodule NASR.Entities.PreferredRoute.RemoteFormat do
  @moduledoc """
  Represents Preferred Route Remote Format information from the NASR PFR_RMT_FMT data.

  This entity contains simplified formatting information for preferred routes that
  is specifically designed for remote systems and automated processing. It provides
  a streamlined representation of preferred route data that focuses on essential
  routing information while maintaining compatibility with various air traffic
  management systems.

  The remote format is commonly used for:
  - Automated flight planning systems
  - Third-party aviation applications
  - Data exchange between different ATC systems
  - Mobile and web-based route planning tools

  This format complements the base preferred route data by providing an
  alternative representation that emphasizes machine readability and
  simplified processing requirements.

  ## Fields

  * `:orig` - Origin Airport Identifier (3-4 character code)
  * `:route_string` - Complete route string with waypoints, airways, and procedures
  * `:dest` - Destination Airport Identifier (3-4 character code)
  * `:hours1` - Hours of operation or time restrictions
  * `:type` - Route type designation (e.g., "TEC", "PREF", "HIGH", "LOW")
  * `:area` - Special area description or routing restrictions
  * `:altitude` - Altitude constraints or recommendations
  * `:aircraft` - Aircraft type restrictions or performance requirements
  * `:direction` - Direction of flight or route directionality
  * `:seq` - Sequence number for multiple routes between same city pairs
  * `:dcntr` - Departure Center (ARTCC responsible for departure coordination)
  * `:acntr` - Arrival Center (ARTCC responsible for arrival coordination)

  ## Aviation Context

  The remote format serves several key purposes in modern aviation systems:

  - **System Integration**: Simplified format facilitates integration with various
    flight management and planning systems
  - **Data Distribution**: Streamlined structure supports efficient data distribution
    to multiple consumers
  - **Mobile Applications**: Optimized for bandwidth-constrained environments
  - **Automated Processing**: Designed for machine parsing and route validation
  - **Center Coordination**: Includes departure and arrival center information
    for inter-facility coordination

  The format maintains essential routing information while reducing complexity
  for systems that don't require the full detail of the base preferred route data.
  """

  import NASR.Utils

  @type t() :: %__MODULE__{
          orig: String.t() | nil,
          route_string: String.t() | nil,
          dest: String.t() | nil,
          hours1: String.t() | nil,
          type: atom() | nil,
          area: String.t() | nil,
          altitude: String.t() | nil,
          aircraft: String.t() | nil,
          direction: String.t() | nil,
          seq: integer() | nil,
          dcntr: String.t() | nil,
          acntr: String.t() | nil
        }

  defstruct [
    :orig,
    :route_string,
    :dest,
    :hours1,
    :type,
    :area,
    :altitude,
    :aircraft,
    :direction,
    :seq,
    :dcntr,
    :acntr
  ]

  @spec type() :: String.t()
  def type, do: "PFR_RMT_FMT"

  @spec new(map()) :: t()
  def new(data), do: from_csv(data)

  @spec from_csv(map()) :: t()
  def from_csv(data) do
    %__MODULE__{
      orig: clean_string(data["Orig"]),
      route_string: clean_string(data["Route String"]),
      dest: clean_string(data["Dest"]),
      hours1: clean_string(data["Hours1"]),
      type: parse_route_type(data["Type"]),
      area: clean_string(data["Area"]),
      altitude: clean_string(data["Altitude"]),
      aircraft: clean_string(data["Aircraft"]),
      direction: clean_string(data["Direction"]),
      seq: safe_str_to_int(data["Seq"]),
      dcntr: clean_string(data["DCNTR"]),
      acntr: clean_string(data["ACNTR"])
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