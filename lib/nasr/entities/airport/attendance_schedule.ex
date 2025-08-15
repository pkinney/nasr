defmodule NASR.Entities.Airport.AttendanceSchedule do
  @moduledoc """
  Represents Airport Attendance Schedule from the NASR APT_ATT data.

  This entity contains information about when airport facilities are attended
  or staffed, including months, days, and hours of operation.

  ## Fields

  * `:site_no` - Landing Facility Site Number (unique identifying number)
  * `:site_type_code` - Landing Facility Type Code
  * `:arpt_id` - Location Identifier (unique 3-4 character alphanumeric identifier)
  * `:city` - Airport Associated City Name
  * `:state_code` - Associated State Post Office Code
  * `:country_code` - Country Post Office Code
  * `:attendance_schedule_sequence_no` - Attendance Schedule Sequence Number (unique identifier for this schedule component)
  * `:months_attended` - Describes the months that the facility is attended (may contain 'UNATNDD' for unattended facilities)
  * `:days_attended` - Describes the days of the week that the facility is open
  * `:hours_attended` - Describes the hours within the day that the facility is attended
  * `:eff_date` - The 28 Day NASR Subscription Effective Date

  """
  import NASR.Utils

  defstruct ~w(
    site_no
    site_type_code
    arpt_id
    city
    state_code
    country_code
    attendance_schedule_sequence_no
    months_attended
    days_attended
    hours_attended
    eff_date
  )a

  @type t() :: %__MODULE__{
          site_no: String.t(),
          site_type_code: String.t(),
          arpt_id: String.t(),
          city: String.t(),
          state_code: String.t(),
          country_code: String.t(),
          attendance_schedule_sequence_no: integer() | nil,
          months_attended: String.t(),
          days_attended: String.t(),
          hours_attended: String.t(),
          eff_date: Date.t() | nil
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
      attendance_schedule_sequence_no: safe_str_to_int(Map.fetch!(entity, "SKED_SEQ_NO")),
      months_attended: Map.fetch!(entity, "MONTH"),
      days_attended: Map.fetch!(entity, "DAY"),
      hours_attended: Map.fetch!(entity, "HOUR"),
      eff_date: parse_date(Map.fetch!(entity, "EFF_DATE"))
    }
  end

  @spec type() :: String.t()
  def type(), do: "APT_ATT"
end