defmodule NASR.Entities.MilitaryOperations do
  @moduledoc """
  Represents Military Operations information from the NASR MIL_OPS data.

  Military Operations facilities provide essential aviation services at military airfields and
  installations throughout the United States. These facilities coordinate military aviation
  activities, maintain airfield operations, and provide services such as air traffic control,
  weather observation, and flight operations support.

  ## Fields

  * `:effective_date` - The 28 Day NASR Subscription Effective Date in format 'YYYY/MM/DD'
  * `:site_number` - Unique numeric identifier for the site
  * `:site_type_code` - Site Type Code. Values: `:airport`, `:heliport`, `:seaplane_base`, `:gliderport`, `:balloonport`, `:ultralight`
  * `:state_code` - Associated State Post Office Code standard two letter abbreviation for US States and Territories
  * `:airport_id` - Airport Identifier (ICAO or LID)
  * `:city` - City where the military facility is located
  * `:country_code` - Country Post Office Code where facility is located
  * `:military_operations_code` - Military Operations Type Code. Values: `:active`, `:restricted`, `:none`
  * `:military_operations_call` - Military Operations Call Sign or Identifier
  * `:military_operations_hours` - Hours of military operations
  * `:amcp_hours` - Airport Movement Control Point (AMCP) operating hours
  * `:pmsv_hours` - Pilot to Metro Service (PMSV) operating hours
  * `:remark` - Additional remarks or operational information
  """
  import NASR.Utils

  defstruct ~w(
    effective_date
    site_number
    site_type_code
    state_code
    airport_id
    city
    country_code
    military_operations_code
    military_operations_call
    military_operations_hours
    amcp_hours
    pmsv_hours
    remark
  )a

  @type t() :: %__MODULE__{
          effective_date: Date.t() | nil,
          site_number: String.t(),
          site_type_code: :airport | :heliport | :seaplane_base | :gliderport | :balloonport | :ultralight | String.t() | nil,
          state_code: String.t(),
          airport_id: String.t(),
          city: String.t(),
          country_code: String.t(),
          military_operations_code: :active | :restricted | :none | String.t() | nil,
          military_operations_call: String.t(),
          military_operations_hours: String.t(),
          amcp_hours: String.t(),
          pmsv_hours: String.t(),
          remark: String.t()
        }

  @spec type() :: String.t()
  def type, do: "MIL_OPS"

  @spec new(map()) :: t()
  def new(entity) do
    %__MODULE__{
      effective_date: parse_date(Map.fetch!(entity, "EFF_DATE")),
      site_number: Map.fetch!(entity, "SITE_NO"),
      site_type_code: parse_site_type_code(Map.fetch!(entity, "SITE_TYPE_CODE")),
      state_code: Map.fetch!(entity, "STATE_CODE"),
      airport_id: Map.fetch!(entity, "ARPT_ID"),
      city: Map.fetch!(entity, "CITY"),
      country_code: Map.fetch!(entity, "COUNTRY_CODE"),
      military_operations_code: parse_military_operations_code(Map.fetch!(entity, "MIL_OPS_OPER_CODE")),
      military_operations_call: Map.fetch!(entity, "MIL_OPS_CALL"),
      military_operations_hours: Map.fetch!(entity, "MIL_OPS_HRS"),
      amcp_hours: Map.fetch!(entity, "AMCP_HRS"),
      pmsv_hours: Map.fetch!(entity, "PMSV_HRS"),
      remark: Map.fetch!(entity, "REMARK")
    }
  end

  defp parse_site_type_code(nil), do: nil
  defp parse_site_type_code(""), do: nil
  defp parse_site_type_code(code) when is_binary(code) do
    case String.trim(code) do
      "A" -> :airport
      "H" -> :heliport
      "S" -> :seaplane_base
      "G" -> :gliderport
      "B" -> :balloonport
      "U" -> :ultralight
      other -> other
    end
  end

  defp parse_military_operations_code(nil), do: nil
  defp parse_military_operations_code(""), do: nil
  defp parse_military_operations_code(code) when is_binary(code) do
    case String.trim(code) do
      "A" -> :active
      "R" -> :restricted
      "N" -> :none
      other -> other
    end
  end
end