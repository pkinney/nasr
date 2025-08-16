defmodule NASR.Entities.MaximumAuthorizedAltitude.Control do
  @moduledoc """
  Represents Maximum Authorized Altitude Control information from the NASR MAA_CON data.

  This entity contains air traffic control frequency information for Maximum Authorized 
  Altitude areas. Control frequencies enable aircraft to coordinate with appropriate 
  air traffic control facilities when operating in or transiting through special use 
  airspace areas.

  The control information includes both commercial and military frequencies, allowing 
  for proper coordination between civilian and military aircraft operations within 
  the MAA areas. Different frequencies may be designated for different chart types 
  or operational scenarios.

  ## Fields

  * `:effective_date` - The 28 Day NASR Subscription Effective Date in format 'YYYY/MM/DD'
  * `:maa_id` - Maximum Authorized Altitude Identifier
  * `:freq_seq` - Frequency Sequence Number for multiple control frequencies
  * `:fac_id` - Air Traffic Control Facility Identifier
  * `:fac_name` - Air Traffic Control Facility Name
  * `:commercial_freq` - Commercial Air Traffic Control Frequency (MHz)
  * `:commercial_chart_flag` - Flag indicating if commercial frequency appears on charts. Values: `:yes`, `:no`
  * `:mil_freq` - Military Air Traffic Control Frequency (MHz)
  * `:mil_chart_flag` - Flag indicating if military frequency appears on charts. Values: `:yes`, `:no`
  """
  import NASR.Utils

  defstruct ~w(
    effective_date
    maa_id
    freq_seq
    fac_id
    fac_name
    commercial_freq
    commercial_chart_flag
    mil_freq
    mil_chart_flag
  )a

  @type t() :: %__MODULE__{
          effective_date: Date.t() | nil,
          maa_id: String.t(),
          freq_seq: integer() | nil,
          fac_id: String.t(),
          fac_name: String.t(),
          commercial_freq: float() | nil,
          commercial_chart_flag: :yes | :no | String.t() | nil,
          mil_freq: float() | nil,
          mil_chart_flag: :yes | :no | String.t() | nil
        }

  @spec type() :: String.t()
  def type, do: "MAA_CON"

  @spec new(map()) :: t()
  def new(entity) do
    %__MODULE__{
      effective_date: parse_date(Map.fetch!(entity, "EFF_DATE")),
      maa_id: Map.fetch!(entity, "MAA_ID"),
      freq_seq: safe_str_to_int(Map.fetch!(entity, "FREQ_SEQ")),
      fac_id: Map.fetch!(entity, "FAC_ID"),
      fac_name: Map.fetch!(entity, "FAC_NAME"),
      commercial_freq: safe_str_to_float(Map.fetch!(entity, "COMMERCIAL_FREQ")),
      commercial_chart_flag: parse_chart_flag(Map.fetch!(entity, "COMMERCIAL_CHART_FLAG")),
      mil_freq: safe_str_to_float(Map.fetch!(entity, "MIL_FREQ")),
      mil_chart_flag: parse_chart_flag(Map.fetch!(entity, "MIL_CHART_FLAG"))
    }
  end

  defp parse_chart_flag(nil), do: nil
  defp parse_chart_flag(""), do: nil
  defp parse_chart_flag(flag) when is_binary(flag) do
    case String.trim(flag) do
      "Y" -> :yes
      "N" -> :no
      other -> other
    end
  end
end