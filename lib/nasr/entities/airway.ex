defmodule NASR.Entities.Airway do
  @moduledoc """
  Represents Airway information from the NASR AWY_BASE data.

  Airways are established air traffic control routes between navigation aids
  and fixes that form the structure of the National Airspace System. The AWY_BASE
  file contains information about all types of airways including VOR airways,
  jet airways, GPS RNAV airways, and colored airways.

  ## Fields

  * `:effective_date` - The 28 Day NASR Subscription Effective Date in format 'YYYY/MM/DD'
  * `:regulatory` - Identifies Airways published under 14 CFR Part-71 and Part-95 (boolean: true for Y, false for N)
  * `:airway_designation` - Airway Designation. Values: `:amber`, `:atlantic`, `:blue`, `:bahama`, `:green`, `:jet`, `:pacific`, `:puerto_rico`, `:red`, `:gps_rnav`, `:vor`
  * `:airway_location` - Airway Type which identifies the General Location. Values: `:alaska`, `:hawaii`, `:contiguous_us`
  * `:airway_id` - Airway Identifier
  * `:update_date` - The Last Date for which the AIRWAY Data amended
  * `:remark` - Remark Text (Free Form Text that further describes a specific Information Item)
  * `:airway_string` - List of FIX and NAVAID that make up the AIRWAY in order adapted
  """
  import NASR.Utils

  defstruct ~w(
    effective_date
    regulatory
    airway_designation
    airway_location
    airway_id
    update_date
    remark
    airway_string
  )a

  @type t() :: %__MODULE__{
          effective_date: Date.t() | nil,
          regulatory: boolean() | nil,
          airway_designation: :amber | :atlantic | :blue | :bahama | :green | :jet | :pacific | :puerto_rico | :red | :gps_rnav | :vor | String.t() | nil,
          airway_location: :alaska | :hawaii | :contiguous_us | String.t() | nil,
          airway_id: String.t(),
          update_date: Date.t() | nil,
          remark: String.t(),
          airway_string: String.t()
        }

  @spec type() :: String.t()
  def type, do: "AWY_BASE"

  @spec new(map()) :: t()
  def new(entity) do
    %__MODULE__{
      effective_date: parse_date(Map.fetch!(entity, "EFF_DATE")),
      regulatory: convert_yn(Map.fetch!(entity, "REGULATORY")),
      airway_designation: parse_airway_designation(Map.fetch!(entity, "AWY_DESIGNATION")),
      airway_location: parse_airway_location(Map.fetch!(entity, "AWY_LOCATION")),
      airway_id: Map.fetch!(entity, "AWY_ID"),
      update_date: parse_date(Map.fetch!(entity, "UPDATE_DATE")),
      remark: Map.fetch!(entity, "REMARK"),
      airway_string: Map.fetch!(entity, "AIRWAY_STRING")
    }
  end

  defp parse_airway_designation(nil), do: nil
  defp parse_airway_designation(""), do: nil
  defp parse_airway_designation(designation) when is_binary(designation) do
    case String.trim(designation) do
      "A" -> :amber
      "AT" -> :atlantic
      "B" -> :blue
      "BF" -> :bahama
      "G" -> :green
      "J" -> :jet
      "PA" -> :pacific
      "PR" -> :puerto_rico
      "R" -> :red
      "RN" -> :gps_rnav
      "V" -> :vor
      other -> other
    end
  end

  defp parse_airway_location(nil), do: nil
  defp parse_airway_location(""), do: nil
  defp parse_airway_location(location) when is_binary(location) do
    case String.trim(location) do
      "A" -> :alaska
      "H" -> :hawaii
      "C" -> :contiguous_us
      other -> other
    end
  end
end