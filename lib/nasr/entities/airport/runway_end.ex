defmodule NASR.Entities.Airport.RunwayEnd do
  @moduledoc """
  Represents Airport Runway End information from the NASR APT_RWY_END data.

  Contains detailed information about individual runway ends including approach
  lighting, visual aids, obstacles, displaced thresholds, and performance data.

  ## Fields

  * `:effective_date` - The 28 Day NASR Subscription Effective Date in format 'YYYY/MM/DD'
  * `:site_number` - Site Number assigned to the Landing Site Location
  * `:site_type_code` - Site Type Code identifying type of landing site. Values: `:airport`, `:balloonport`, `:seaplane_base`, `:gliderport`, `:heliport`, `:ultralight`
  * `:state_code` - Associated State Post Office Code standard two letter abbreviation for US States and Territories
  * `:airport_id` - Airport Identifier
  * `:city` - Associated City Name
  * `:country_code` - Country Post Office Code
  * `:runway_id` - Runway Identifier (e.g., "18/36", "09L/27R")
  * `:runway_end_id` - Runway End Identifier (e.g., "18", "36", "09L")
  * `:true_alignment` - True bearing of runway end (degrees)
  * `:ils_type` - Type of ILS approach available
  * `:right_hand_traffic_pattern_flag` - Indicates right-hand traffic pattern (boolean: true for Y, false for N)
  * `:runway_marking_type_code` - Type of runway markings
  * `:runway_marking_condition` - Condition of runway markings
  * `:runway_end_latitude_degrees` - Latitude degrees of runway end
  * `:runway_end_latitude_minutes` - Latitude minutes of runway end
  * `:runway_end_latitude_seconds` - Latitude seconds of runway end
  * `:runway_end_latitude_hemisphere` - Latitude hemisphere. Values: `:north`, `:south`
  * `:latitude_decimal` - Latitude in decimal degrees
  * `:runway_end_longitude_degrees` - Longitude degrees of runway end
  * `:runway_end_longitude_minutes` - Longitude minutes of runway end
  * `:runway_end_longitude_seconds` - Longitude seconds of runway end
  * `:runway_end_longitude_hemisphere` - Longitude hemisphere. Values: `:east`, `:west`
  * `:longitude_decimal` - Longitude in decimal degrees
  * `:runway_end_elevation` - Elevation of runway end (feet MSL)
  * `:threshold_crossing_height` - Height above runway threshold for normal glide path (feet)
  * `:visual_glide_path_angle` - Visual glide path angle (degrees)
  * `:displaced_threshold_latitude_degrees` - Displaced threshold latitude degrees
  * `:displaced_threshold_latitude_minutes` - Displaced threshold latitude minutes
  * `:displaced_threshold_latitude_seconds` - Displaced threshold latitude seconds
  * `:displaced_threshold_latitude_hemisphere` - Displaced threshold latitude hemisphere. Values: `:north`, `:south`
  * `:latitude_displaced_threshold_decimal` - Displaced threshold latitude in decimal degrees
  * `:displaced_threshold_longitude_degrees` - Displaced threshold longitude degrees
  * `:displaced_threshold_longitude_minutes` - Displaced threshold longitude minutes
  * `:displaced_threshold_longitude_seconds` - Displaced threshold longitude seconds
  * `:displaced_threshold_longitude_hemisphere` - Displaced threshold longitude hemisphere. Values: `:east`, `:west`
  * `:longitude_displaced_threshold_decimal` - Displaced threshold longitude in decimal degrees
  * `:displaced_threshold_elevation` - Displaced threshold elevation (feet MSL)
  * `:displaced_threshold_length` - Length of displaced threshold (feet)
  * `:touchdown_zone_elevation` - Touchdown zone elevation (feet MSL)
  * `:visual_glide_slope_indicator_code` - Type of visual glide slope indicator
  * `:runway_visual_range_equipment_code` - Runway visual range equipment type
  * `:runway_visibility_value_equipment_flag` - Runway visibility value equipment available (boolean: true for Y, false for N)
  * `:approach_lighting_system_code` - Approach lighting system type
  * `:runway_end_lights_flag` - Runway end identifier lights available (boolean: true for Y, false for N)
  * `:centerline_lights_available_flag` - Centerline lights available (boolean: true for Y, false for N)
  * `:touchdown_zone_lights_available_flag` - Touchdown zone lights available (boolean: true for Y, false for N)
  * `:obstruction_type` - Type of obstruction near runway end
  * `:obstruction_marked_code` - Obstruction marking/lighting code
  * `:far_part_77_code` - FAR Part 77 obstruction classification
  * `:obstruction_clearance_slope` - Obstruction clearance slope (ratio)
  * `:obstruction_height` - Height of obstruction above runway (feet)
  * `:distance_from_threshold` - Distance of obstruction from threshold (feet)
  * `:centerline_offset` - Offset from runway centerline (feet)
  * `:centerline_direction_code` - Direction of offset from centerline
  * `:runway_gradient` - Runway gradient (percent)
  * `:runway_gradient_direction` - Direction of runway gradient
  * `:runway_end_position_source` - Source of runway end position data
  * `:runway_end_position_date` - Date of runway end position survey
  * `:runway_end_elevation_source` - Source of runway end elevation data
  * `:runway_end_elevation_date` - Date of runway end elevation survey
  * `:displaced_threshold_position_source` - Source of displaced threshold position data
  * `:runway_end_displaced_threshold_position_date` - Date of displaced threshold position survey
  * `:displaced_threshold_elevation_source` - Source of displaced threshold elevation data
  * `:runway_end_displaced_threshold_elevation_date` - Date of displaced threshold elevation survey
  * `:touchdown_zone_elevation_source` - Source of touchdown zone elevation data
  * `:runway_end_touchdown_zone_elevation_date` - Date of touchdown zone elevation survey
  * `:takeoff_run_available` - Takeoff run available (feet)
  * `:takeoff_distance_available` - Takeoff distance available (feet)
  * `:accelerate_stop_distance_available` - Accelerate-stop distance available (feet)
  * `:landing_distance_available` - Landing distance available (feet)
  * `:lahso_available_landing_distance` - LAHSO available landing distance (feet)
  * `:runway_end_intersect_lahso` - Intersecting runway for LAHSO operations
  * `:lahso_description` - Description of LAHSO point
  * `:lahso_latitude` - LAHSO point latitude
  * `:latitude_lahso_decimal` - LAHSO point latitude in decimal degrees
  * `:lahso_longitude` - LAHSO point longitude
  * `:longitude_lahso_decimal` - LAHSO point longitude in decimal degrees
  * `:lahso_position_source` - Source of LAHSO position data
  * `:runway_end_lahso_position_date` - Date of LAHSO position survey
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
    runway_id
    runway_end_id
    true_alignment
    ils_type
    right_hand_traffic_pattern_flag
    runway_marking_type_code
    runway_marking_condition
    runway_end_latitude_degrees
    runway_end_latitude_minutes
    runway_end_latitude_seconds
    runway_end_latitude_hemisphere
    latitude_decimal
    runway_end_longitude_degrees
    runway_end_longitude_minutes
    runway_end_longitude_seconds
    runway_end_longitude_hemisphere
    longitude_decimal
    runway_end_elevation
    threshold_crossing_height
    visual_glide_path_angle
    displaced_threshold_latitude_degrees
    displaced_threshold_latitude_minutes
    displaced_threshold_latitude_seconds
    displaced_threshold_latitude_hemisphere
    latitude_displaced_threshold_decimal
    displaced_threshold_longitude_degrees
    displaced_threshold_longitude_minutes
    displaced_threshold_longitude_seconds
    displaced_threshold_longitude_hemisphere
    longitude_displaced_threshold_decimal
    displaced_threshold_elevation
    displaced_threshold_length
    touchdown_zone_elevation
    visual_glide_slope_indicator_code
    runway_visual_range_equipment_code
    runway_visibility_value_equipment_flag
    approach_lighting_system_code
    runway_end_lights_flag
    centerline_lights_available_flag
    touchdown_zone_lights_available_flag
    obstruction_type
    obstruction_marked_code
    far_part_77_code
    obstruction_clearance_slope
    obstruction_height
    distance_from_threshold
    centerline_offset
    centerline_direction_code
    runway_gradient
    runway_gradient_direction
    runway_end_position_source
    runway_end_position_date
    runway_end_elevation_source
    runway_end_elevation_date
    displaced_threshold_position_source
    runway_end_displaced_threshold_position_date
    displaced_threshold_elevation_source
    runway_end_displaced_threshold_elevation_date
    touchdown_zone_elevation_source
    runway_end_touchdown_zone_elevation_date
    takeoff_run_available
    takeoff_distance_available
    accelerate_stop_distance_available
    landing_distance_available
    lahso_available_landing_distance
    runway_end_intersect_lahso
    lahso_description
    lahso_latitude
    latitude_lahso_decimal
    lahso_longitude
    longitude_lahso_decimal
    lahso_position_source
    runway_end_lahso_position_date
  )a

  @type t() :: %__MODULE__{
          effective_date: Date.t() | nil,
          site_number: String.t(),
          site_type_code: :airport | :balloonport | :seaplane_base | :gliderport | :heliport | :ultralight | String.t() | nil,
          state_code: String.t(),
          airport_id: String.t(),
          city: String.t(),
          country_code: String.t(),
          runway_id: String.t(),
          runway_end_id: String.t(),
          true_alignment: integer() | nil,
          ils_type: String.t(),
          right_hand_traffic_pattern_flag: boolean() | nil,
          runway_marking_type_code: String.t(),
          runway_marking_condition: String.t(),
          runway_end_latitude_degrees: integer() | nil,
          runway_end_latitude_minutes: integer() | nil,
          runway_end_latitude_seconds: float() | nil,
          runway_end_latitude_hemisphere: :north | :south | String.t() | nil,
          latitude_decimal: float() | nil,
          runway_end_longitude_degrees: integer() | nil,
          runway_end_longitude_minutes: integer() | nil,
          runway_end_longitude_seconds: float() | nil,
          runway_end_longitude_hemisphere: :east | :west | String.t() | nil,
          longitude_decimal: float() | nil,
          runway_end_elevation: float() | nil,
          threshold_crossing_height: integer() | nil,
          visual_glide_path_angle: integer() | nil,
          displaced_threshold_latitude_degrees: integer() | nil,
          displaced_threshold_latitude_minutes: integer() | nil,
          displaced_threshold_latitude_seconds: float() | nil,
          displaced_threshold_latitude_hemisphere: :north | :south | String.t() | nil,
          latitude_displaced_threshold_decimal: float() | nil,
          displaced_threshold_longitude_degrees: integer() | nil,
          displaced_threshold_longitude_minutes: integer() | nil,
          displaced_threshold_longitude_seconds: float() | nil,
          displaced_threshold_longitude_hemisphere: :east | :west | String.t() | nil,
          longitude_displaced_threshold_decimal: float() | nil,
          displaced_threshold_elevation: float() | nil,
          displaced_threshold_length: integer() | nil,
          touchdown_zone_elevation: integer() | nil,
          visual_glide_slope_indicator_code: String.t(),
          runway_visual_range_equipment_code: String.t(),
          runway_visibility_value_equipment_flag: boolean() | nil,
          approach_lighting_system_code: String.t(),
          runway_end_lights_flag: boolean() | nil,
          centerline_lights_available_flag: boolean() | nil,
          touchdown_zone_lights_available_flag: boolean() | nil,
          obstruction_type: String.t(),
          obstruction_marked_code: String.t(),
          far_part_77_code: String.t(),
          obstruction_clearance_slope: integer() | nil,
          obstruction_height: integer() | nil,
          distance_from_threshold: integer() | nil,
          centerline_offset: integer() | nil,
          centerline_direction_code: String.t(),
          runway_gradient: float() | nil,
          runway_gradient_direction: String.t(),
          runway_end_position_source: String.t(),
          runway_end_position_date: Date.t() | nil,
          runway_end_elevation_source: String.t(),
          runway_end_elevation_date: Date.t() | nil,
          displaced_threshold_position_source: String.t(),
          runway_end_displaced_threshold_position_date: Date.t() | nil,
          displaced_threshold_elevation_source: String.t(),
          runway_end_displaced_threshold_elevation_date: Date.t() | nil,
          touchdown_zone_elevation_source: String.t(),
          runway_end_touchdown_zone_elevation_date: Date.t() | nil,
          takeoff_run_available: integer() | nil,
          takeoff_distance_available: integer() | nil,
          accelerate_stop_distance_available: integer() | nil,
          landing_distance_available: integer() | nil,
          lahso_available_landing_distance: integer() | nil,
          runway_end_intersect_lahso: String.t(),
          lahso_description: String.t(),
          lahso_latitude: String.t(),
          latitude_lahso_decimal: float() | nil,
          lahso_longitude: String.t(),
          longitude_lahso_decimal: float() | nil,
          lahso_position_source: String.t(),
          runway_end_lahso_position_date: Date.t() | nil
        }

  @spec type() :: String.t()
  def type, do: "APT_RWY_END"

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
      runway_id: Map.fetch!(entity, "RWY_ID"),
      runway_end_id: Map.fetch!(entity, "RWY_END_ID"),
      true_alignment: safe_str_to_int(Map.fetch!(entity, "TRUE_ALIGNMENT")),
      ils_type: Map.fetch!(entity, "ILS_TYPE"),
      right_hand_traffic_pattern_flag: convert_yn(Map.fetch!(entity, "RIGHT_HAND_TRAFFIC_PAT_FLAG")),
      runway_marking_type_code: Map.fetch!(entity, "RWY_MARKING_TYPE_CODE"),
      runway_marking_condition: Map.fetch!(entity, "RWY_MARKING_COND"),
      runway_end_latitude_degrees: safe_str_to_int(Map.fetch!(entity, "RWY_END_LAT_DEG")),
      runway_end_latitude_minutes: safe_str_to_int(Map.fetch!(entity, "RWY_END_LAT_MIN")),
      runway_end_latitude_seconds: safe_str_to_float(Map.fetch!(entity, "RWY_END_LAT_SEC")),
      runway_end_latitude_hemisphere: parse_hemisphere(Map.fetch!(entity, "RWY_END_LAT_HEMIS")),
      latitude_decimal: safe_str_to_float(Map.fetch!(entity, "LAT_DECIMAL")),
      runway_end_longitude_degrees: safe_str_to_int(Map.fetch!(entity, "RWY_END_LONG_DEG")),
      runway_end_longitude_minutes: safe_str_to_int(Map.fetch!(entity, "RWY_END_LONG_MIN")),
      runway_end_longitude_seconds: safe_str_to_float(Map.fetch!(entity, "RWY_END_LONG_SEC")),
      runway_end_longitude_hemisphere: parse_hemisphere(Map.fetch!(entity, "RWY_END_LONG_HEMIS")),
      longitude_decimal: safe_str_to_float(Map.fetch!(entity, "LONG_DECIMAL")),
      runway_end_elevation: safe_str_to_float(Map.fetch!(entity, "RWY_END_ELEV")),
      threshold_crossing_height: safe_str_to_int(Map.fetch!(entity, "THR_CROSSING_HGT")),
      visual_glide_path_angle: safe_str_to_int(Map.fetch!(entity, "VISUAL_GLIDE_PATH_ANGLE")),
      displaced_threshold_latitude_degrees: safe_str_to_int(Map.fetch!(entity, "DISPLACED_THR_LAT_DEG")),
      displaced_threshold_latitude_minutes: safe_str_to_int(Map.fetch!(entity, "DISPLACED_THR_LAT_MIN")),
      displaced_threshold_latitude_seconds: safe_str_to_float(Map.fetch!(entity, "DISPLACED_THR_LAT_SEC")),
      displaced_threshold_latitude_hemisphere: parse_hemisphere(Map.fetch!(entity, "DISPLACED_THR_LAT_HEMIS")),
      latitude_displaced_threshold_decimal: safe_str_to_float(Map.fetch!(entity, "LAT_DISPLACED_THR_DECIMAL")),
      displaced_threshold_longitude_degrees: safe_str_to_int(Map.fetch!(entity, "DISPLACED_THR_LONG_DEG")),
      displaced_threshold_longitude_minutes: safe_str_to_int(Map.fetch!(entity, "DISPLACED_THR_LONG_MIN")),
      displaced_threshold_longitude_seconds: safe_str_to_float(Map.fetch!(entity, "DISPLACED_THR_LONG_SEC")),
      displaced_threshold_longitude_hemisphere: parse_hemisphere(Map.fetch!(entity, "DISPLACED_THR_LONG_HEMIS")),
      longitude_displaced_threshold_decimal: safe_str_to_float(Map.fetch!(entity, "LONG_DISPLACED_THR_DECIMAL")),
      displaced_threshold_elevation: safe_str_to_float(Map.fetch!(entity, "DISPLACED_THR_ELEV")),
      displaced_threshold_length: safe_str_to_int(Map.fetch!(entity, "DISPLACED_THR_LEN")),
      touchdown_zone_elevation: safe_str_to_int(Map.fetch!(entity, "TDZ_ELEV")),
      visual_glide_slope_indicator_code: Map.fetch!(entity, "VGSI_CODE"),
      runway_visual_range_equipment_code: Map.fetch!(entity, "RWY_VISUAL_RANGE_EQUIP_CODE"),
      runway_visibility_value_equipment_flag: convert_yn(Map.fetch!(entity, "RWY_VSBY_VALUE_EQUIP_FLAG")),
      approach_lighting_system_code: Map.fetch!(entity, "APCH_LGT_SYSTEM_CODE"),
      runway_end_lights_flag: convert_yn(Map.fetch!(entity, "RWY_END_LGTS_FLAG")),
      centerline_lights_available_flag: convert_yn(Map.fetch!(entity, "CNTRLN_LGTS_AVBL_FLAG")),
      touchdown_zone_lights_available_flag: convert_yn(Map.fetch!(entity, "TDZ_LGT_AVBL_FLAG")),
      obstruction_type: Map.fetch!(entity, "OBSTN_TYPE"),
      obstruction_marked_code: Map.fetch!(entity, "OBSTN_MRKD_CODE"),
      far_part_77_code: Map.fetch!(entity, "FAR_PART_77_CODE"),
      obstruction_clearance_slope: safe_str_to_int(Map.fetch!(entity, "OBSTN_CLNC_SLOPE")),
      obstruction_height: safe_str_to_int(Map.fetch!(entity, "OBSTN_HGT")),
      distance_from_threshold: safe_str_to_int(Map.fetch!(entity, "DIST_FROM_THR")),
      centerline_offset: safe_str_to_int(Map.fetch!(entity, "CNTRLN_OFFSET")),
      centerline_direction_code: Map.fetch!(entity, "CNTRLN_DIR_CODE"),
      runway_gradient: safe_str_to_float(Map.fetch!(entity, "RWY_GRAD")),
      runway_gradient_direction: Map.fetch!(entity, "RWY_GRAD_DIRECTION"),
      runway_end_position_source: Map.fetch!(entity, "RWY_END_PSN_SOURCE"),
      runway_end_position_date: parse_date(Map.fetch!(entity, "RWY_END_PSN_DATE")),
      runway_end_elevation_source: Map.fetch!(entity, "RWY_END_ELEV_SOURCE"),
      runway_end_elevation_date: parse_date(Map.fetch!(entity, "RWY_END_ELEV_DATE")),
      displaced_threshold_position_source: Map.fetch!(entity, "DSPL_THR_PSN_SOURCE"),
      runway_end_displaced_threshold_position_date: parse_date(Map.fetch!(entity, "RWY_END_DSPL_THR_PSN_DATE")),
      displaced_threshold_elevation_source: Map.fetch!(entity, "DSPL_THR_ELEV_SOURCE"),
      runway_end_displaced_threshold_elevation_date: parse_date(Map.fetch!(entity, "RWY_END_DSPL_THR_ELEV_DATE")),
      touchdown_zone_elevation_source: Map.fetch!(entity, "TDZ_ELEV_SOURCE"),
      runway_end_touchdown_zone_elevation_date: parse_date(Map.fetch!(entity, "RWY_END_TDZ_ELEV_DATE")),
      takeoff_run_available: safe_str_to_int(Map.fetch!(entity, "TKOF_RUN_AVBL")),
      takeoff_distance_available: safe_str_to_int(Map.fetch!(entity, "TKOF_DIST_AVBL")),
      accelerate_stop_distance_available: safe_str_to_int(Map.fetch!(entity, "ACLT_STOP_DIST_AVBL")),
      landing_distance_available: safe_str_to_int(Map.fetch!(entity, "LNDG_DIST_AVBL")),
      lahso_available_landing_distance: safe_str_to_int(Map.fetch!(entity, "LAHSO_ALD")),
      runway_end_intersect_lahso: Map.fetch!(entity, "RWY_END_INTERSECT_LAHSO"),
      lahso_description: Map.fetch!(entity, "LAHSO_DESC"),
      lahso_latitude: Map.fetch!(entity, "LAHSO_LAT"),
      latitude_lahso_decimal: safe_str_to_float(Map.fetch!(entity, "LAT_LAHSO_DECIMAL")),
      lahso_longitude: Map.fetch!(entity, "LAHSO_LONG"),
      longitude_lahso_decimal: safe_str_to_float(Map.fetch!(entity, "LONG_LAHSO_DECIMAL")),
      lahso_position_source: Map.fetch!(entity, "LAHSO_PSN_SOURCE"),
      runway_end_lahso_position_date: parse_date(Map.fetch!(entity, "RWY_END_LAHSO_PSN_DATE"))
    }
  end

  defp parse_site_type_code(nil), do: nil
  defp parse_site_type_code(""), do: nil
  defp parse_site_type_code(code) when is_binary(code) do
    case String.trim(code) do
      "A" -> :airport
      "B" -> :balloonport
      "S" -> :seaplane_base
      "G" -> :gliderport
      "H" -> :heliport
      "U" -> :ultralight
      other -> other
    end
  end

  defp parse_hemisphere(nil), do: nil
  defp parse_hemisphere(""), do: nil
  defp parse_hemisphere(hemisphere) when is_binary(hemisphere) do
    case String.trim(hemisphere) do
      "N" -> :north
      "S" -> :south
      "E" -> :east
      "W" -> :west
      other -> other
    end
  end
end