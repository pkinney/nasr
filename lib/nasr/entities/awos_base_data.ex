defmodule NASR.Entities.AWOSBaseData do
  @moduledoc "Entity struct for AWOS1 records"
  import NASR.Utils
  
  defstruct [
    :record_type_indicator,
    :id,
    :type,
    :raw_data
  ]
  
  @type t() :: %__MODULE__{
    record_type_indicator: String.t() | nil,
    id: String.t() | nil,
    type: atom() | nil,
    raw_data: map() | nil
  }
  
  @spec new(map()) :: t()
  def new(entry) do
    %__MODULE__{
      record_type_indicator: entry.record_type_indicator,
      id: entry.wx_sensor_ident,
      type: entry.type,
      raw_data: entry
    }
  end
end

# Sample AWOS1 entry from NASR data:
# %{
#   type: :awos1,
#   record_type_indicator: "AWOS1",
#   wx_sensor_ident: "MWA",
#   elevation: "471.7",
#   commissioning_status: "Y",
#   wx_sensor_type: "AWOS-3P",
#   station_city: "MARION",
#   information_effective_date_mm_dd_yyyy: "08/07/2025",
#   commissioning_decommissioning_date_mm_dd_yyyy: "",
#   navaid_flag___wx_sensor_associated_with_navaid: "N",
#   station_latitude: "37-45-17.9000N",
#   station_longitude: "089-00-39.9000W",
#   survey_method_code: "S",
#   station_frequency: "119.675",
#   second_station_frequency: "",
#   station_telephone_number: "618-942-8877",
#   second_station_telephone_number: "",
#   landing_facility_site_number_when_station_located: "04850.*A",
#   station_state_post_office_code_ex_il: "IL"
# }

# Original NASR AWOS1 layout specification:
#
# _date 04/05/2012
# _length 255
# 
# [AWOS1|awos1]
# *********************************************************************
# 
#             'AWOS1' RECORD TYPE - BASE DATA
# 
# *********************************************************************
# 
# 
# J  T   L    S L    E N
# U  Y   E    T O    L U
# S  P   N    A C    E M
# T  E   G    R A    M B
#        T    T T    E E
#        H      I    N R
#               O    T
#               N            FIELD DESCRIPTION
# L  AN  0005 00001  N/A     RECORD TYPE INDICATOR.
#                              AWOS1:  ASOS/AWOS FOR RESPECTIVE
#                              WX SENSOR INDENT AND WX SENSOR TYPE
# L  AN  0004 00006  N/A     WX SENSOR IDENT
# L  AN  0010 00010  N/A     WX SENSOR TYPE
#                              ASOS
#                              AWOS-1
#                              AWOS-2
#                              AWOS-3
#                              AWOS-4
#                              AWOS-A
#                              ASOS-A
#                              ASOS-B
#                              ASOS-C
#                              ASOS-D
#                              AWSS
#                              AWOS-3T
#                              AWOS-3P
#                              AWOS-3PT
#                              AWOS-AV
#                              WEF
#                              SAWS
# L  AN  0001 00020  N/A     COMMISSIONING STATUS
#                              Y - YES
#                              N - NO
# L  AN  0010 00021  N/A     COMMISSIONING/DECOMMISSIONING DATE (MM/DD/YYYY)
# L  AN  0001 00031  N/A     NAVAID FLAG - WX SENSOR ASSOCIATED WITH NAVAID
#                              Y - YES
#                              N - NO
# L  AN  0014 00032  N/A     STATION LATITUDE
#                              DD-MM-SS.SSSSH
# L  AN  0015 00046  N/A     STATION LONGITUDE
#                              DDD-MM-SS.SSSSH
# L  AN  0007 00061  N/A     ELEVATION
#                              (EX. 12345.6)
# L  AN  0001 00068  N/A     SURVEY METHOD CODE
#                              E - ESTIMATED
#                              S - SURVEYED
# L  AN  0007 00069  N/A     STATION FREQUENCY
# L  AN  0007 00076  N/A     SECOND STATION FREQUENCY
# L  AN  0014 00083  N/A     STATION TELEPHONE NUMBER
# L  AN  0014 00097  N/A     SECOND STATION TELEPHONE NUMBER
# L  AN  0011 00111  A0      LANDING FACILITY SITE NUMBER WHEN STATION LOCATED
#                              AT AIRPORT (EX. 04508.*A)
# L  AN  0040 00122  N/A     STATION CITY
# L  AN  0002 00162  N/A     STATION STATE POST OFFICE CODE (EX. IL)
# L  AN  0010 00164  N/A     INFORMATION EFFECTIVE DATE (MM/DD/YYYY)
#                              THIS DATE COINCIDES WITH THE 56-DAY CHARTING AND
#                              PUBLICATION CYCLE DATE
#        0082 00174  N/A     BLANKS: FILLER