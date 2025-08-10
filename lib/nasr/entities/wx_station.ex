defmodule NASR.Entities.WxStation do
  @moduledoc false

  # Sample WXL entry from NASR data:
  # %{
  #   type: :wxl,
  #   weather_reporting_location_identifier: "ILX",
  #   collective_weather_service_type: "LX  4",
  #   weather_services_available_at_location_up_to: "",
  #   affected_areas___states_areas: "009020N08920180WLOGAN COUNTY                            IL     581E",
  #   associated_country_numeric_code_non_us_only: "",
  #   associated_city: "LOGAN COUNTY",
  #   associated_state_post_office_code: "IL",
  #   weather_reporting_location_elevation___value: "581",
  #   continuation_record_indicator: "I",
  #   longitude_of_the_weather_reporting_location: "08920180W",
  #   latitude_of_the_weather_reporting_location: "4009020N",
  #   blank: "",
  #   weather_reporting_location_elevation___accuracy: "E",
  #   collective_number: "0",
  #   affected_area_weather_service_type: "LX  4"
  # }

  import NASR.Utils

  defstruct [
    :identifier,
    :sensor_type,
    :frequency,
    :second_frequency,
    :telephone_number,
    :city,
    :state,
    :elevation,
    :commissioning_status,
    :navaid,
    :longitude,
    :latitude,
    remarks: []
  ]

  @type t() :: %__MODULE__{}

  @spec new(map()) :: t()
  def new(entity) do
    %__MODULE__{
      identifier: entity.weather_reporting_location_identifier,
      sensor_type: entity.collective_weather_service_type,
      frequency: entity.weather_services_available_at_location_up_to,
      second_frequency: entity.affected_areas___states_areas,
      telephone_number: entity.associated_country_numeric_code_non_us_only,
      city: entity.associated_city,
      state: entity.associated_state_post_office_code,
      elevation: safe_str_to_int(entity.weather_reporting_location_elevation___value),
      commissioning_status: entity.continuation_record_indicator,
      navaid: entity.weather_services_available_at_location_up_to,
      longitude: convert_dms_to_decimal(entity.longitude_of_the_weather_reporting_location),
      latitude: convert_dms_to_decimal(entity.latitude_of_the_weather_reporting_location)
    }
  end
end

# Original NASR WXL layout specification:
#
# _date 6/17/2021
# _length 135
#                       WEATHER REPORTING LOCATIONS
#                         DATA BASE RECORD LAYOUT
#                               (WXL-FILE)
#
# INFORMATION EFFECTIVE DATE: 6/17/2021 CHARTING CYCLE
#
#     RECORD FORMAT: FIXED
#     LOGICAL RECORD LENGTH: 135
#
#
# FILE STRUCTURE DESCRIPTION:
# ---------------------------
#
#     THERE ARE A VARIABLE NUMBER OF FIXED-LENGTH RECORDS FOR EACH
#     WEATHER REPORTING LOCATION. EACH LOCATION WILL HAVE AT LEAST ONE
#     RECORD DESCRIBING LOCATION INFORMATION AND AVAILABLE WEATHER
#     SERVICES. FOR THOSE WEATHER REPORTING LOCATIONS THAT ARE
#     WEATHER COLLECTIVES OR HAVE SPECIFIC AFFECTED AREAS, THERE WILL BE
#     CONTINUATION RECORDS - ONE FOR EACH COLLECTIVE OR AFFECTED AREA
#     WEATHER SERVICE.
#
#     THIS FILE FORMAT WAS ORIGINALLY BUILT TO SUPPORT THE FAA'S
#     FLIGHT SERVICE AUTOMATION SYSTEM (FSAS). OTHER USERS OF
#     WEATHER REPORTING LOCATION INFORMATION WILL USE
#     THIS FSAS-SPECIFIED FILE FORMAT.
#
#     THE FILE IS SORTED BY WEATHER REPORTING LOCATION IDENTIFIER
#     WITH CONTINUATION RECORDS FOR A LOCATION IMMEDIATELY FOLLOWING.
#     THE CONTINUATION RECORDS ARE IN RANDOM ORDER.
#
#     EACH RECORD ENDS WITH A CARRIAGE RETURN CHARACTER AND LINE FEED
#     CHARACTER (CR/LF). THIS LINE TERMINATOR IS NOT INCLUDED IN THE
#     LOGICAL RECORD LENGTH.
#
#
# GENERAL INFORMATION:
# --------------------
#      1.  LEFT JUSTIFIED FIELDS HAVE TRAILING BLANKS
#      2.  RIGHT JUSTIFIED FIELDS HAVE LEADING BLANKS
#      3.  ELEMENT NUMBER IS FOR INTERNAL REFERENCE ONLY
#          AND NOT IN THE RECORD.
#      4.  THE UNIQUE, BASIC RECORD IDENTIFIER IS MADE UP OF THE
#          WEATHER REPORTING LOCATION IDENTIFIER, ASSOCIATED CITY, AND
#          ASSOCIATED COUNTRY CODE.
#
# [wxl]
# *********************************************************************
#
#             BASIC WEATHER REPORTING LOCATION DATA
#
# ********************************************************************
#
#
#
#
# J  T   L   S L   E N
# U  Y   E   T O   L U
# S  P   N   A C   E M
# T  E   G   R A   M B
#        T   T T   E E
#        H     I   N R
#              O   T
#              N           FIELD DESCRIPTION
#
#
# L AN 0005 00001  DLID    WEATHER REPORTING LOCATION IDENTIFIER
#                            EX. AGS, AK21
#
# L AN 0008 00006  WX4     LATITUDE OF THE WEATHER REPORTING LOCATION
#                            FORMAT: DDMMSSTC
#                                DD  DEGREES
#                                MM  MINUTES
#                                SS  SECONDS
#                                T   TENTHS OF SECONDS (DECIMAL POINT
#                                      IS IMPLIED)
#                                C   DECLINATION (N-NORTH; S-SOUTH)
#                            EX. 3139438N - ALL 8 CHARACTERS WILL
#                                           ALWAYS BE PRESENT.
#
# L AN 0009 00014  WX5     LONGITUDE OF THE WEATHER REPORTING LOCATION
#                            FORMAT: DDDMMSSTC
#                               DDD  DEGREES
#                                MM  MINUTES
#                                SS  SECONDS
#                                T   TENTHS OF SECONDS (DECIMAL POINT
#                                     IS IMPLIED)
#                                C   DECLINATION (E-EAST; W-WEST)
#                            EX. 09716075W - ALL 9 CHARACTERS WILL
#                                            ALWAYS BE PRESENT.
#
# L AN 0040 00023  WX1     ASSOCIATED CITY
#                          (EX: ALBANY)
#
# L AN 0002 00063  WX2     ASSOCIATED STATE (POST OFFICE CODE)
#                          VALUE MAY ALSO BE MX (MEXICO), CA (CANADA),
#                            OR OTHER INTERNATIONAL LOCATIONS
#                          EX. AL,MD,MX
#
# L AN 0003 00065  WX3     ASSOCIATED COUNTRY NUMERIC CODE (NON-US ONLY)
#                            STANDARD FIPS ASSIGNMENT OF 2 OR 3 NUMERIC
#                            DIGITS FOR FOREIGN COUNTRIES.
#                          EX. 484
#
# R  N 0005 00068  WX6     WEATHER REPORTING LOCATION ELEVATION - VALUE
#                            (WHOLE FEET MSL) EX. 73, 0, 3929
#
# L AN 0001 00073  WX6     WEATHER REPORTING LOCATION ELEVATION - ACCURACY
#                            S - VALUE WAS SURVEYED
#                            E - VALUE WAS ESTIMATED
#
#
#
#
# L AN 0060 00074  WX7     WEATHER SERVICES AVAILABLE AT LOCATION, UP TO
#                          5 CHARACTERS FOR EACH.
#                          (WX TYPES ARE IN RANDOM ORDER)
#
#                        WX TYPE    DESCRIPTION
#                        -------    -----------
#
#                          AC       SEVERE WEATHER OUTLOOK NARRATIVE
#                          AWW      SEVERE WEATHER FORECAST ALERT
#                          CWA      CENTRAL WEATHER ADVISORY
#                          FA       AREA FORECAST
#                          FD       WINDS & TEMPERATURE ALOFT FORECAST
#                          FT       AVIATION TERMINAL FORECAST
#                          FX       MISCELLANEOUS FORECASTS
#                          METAR    AVIATION ROUTINE WEATHER REPORT (ICAO)
#                          MIS      METEOROLOGICAL IMPACT SUMMARY
#                          NOTAM    NOTICE TO AIRMEN
#                          SA       SURFACE OBSERVATION REPORT
#                          SD       RADAR WEATHER REPORT
#                          SPECI    AVIATION SPECIAL WEATHER REPORT (ICAO)
#                          SYNS     TRANSCRIBED WEATHER BROADCAST SYNOPSES
#                          TAF      AVIATION TERMINAL FORECAST (ICAO)
#                          TWEB     TRANSCRIBED WEATHER BROADCAST
#                          UA       AIRCRAFT REPORT (PIREP)
#                          WA       WEATHER ADVISORY
#                          WH       ABBREVIATED HURRICANE ADVISORY
#                          WO       TROPICAL DEPRESSIONS
#                          WS       FLIGHT ADVISORY - SIGMET
#                          WST      CONVECTIVE SIGMET
#                          WW       SEVERE WEATHER BROADCASTS OR BULLETINS
#
#                          EX.: SA   UA NOTAMTWEB
#                               WST  SYNS FA
#
# L AN 0002 00134  NA      BLANK
#
#
# *********************************************************************
#
#          WEATHER REPORTING LOCATION - COLLECTIVES RECORD TYPE
#
# *********************************************************************
#
# J  T   L   S L   E N
# U  Y   E   T O   L U
# S  P   N   A C   E M
# T  E   G   R A   M B
#        T   T T   E E
#        H     I   N R
#              O   T
#              N           FIELD DESCRIPTION
#
#
# L AN 0001 00001  NONE    CONTINUATION RECORD INDICATOR
#                            AN '*' FOUND IN POSITION 1 INDICATES
#                            THAT THIS RECORD IS A CONTINUATION OF
#                            THE PREVIOUS WEATHER LOCATION. THE
#                            CONTINUATION RECORDS ARE USED TO
#                            DESCRIBE COLLECTIVE NUMBERS AND AFFECTED
#                            AREAS FOR CERTAIN WEATHER SERVICE TYPES.
#
# L AN 0005 00002  WX8     COLLECTIVE WEATHER SERVICE TYPE
#                            FT - AVIATION TERMINAL FORECAST
#                            SD - RADAR WEATHER REPORT
#
# L AN 0001 00007  WX8     COLLECTIVE NUMBER
#                            SINGLE DIGIT 0 THRU 9.
#
# L AN 0128 00008  NONE    BLANK.
#
# *********************************************************************
#
#          WEATHER REPORTING LOCATION - AFFECTED AREAS RECORD TYPE
#
# *********************************************************************
#
# J  T   L   S L   E N
# U  Y   E   T O   L U
# S  P   N   A C   E M
# T  E   G   R A   M B
#        T   T T   E E
#        H     I   N R
#              O   T
#              N           FIELD DESCRIPTION
#
#
# L AN 0001 00001  NONE    CONTINUATION RECORD INDICATOR
#                            AN '*' FOUND IN POSITION 1 INDICATES
#                            THAT THIS RECORD IS A CONTINUATION OF
#                            THE PREVIOUS WEATHER LOCATION. THE
#                            CONTINUATION RECORDS ARE USED TO
#                            DESCRIBE COLLECTIVE NUMBERS AND AFFECTED
#                            AREAS FOR CERTAIN WEATHER SERVICE TYPES.
#
# L AN 0005 00002  WX8     AFFECTED AREA WEATHER SERVICE TYPE
#                            CWA      CENTRAL WEATHER ADVISORY
#                            FA       AREA FORECAST
#                            MIS      METEOROLOGICAL IMPACT SUMMARY
#                            WH       ABBREVIATED HURRICANE ADVISORY
#                            WO       TROPICAL DEPRESSIONS
#                            WST      CONVECTIVE SIGMET
#
# L AN 0114 00007  WX8     AFFECTED AREAS - STATES/AREAS
#                            A SERIES OF TWO CHARACTER U.S. STATE POST
#                            OFFICE ABBREVIATIONS SEPARATED BY ONE
#                            SPACE. VALUES MAY ALSO INCLUDE LE,
#                            LH,LM,LO,LS FOR THE GREAT LAKES (ERIE,
#                            HURON, MICHIGAN, ONTARIO, SUPERIOR)
#                            EX. AR MO LA TX AZ NM UT MS AL GA KY
#                                DC MD VA
#                            (NOTE: THE STATES/LAKES ARE NOT IN
#                                  ANY SORTED ORDER)
#
# L AN 0015 00121  NA      BLANK
