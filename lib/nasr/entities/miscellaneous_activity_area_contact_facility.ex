defmodule NASR.Entities.MiscellaneousActivityAreaContactFacility do
  @moduledoc "Entity struct for MAA5 (CONTACT FACILITY DATA) records"
  import NASR.Utils

  defstruct [
    :record_type_indicator,
    :maa_id,
    :contact_facility_text
  ]

  @type t() :: %__MODULE__{
    record_type_indicator: String.t() | nil,
    maa_id: String.t() | nil,
    contact_facility_text: String.t() | nil
  }

  @spec new(map()) :: t()
  def new(entry) do
    %__MODULE__{
      record_type_indicator: entry.record_type_indicator,
      maa_id: entry.maa_id,
      contact_facility_text: entry.contact_facility_frequency_information_text
    }
  end
end