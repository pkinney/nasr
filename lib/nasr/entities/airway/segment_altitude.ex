defmodule NASR.Entities.Airway.SegmentAltitude do
  @moduledoc """
  Represents Airway Segment and Altitude information from the NASR AWY_SEG_ALT data.

  Contains detailed segment-by-segment information for airways including navigation
  points, magnetic courses, distances, minimum enroute altitudes (MEA), minimum 
  obstruction clearance altitudes (MOCA), minimum crossing altitudes (MCA), 
  minimum reception altitudes (MRA), and maximum authorized altitudes (MAA).

  ## Fields

  * `:effective_date` - The 28 Day NASR Subscription Effective Date in format 'YYYY/MM/DD'
  * `:regulatory` - Identifies Airways published under 14 CFR Part-71 and Part-95 (boolean: true for Y, false for N)
  * `:airway_location` - Airway Type which identifies the General Location. Values: `:alaska`, `:hawaii`, `:contiguous_us`
  * `:airway_id` - Airway Identifier
  * `:point_sequence` - Point Sequence Number that identifies the order of Fix and NAVAIDs on the Airway
  * `:from_point` - NAVAID or FIX Identifier that establishes the Airway Segment starting point
  * `:from_point_type` - NAVAID or FIX Type of the Starting Point
  * `:nav_name` - NAVAID Name (if starting point is a NAVAID)
  * `:nav_city` - Associated City Name of the NAVAID
  * `:artcc` - Air Route Traffic Control Center ID
  * `:icao_region_code` - ICAO Region Identifier
  * `:state_code` - Associated State Post Office Code
  * `:country_code` - Country Post Office Code
  * `:to_point` - NAVAID or FIX Identifier that establishes the Airway Segment ending point
  * `:magnetic_course` - Magnetic Course from FROM_POINT to TO_POINT
  * `:opposite_magnetic_course` - Magnetic Course from TO_POINT to FROM_POINT (opposite direction)
  * `:magnetic_course_distance` - Distance (nautical miles) from FROM_POINT to TO_POINT
  * `:changeover_point` - Changeover Point Identifier
  * `:changeover_point_name` - Changeover Point Name
  * `:changeover_point_distance` - Distance (nautical miles) from FROM_POINT to the Changeover Point
  * `:airway_segment_gap_flag` - Indicates a gap in the Airway Segment (boolean: true for Y, false for N)
  * `:signal_gap_flag` - Indicates a gap in navigation signal coverage (boolean: true for Y, false for N)
  * `:dogleg` - Indicates a dogleg in the airway route (boolean: true for Y, false for N)
  * `:next_mea_point` - Next point where MEA (Minimum Enroute Altitude) changes
  * `:minimum_enroute_altitude` - Minimum Enroute Altitude (feet MSL)
  * `:minimum_enroute_altitude_direction` - Direction for which MEA applies
  * `:minimum_enroute_altitude_opposite` - MEA for opposite direction (feet MSL)
  * `:minimum_enroute_altitude_opposite_direction` - Direction for opposite MEA
  * `:gps_minimum_enroute_altitude` - GPS-specific Minimum Enroute Altitude (feet MSL)
  * `:gps_minimum_enroute_altitude_direction` - Direction for GPS MEA
  * `:gps_minimum_enroute_altitude_opposite` - GPS MEA for opposite direction (feet MSL)
  * `:gps_mea_opposite_direction` - Direction for opposite GPS MEA
  * `:dd_iru_mea` - DD/IRU (Distance/Distance Inertial Reference Unit) MEA (feet MSL)
  * `:dd_iru_mea_direction` - Direction for DD/IRU MEA
  * `:dd_i_mea_opposite` - DD/IRU MEA for opposite direction (feet MSL)
  * `:dd_i_mea_opposite_direction` - Direction for opposite DD/IRU MEA
  * `:minimum_obstruction_clearance_altitude` - Minimum Obstruction Clearance Altitude (feet MSL)
  * `:minimum_crossing_altitude` - Minimum Crossing Altitude at navigation point (feet MSL)
  * `:minimum_crossing_altitude_direction` - Direction for which MCA applies
  * `:minimum_crossing_altitude_nav_point` - Navigation point where MCA applies
  * `:minimum_crossing_altitude_opposite` - MCA for opposite direction (feet MSL)
  * `:minimum_crossing_altitude_opposite_direction` - Direction for opposite MCA
  * `:minimum_reception_altitude` - Minimum Reception Altitude (feet MSL)
  * `:maximum_authorized_altitude` - Maximum Authorized Altitude (feet MSL)
  * `:mea_gap` - Indicates gap in MEA coverage
  * `:required_navigation_performance` - Required Navigation Performance specification
  * `:remark` - Free form text that further describes a specific information item
  """
  import NASR.Utils

  defstruct ~w(
    effective_date
    regulatory
    airway_location
    airway_id
    point_sequence
    from_point
    from_point_type
    nav_name
    nav_city
    artcc
    icao_region_code
    state_code
    country_code
    to_point
    magnetic_course
    opposite_magnetic_course
    magnetic_course_distance
    changeover_point
    changeover_point_name
    changeover_point_distance
    airway_segment_gap_flag
    signal_gap_flag
    dogleg
    next_mea_point
    minimum_enroute_altitude
    minimum_enroute_altitude_direction
    minimum_enroute_altitude_opposite
    minimum_enroute_altitude_opposite_direction
    gps_minimum_enroute_altitude
    gps_minimum_enroute_altitude_direction
    gps_minimum_enroute_altitude_opposite
    gps_mea_opposite_direction
    dd_iru_mea
    dd_iru_mea_direction
    dd_i_mea_opposite
    dd_i_mea_opposite_direction
    minimum_obstruction_clearance_altitude
    minimum_crossing_altitude
    minimum_crossing_altitude_direction
    minimum_crossing_altitude_nav_point
    minimum_crossing_altitude_opposite
    minimum_crossing_altitude_opposite_direction
    minimum_reception_altitude
    maximum_authorized_altitude
    mea_gap
    required_navigation_performance
    remark
  )a

  @type t() :: %__MODULE__{
          effective_date: Date.t() | nil,
          regulatory: boolean() | nil,
          airway_location: :alaska | :hawaii | :contiguous_us | String.t() | nil,
          airway_id: String.t(),
          point_sequence: integer() | nil,
          from_point: String.t(),
          from_point_type: String.t(),
          nav_name: String.t(),
          nav_city: String.t(),
          artcc: String.t(),
          icao_region_code: String.t(),
          state_code: String.t(),
          country_code: String.t(),
          to_point: String.t(),
          magnetic_course: float() | nil,
          opposite_magnetic_course: float() | nil,
          magnetic_course_distance: float() | nil,
          changeover_point: String.t(),
          changeover_point_name: String.t(),
          changeover_point_distance: float() | nil,
          airway_segment_gap_flag: boolean() | nil,
          signal_gap_flag: boolean() | nil,
          dogleg: boolean() | nil,
          next_mea_point: String.t(),
          minimum_enroute_altitude: integer() | nil,
          minimum_enroute_altitude_direction: String.t(),
          minimum_enroute_altitude_opposite: integer() | nil,
          minimum_enroute_altitude_opposite_direction: String.t(),
          gps_minimum_enroute_altitude: integer() | nil,
          gps_minimum_enroute_altitude_direction: String.t(),
          gps_minimum_enroute_altitude_opposite: integer() | nil,
          gps_mea_opposite_direction: String.t(),
          dd_iru_mea: integer() | nil,
          dd_iru_mea_direction: String.t(),
          dd_i_mea_opposite: integer() | nil,
          dd_i_mea_opposite_direction: String.t(),
          minimum_obstruction_clearance_altitude: integer() | nil,
          minimum_crossing_altitude: integer() | nil,
          minimum_crossing_altitude_direction: String.t(),
          minimum_crossing_altitude_nav_point: String.t(),
          minimum_crossing_altitude_opposite: integer() | nil,
          minimum_crossing_altitude_opposite_direction: String.t(),
          minimum_reception_altitude: integer() | nil,
          maximum_authorized_altitude: integer() | nil,
          mea_gap: String.t(),
          required_navigation_performance: String.t(),
          remark: String.t()
        }

  @spec type() :: String.t()
  def type, do: "AWY_SEG_ALT"

  @spec new(map()) :: t()
  def new(entity) do
    %__MODULE__{
      effective_date: parse_date(Map.fetch!(entity, "EFF_DATE")),
      regulatory: convert_yn(Map.fetch!(entity, "REGULATORY")),
      airway_location: parse_airway_location(Map.fetch!(entity, "AWY_LOCATION")),
      airway_id: Map.fetch!(entity, "AWY_ID"),
      point_sequence: safe_str_to_int(Map.fetch!(entity, "POINT_SEQ")),
      from_point: Map.fetch!(entity, "FROM_POINT"),
      from_point_type: Map.fetch!(entity, "FROM_PT_TYPE"),
      nav_name: Map.fetch!(entity, "NAV_NAME"),
      nav_city: Map.fetch!(entity, "NAV_CITY"),
      artcc: Map.fetch!(entity, "ARTCC"),
      icao_region_code: Map.fetch!(entity, "ICAO_REGION_CODE"),
      state_code: Map.fetch!(entity, "STATE_CODE"),
      country_code: Map.fetch!(entity, "COUNTRY_CODE"),
      to_point: Map.fetch!(entity, "TO_POINT"),
      magnetic_course: safe_str_to_float(Map.fetch!(entity, "MAG_COURSE")),
      opposite_magnetic_course: safe_str_to_float(Map.fetch!(entity, "OPP_MAG_COURSE")),
      magnetic_course_distance: safe_str_to_float(Map.fetch!(entity, "MAG_COURSE_DIST")),
      changeover_point: Map.fetch!(entity, "CHGOVR_PT"),
      changeover_point_name: Map.fetch!(entity, "CHGOVR_PT_NAME"),
      changeover_point_distance: safe_str_to_float(Map.fetch!(entity, "CHGOVR_PT_DIST")),
      airway_segment_gap_flag: convert_yn(Map.fetch!(entity, "AWY_SEG_GAP_FLAG")),
      signal_gap_flag: convert_yn(Map.fetch!(entity, "SIGNAL_GAP_FLAG")),
      dogleg: convert_yn(Map.fetch!(entity, "DOGLEG")),
      next_mea_point: Map.fetch!(entity, "NEXT_MEA_PT"),
      minimum_enroute_altitude: safe_str_to_int(Map.fetch!(entity, "MIN_ENROUTE_ALT")),
      minimum_enroute_altitude_direction: Map.fetch!(entity, "MIN_ENROUTE_ALT_DIR"),
      minimum_enroute_altitude_opposite: safe_str_to_int(Map.fetch!(entity, "MIN_ENROUTE_ALT_OPPOSITE")),
      minimum_enroute_altitude_opposite_direction: Map.fetch!(entity, "MIN_ENROUTE_ALT_OPPOSITE_DIR"),
      gps_minimum_enroute_altitude: safe_str_to_int(Map.fetch!(entity, "GPS_MIN_ENROUTE_ALT")),
      gps_minimum_enroute_altitude_direction: Map.fetch!(entity, "GPS_MIN_ENROUTE_ALT_DIR"),
      gps_minimum_enroute_altitude_opposite: safe_str_to_int(Map.fetch!(entity, "GPS_MIN_ENROUTE_ALT_OPPOSITE")),
      gps_mea_opposite_direction: Map.fetch!(entity, "GPS_MEA_OPPOSITE_DIR"),
      dd_iru_mea: safe_str_to_int(Map.fetch!(entity, "DD_IRU_MEA")),
      dd_iru_mea_direction: Map.fetch!(entity, "DD_IRU_MEA_DIR"),
      dd_i_mea_opposite: safe_str_to_int(Map.fetch!(entity, "DD_I_MEA_OPPOSITE")),
      dd_i_mea_opposite_direction: Map.fetch!(entity, "DD_I_MEA_OPPOSITE_DIR"),
      minimum_obstruction_clearance_altitude: safe_str_to_int(Map.fetch!(entity, "MIN_OBSTN_CLNC_ALT")),
      minimum_crossing_altitude: safe_str_to_int(Map.fetch!(entity, "MIN_CROSS_ALT")),
      minimum_crossing_altitude_direction: Map.fetch!(entity, "MIN_CROSS_ALT_DIR"),
      minimum_crossing_altitude_nav_point: Map.fetch!(entity, "MIN_CROSS_ALT_NAV_PT"),
      minimum_crossing_altitude_opposite: safe_str_to_int(Map.fetch!(entity, "MIN_CROSS_ALT_OPPOSITE")),
      minimum_crossing_altitude_opposite_direction: Map.fetch!(entity, "MIN_CROSS_ALT_OPPOSITE_DIR"),
      minimum_reception_altitude: safe_str_to_int(Map.fetch!(entity, "MIN_RECEP_ALT")),
      maximum_authorized_altitude: safe_str_to_int(Map.fetch!(entity, "MAX_AUTH_ALT")),
      mea_gap: Map.fetch!(entity, "MEA_GAP"),
      required_navigation_performance: Map.fetch!(entity, "REQD_NAV_PERFORMANCE"),
      remark: Map.fetch!(entity, "REMARK")
    }
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