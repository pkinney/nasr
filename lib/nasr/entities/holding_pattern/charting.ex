defmodule NASR.Entities.HoldingPattern.Charting do
  @moduledoc """
  Represents Holding Pattern/Fix Charting information from the NASR HPF_CHRT data.

  This entity contains information about which aeronautical charts display a specific 
  holding pattern. Holding patterns may appear on various types of charts including 
  Instrument Approach Procedures (IAP), Standard Terminal Arrival Routes (STAR), 
  Standard Instrument Departures (SID), and various enroute charts.

  Chart publication ensures that pilots have access to holding pattern information 
  during different phases of flight and provides standardized symbology for pattern 
  recognition and execution.

  ## Fields

  * `:effective_date` - The 28 Day NASR Subscription Effective Date in format 'YYYY/MM/DD'
  * `:hp_name` - Holding Pattern Name
  * `:hp_no` - Holding Pattern Number for the specific fix/navaid
  * `:state_code` - Associated State Post Office Code standard two letter abbreviation for US States and Territories
  * `:country_code` - Country Post Office Code where holding pattern is located
  * `:charting_type_desc` - Type of chart on which holding pattern appears. Values: `:approach`, `:departure`, `:enroute_high`, `:enroute_low`, `:military_approach`, `:star`, `:area_chart`
  """
  import NASR.Utils

  defstruct ~w(
    effective_date
    hp_name
    hp_no
    state_code
    country_code
    charting_type_desc
  )a

  @type t() :: %__MODULE__{
          effective_date: Date.t() | nil,
          hp_name: String.t(),
          hp_no: integer() | nil,
          state_code: String.t(),
          country_code: String.t(),
          charting_type_desc: :approach | :departure | :enroute_high | :enroute_low | :military_approach | :star | :area_chart | String.t() | nil
        }

  @spec type() :: String.t()
  def type, do: "HPF_CHRT"

  @spec new(map()) :: t()
  def new(entity) do
    %__MODULE__{
      effective_date: parse_date(Map.fetch!(entity, "EFF_DATE")),
      hp_name: Map.fetch!(entity, "HP_NAME"),
      hp_no: safe_str_to_int(Map.fetch!(entity, "HP_NO")),
      state_code: Map.fetch!(entity, "STATE_CODE"),
      country_code: Map.fetch!(entity, "COUNTRY_CODE"),
      charting_type_desc: parse_charting_type(Map.fetch!(entity, "CHARTING_TYPE_DESC"))
    }
  end

  defp parse_charting_type(nil), do: nil
  defp parse_charting_type(""), do: nil
  defp parse_charting_type(type) when is_binary(type) do
    case String.trim(type) do
      "IAP" -> :approach
      "DP" -> :departure
      "ENROUTE HIGH" -> :enroute_high
      "ENROUTE LOW" -> :enroute_low
      "MILITARY IAP" -> :military_approach
      "STAR" -> :star
      "AREA CHART" -> :area_chart
      other -> other
    end
  end
end