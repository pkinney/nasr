defmodule NASR.Entities.Airport.ArrestingSystems do
  @moduledoc """
  Represents Airport Arresting Systems from the NASR APT_ARS data.

  This entity contains information about aircraft arresting devices installed
  at airport runway ends, typically jet arresting barriers.

  ## Fields

  * `:site_no` - Landing Facility Site Number (unique identifying number)
  * `:site_type_code` - Landing Facility Type Code
  * `:arpt_id` - Location Identifier (unique 3-4 character alphanumeric identifier)
  * `:city` - Airport Associated City Name
  * `:state_code` - Associated State Post Office Code
  * `:country_code` - Country Post Office Code
  * `:runway_id` - Runway Identification
  * `:runway_end_id` - Runway End Identifier (the runway end described by the arresting system)
  * `:arresting_device_type` - Type of Aircraft Arresting Device (e.g., BAK-6, BAK-9, BAK-12, etc.)
  * `:eff_date` - The 28 Day NASR Subscription Effective Date

  ## Arresting Device Types

  The arresting device types include various BAK (Barrier Arresting Kit) systems:
  - BAK-6, BAK-9, BAK-12, BAK-12B, BAK-13, BAK-14
  - E5, E5-1, E27, E27B, E28, E28B
  - EMAS (Engineered Material Arresting System)
  - M21, MA-1, MA-1A, MA-1A MOD

  ## Data Source

  This data comes from the FAA's National Airspace System Resources (NASR) subscription,
  specifically from the APT_ARS.csv file. The data is updated on a 28-day cycle.
  """
  import NASR.Utils

  defstruct ~w(
    site_no
    site_type_code
    arpt_id
    city
    state_code
    country_code
    runway_id
    runway_end_id
    arresting_device_type
    eff_date
  )a

  @type t() :: %__MODULE__{}

  @spec new(map()) :: t()
  def new(entity) do
    %__MODULE__{
      site_no: Map.fetch!(entity, "SITE_NO"),
      site_type_code: Map.fetch!(entity, "SITE_TYPE_CODE"),
      arpt_id: Map.fetch!(entity, "ARPT_ID"),
      city: Map.fetch!(entity, "CITY"),
      state_code: Map.fetch!(entity, "STATE_CODE"),
      country_code: Map.fetch!(entity, "COUNTRY_CODE"),
      runway_id: Map.fetch!(entity, "RWY_ID"),
      runway_end_id: Map.fetch!(entity, "RWY_END_ID"),
      arresting_device_type: parse_arresting_device_type(Map.fetch!(entity, "ARREST_DEVICE_CODE")),
      eff_date: parse_date(Map.fetch!(entity, "EFF_DATE"))
    }
  end

  @spec type() :: String.t()
  def type(), do: "APT_ARS"

  defp parse_arresting_device_type(nil), do: nil
  defp parse_arresting_device_type(""), do: nil
  defp parse_arresting_device_type(device) when is_binary(device) do
    device
    |> String.trim()
    |> case do
      "BAK-6" -> :bak_6
      "BAK-9" -> :bak_9
      "BAK-12" -> :bak_12
      "BAK-12B" -> :bak_12b
      "BAK-13" -> :bak_13
      "BAK-14" -> :bak_14
      "E5" -> :e5
      "E5-1" -> :e5_1
      "E27" -> :e27
      "E27B" -> :e27b
      "E28" -> :e28
      "E28B" -> :e28b
      "EMAS" -> :emas
      "M21" -> :m21
      "MA-1" -> :ma_1
      "MA-1A" -> :ma_1a
      "MA-1A MOD" -> :ma_1a_mod
      other -> other
    end
  end
end