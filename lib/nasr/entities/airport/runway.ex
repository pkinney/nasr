defmodule NASR.Entities.Airport.Runway do
  @moduledoc """
  Represents Airport Runway information from the NASR APT_RWY data.

  This entity contains detailed information about airport runways including
  physical characteristics, surface conditions, lighting, and weight-bearing capacity.

  ## Fields

  * `:site_no` - Landing Facility Site Number (unique identifying number)
  * `:site_type_code` - Landing Facility Type Code
  * `:arpt_id` - Location Identifier (unique 3-4 character alphanumeric identifier)
  * `:city` - Airport Associated City Name
  * `:state_code` - Associated State Post Office Code
  * `:country_code` - Country Post Office Code
  * `:runway_id` - Runway Identification
  * `:runway_length` - Physical Runway Length (Nearest Foot)
  * `:runway_width` - Physical Runway Width (Nearest Foot)
  * `:surface_type_code` - Runway Surface Type. Values: `:concrete`, `:asphalt`, `:snow`, `:ice`, `:mats`, `:treated`, `:gravel`, `:turf`, `:dirt`, `:pem`, `:roof_top`, `:water`
  * `:surface_condition` - Runway Surface Condition. Values: `:excellent`, `:good`, `:fair`, `:poor`, `:failed`
  * `:surface_treatment` - Runway Surface Treatment. Values: `:grooved`, `:porous_friction_course`, `:aggregate_friction_seal_coat`, `:rubberized_friction_seal_coat`, `:wire_comb`, `:none`
  * `:pavement_classification_number` - Pavement Classification Number (PCN) - See FAA Advisory Circular 150/5335-5 for Code Definitions and PCN Determination Formula
  * `:pavement_type` - Pavement Type. Values: `:rigid`, `:flexible`
  * `:subgrade_strength` - Subgrade Strength (Letters A-F)
  * `:tire_pressure_code` - Tire Pressure Code (Letters W-Z)
  * `:determination_method` - Determination Method. Values: `:technical`, `:using_aircraft`
  * `:runway_lights_edge_intensity` - Runway Lights Edge Intensity. Values: `:high`, `:medium`, `:low`, `:flood`, `:non_standard`, `:perimeter`, `:strobe`, `:none`
  * `:runway_length_source` - Runway Length Source
  * `:runway_length_source_date` - Runway Length Source Date (YYYY/MM/DD)
  * `:single_wheel_weight` - Runway Weight-Bearing Capacity for Single Wheel type Landing Gear
  * `:dual_wheel_weight` - Runway Weight-Bearing Capacity for Dual Wheel type Landing Gear
  * `:dual_tandem_weight` - Runway Weight-Bearing Capacity for Two Dual Wheels in tandem type Landing Gear
  * `:double_dual_tandem_weight` - Runway Weight-Bearing Capacity for Two Dual Wheels in tandem/two dual wheels in double tandem body gear type Landing Gear
  * `:effective_date` - The 28 Day NASR Subscription Effective Date in format 'YYYY/MM/DD'
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
    runway_length
    runway_width
    surface_type_code
    surface_condition
    surface_treatment
    pavement_classification_number
    pavement_type
    subgrade_strength
    tire_pressure_code
    determination_method
    runway_lights_edge_intensity
    runway_length_source
    runway_length_source_date
    single_wheel_weight
    dual_wheel_weight
    dual_tandem_weight
    double_dual_tandem_weight
    effective_date
  )a

  @type t() :: %__MODULE__{
          site_no: String.t(),
          site_type_code: String.t(),
          arpt_id: String.t(),
          city: String.t(),
          state_code: String.t(),
          country_code: String.t(),
          runway_id: String.t(),
          runway_length: integer() | nil,
          runway_width: integer() | nil,
          surface_type_code: :concrete | :asphalt | :snow | :ice | :mats | :treated | :gravel | :turf | :dirt | :pem | :roof_top | :water | String.t() | nil,
          surface_condition: :excellent | :good | :fair | :poor | :failed | String.t() | nil,
          surface_treatment: :grooved | :porous_friction_course | :aggregate_friction_seal_coat | :rubberized_friction_seal_coat | :wire_comb | :none | String.t() | nil,
          pavement_classification_number: String.t(),
          pavement_type: :rigid | :flexible | String.t() | nil,
          subgrade_strength: String.t(),
          tire_pressure_code: String.t(),
          determination_method: :technical | :using_aircraft | String.t() | nil,
          runway_lights_edge_intensity: :high | :medium | :low | :flood | :non_standard | :perimeter | :strobe | :none | String.t() | nil,
          runway_length_source: String.t(),
          runway_length_source_date: Date.t() | nil,
          single_wheel_weight: integer() | nil,
          dual_wheel_weight: integer() | nil,
          dual_tandem_weight: integer() | nil,
          double_dual_tandem_weight: integer() | nil,
          effective_date: Date.t() | nil
        }

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
      runway_length: safe_str_to_int(Map.fetch!(entity, "RWY_LEN")),
      runway_width: safe_str_to_int(Map.fetch!(entity, "RWY_WIDTH")),
      surface_type_code: parse_surface_type_code(Map.fetch!(entity, "SURFACE_TYPE_CODE")),
      surface_condition: parse_surface_condition(Map.fetch!(entity, "COND")),
      surface_treatment: parse_surface_treatment(Map.fetch!(entity, "TREATMENT_CODE")),
      pavement_classification_number: Map.fetch!(entity, "PCN"),
      pavement_type: parse_pavement_type(Map.fetch!(entity, "PAVEMENT_TYPE_CODE")),
      subgrade_strength: Map.fetch!(entity, "SUBGRADE_STRENGTH_CODE"),
      tire_pressure_code: Map.fetch!(entity, "TIRE_PRES_CODE"),
      determination_method: parse_determination_method(Map.fetch!(entity, "DTRM_METHOD_CODE")),
      runway_lights_edge_intensity: parse_runway_lights_intensity(Map.fetch!(entity, "RWY_LGT_CODE")),
      runway_length_source: Map.fetch!(entity, "RWY_LEN_SOURCE"),
      runway_length_source_date: parse_date(Map.fetch!(entity, "LENGTH_SOURCE_DATE")),
      single_wheel_weight: safe_str_to_int(Map.fetch!(entity, "GROSS_WT_SW")),
      dual_wheel_weight: safe_str_to_int(Map.fetch!(entity, "GROSS_WT_DW")),
      dual_tandem_weight: safe_str_to_int(Map.fetch!(entity, "GROSS_WT_DTW")),
      double_dual_tandem_weight: safe_str_to_int(Map.fetch!(entity, "GROSS_WT_DDTW")),
      effective_date: parse_date(Map.fetch!(entity, "EFF_DATE"))
    }
  end

  @spec type() :: String.t()
  def type(), do: "APT_RWY"

  defp parse_surface_type_code(nil), do: nil
  defp parse_surface_type_code(""), do: nil
  defp parse_surface_type_code(surface) when is_binary(surface) do
    surface
    |> String.trim()
    |> case do
      "CONC" -> :concrete
      "ASPH" -> :asphalt
      "SNOW" -> :snow
      "ICE" -> :ice
      "MATS" -> :mats
      "TREATED" -> :treated
      "GRAVEL" -> :gravel
      "TURF" -> :turf
      "DIRT" -> :dirt
      "PEM" -> :pem
      "ROOF-TOP" -> :roof_top
      "WATER" -> :water
      other -> other
    end
  end

  defp parse_surface_condition(nil), do: nil
  defp parse_surface_condition(""), do: nil
  defp parse_surface_condition(condition) when is_binary(condition) do
    condition
    |> String.trim()
    |> case do
      "EXCELLENT" -> :excellent
      "GOOD" -> :good
      "FAIR" -> :fair
      "POOR" -> :poor
      "FAILED" -> :failed
      other -> other
    end
  end

  defp parse_surface_treatment(nil), do: nil
  defp parse_surface_treatment(""), do: nil
  defp parse_surface_treatment(treatment) when is_binary(treatment) do
    treatment
    |> String.trim()
    |> case do
      "GRVD" -> :grooved
      "PFC" -> :porous_friction_course
      "AFSC" -> :aggregate_friction_seal_coat
      "RFSC" -> :rubberized_friction_seal_coat
      "WC" -> :wire_comb
      "NONE" -> :none
      other -> other
    end
  end

  defp parse_pavement_type(nil), do: nil
  defp parse_pavement_type(""), do: nil
  defp parse_pavement_type(type) when is_binary(type) do
    case String.trim(type) do
      "R" -> :rigid
      "F" -> :flexible
      other -> other
    end
  end

  defp parse_determination_method(nil), do: nil
  defp parse_determination_method(""), do: nil
  defp parse_determination_method(method) when is_binary(method) do
    case String.trim(method) do
      "T" -> :technical
      "U" -> :using_aircraft
      other -> other
    end
  end

  defp parse_runway_lights_intensity(nil), do: nil
  defp parse_runway_lights_intensity(""), do: nil
  defp parse_runway_lights_intensity(intensity) when is_binary(intensity) do
    intensity
    |> String.trim()
    |> case do
      "HIGH" -> :high
      "MED" -> :medium
      "LOW" -> :low
      "FLD" -> :flood
      "NSTD" -> :non_standard
      "PERI" -> :perimeter
      "STRB" -> :strobe
      "NONE" -> :none
      other -> other
    end
  end
end