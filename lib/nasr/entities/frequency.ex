defmodule NASR.Entities.Frequency do
  @moduledoc """
  Represents Frequency information from the NASR FRQ data.

  This entity contains information about radio frequencies used by aviation facilities
  including airports, navigation aids, and communication facilities. It includes details
  about frequency usage, facility information, and operational data for various types
  of aviation communication and navigation services.

  ## Fields

  * `:effective_date` - The 28 Day NASR Subscription Effective Date in format 'YYYY/MM/DD'
  * `:facility` - Facility Identifier
  * `:fac_name` - Facility Name
  * `:facility_type` - Facility Type. Values: `:atct`, `:non_atct`, `:asos_awos`
  * `:artcc_or_fss_id` - Associated ARTCC or FSS Identifier
  * `:cpdlc` - Controller Pilot Data Link Communications capability
  * `:tower_hrs` - Tower Hours of Operation
  * `:serviced_facility` - Serviced Facility Identifier
  * `:serviced_fac_name` - Serviced Facility Name
  * `:serviced_site_type` - Serviced Site Type. Values: `:airport`, `:balloonport`, `:seaplane_base`, `:gliderport`, `:heliport`, `:ultralight`, `:awos_1`, `:awos_2`, `:awos_3`, `:awos_a`, `:awos_av`, `:asos`
  * `:latitude` - Serviced Facility Latitude in Decimal Format
  * `:longitude` - Serviced Facility Longitude in Decimal Format
  * `:serviced_city` - Serviced Facility City
  * `:serviced_state` - Serviced Facility State Code
  * `:serviced_country` - Serviced Facility Country Code
  * `:tower_or_comm_call` - Tower or Communication Call Sign
  * `:primary_approach_radio_call` - Primary Approach Radio Call Sign
  * `:frequency` - Frequency in MHz
  * `:sectorization` - Frequency Sectorization information
  * `:freq_use` - Frequency Use Type. Values: `:approach`, `:arrival`, `:atis`, `:clearance_delivery`, `:ctaf`, `:departure`, `:emergency`, `:ground`, `:multicom`, `:tower`, `:unicom`, `:awos`, `:asos`
  * `:remark` - Remarks associated with frequency
  """
  import NASR.Utils

  defstruct ~w(
    effective_date
    facility
    fac_name
    facility_type
    artcc_or_fss_id
    cpdlc
    tower_hrs
    serviced_facility
    serviced_fac_name
    serviced_site_type
    latitude
    longitude
    serviced_city
    serviced_state
    serviced_country
    tower_or_comm_call
    primary_approach_radio_call
    frequency
    sectorization
    freq_use
    remark
  )a

  @type t() :: %__MODULE__{
          effective_date: Date.t() | nil,
          facility: String.t(),
          fac_name: String.t(),
          facility_type: :atct | :non_atct | :asos_awos | String.t() | nil,
          artcc_or_fss_id: String.t(),
          cpdlc: String.t(),
          tower_hrs: String.t(),
          serviced_facility: String.t(),
          serviced_fac_name: String.t(),
          serviced_site_type: :airport | :balloonport | :seaplane_base | :gliderport | :heliport | :ultralight | :awos_1 | :awos_2 | :awos_3 | :awos_a | :awos_av | :asos | String.t() | nil,
          latitude: float() | nil,
          longitude: float() | nil,
          serviced_city: String.t(),
          serviced_state: String.t(),
          serviced_country: String.t(),
          tower_or_comm_call: String.t(),
          primary_approach_radio_call: String.t(),
          frequency: float() | nil,
          sectorization: String.t(),
          freq_use: :approach | :arrival | :atis | :clearance_delivery | :ctaf | :departure | :emergency | :ground | :multicom | :tower | :unicom | :awos | :asos | String.t() | nil,
          remark: String.t()
        }

  @spec type() :: String.t()
  def type(), do: "FRQ"

  @spec new(map()) :: t()
  def new(entity) do
    %__MODULE__{
      effective_date: parse_date(Map.fetch!(entity, "EFF_DATE")),
      facility: Map.fetch!(entity, "FACILITY"),
      fac_name: Map.fetch!(entity, "FAC_NAME"),
      facility_type: parse_facility_type(Map.fetch!(entity, "FACILITY_TYPE")),
      artcc_or_fss_id: Map.fetch!(entity, "ARTCC_OR_FSS_ID"),
      cpdlc: Map.fetch!(entity, "CPDLC"),
      tower_hrs: Map.fetch!(entity, "TOWER_HRS"),
      serviced_facility: Map.fetch!(entity, "SERVICED_FACILITY"),
      serviced_fac_name: Map.fetch!(entity, "SERVICED_FAC_NAME"),
      serviced_site_type: parse_serviced_site_type(Map.fetch!(entity, "SERVICED_SITE_TYPE")),
      latitude: safe_str_to_float(Map.fetch!(entity, "LAT_DECIMAL")),
      longitude: safe_str_to_float(Map.fetch!(entity, "LONG_DECIMAL")),
      serviced_city: Map.fetch!(entity, "SERVICED_CITY"),
      serviced_state: Map.fetch!(entity, "SERVICED_STATE"),
      serviced_country: Map.fetch!(entity, "SERVICED_COUNTRY"),
      tower_or_comm_call: Map.fetch!(entity, "TOWER_OR_COMM_CALL"),
      primary_approach_radio_call: Map.fetch!(entity, "PRIMARY_APPROACH_RADIO_CALL"),
      frequency: safe_str_to_float(Map.fetch!(entity, "FREQ")),
      sectorization: Map.fetch!(entity, "SECTORIZATION"),
      freq_use: parse_freq_use(Map.fetch!(entity, "FREQ_USE")),
      remark: Map.fetch!(entity, "REMARK")
    }
  end

  defp parse_facility_type(nil), do: nil
  defp parse_facility_type(""), do: nil
  defp parse_facility_type(type) when is_binary(type) do
    case String.trim(type) do
      "ATCT" -> :atct
      "NON-ATCT" -> :non_atct
      "ASOS_AWOS" -> :asos_awos
      other -> other
    end
  end

  defp parse_serviced_site_type(nil), do: nil
  defp parse_serviced_site_type(""), do: nil
  defp parse_serviced_site_type(type) when is_binary(type) do
    case String.trim(type) do
      "AIRPORT" -> :airport
      "BALLOONPORT" -> :balloonport
      "SEAPLANE BASE" -> :seaplane_base
      "GLIDERPORT" -> :gliderport
      "HELIPORT" -> :heliport
      "ULTRALIGHT" -> :ultralight
      "AWOS-1" -> :awos_1
      "AWOS-2" -> :awos_2
      "AWOS-3" -> :awos_3
      "AWOS-A" -> :awos_a
      "AWOS-AV" -> :awos_av
      "ASOS" -> :asos
      other -> other
    end
  end

  defp parse_freq_use(nil), do: nil
  defp parse_freq_use(""), do: nil
  defp parse_freq_use(use) when is_binary(use) do
    trimmed_use = String.trim(use) |> String.upcase()
    
    case trimmed_use do
      "APPROACH" -> :approach
      "ARRIVAL" -> :arrival
      "ATIS" -> :atis
      "CLEARANCE DELIVERY" -> :clearance_delivery
      "CD" -> :clearance_delivery
      "CTAF" -> :ctaf
      "DEPARTURE" -> :departure
      "EMERGENCY" -> :emergency
      "GND" -> :ground
      "GROUND" -> :ground
      "MULTICOM" -> :multicom
      "TOWER" -> :tower
      "TWR" -> :tower
      "UNICOM" -> :unicom
      other -> 
        cond do
          String.contains?(other, "AWOS") -> :awos
          String.contains?(other, "ASOS") -> :asos
          true -> other
        end
    end
  end
end