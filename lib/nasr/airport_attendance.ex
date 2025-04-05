defmodule NASR.AirportAttendance do
  @moduledoc false
  defstruct [
    :airport_nasr_id,
    :attendance,
    :sequence_number,
    :record_filler_blank
  ]

  @type t() :: %__MODULE__{}

  @spec new(map()) :: t()
  def new(entity) do
    %__MODULE__{
      airport_nasr_id: entity.landing_facility_site_number,
      attendance: entity.airport_attendance_schedule_when_minimum,
      sequence_number: entity.attendance_schedule_sequence_number,
      record_filler_blank: entity.attendance_schedule_record_filler_blank
    }
  end
end
