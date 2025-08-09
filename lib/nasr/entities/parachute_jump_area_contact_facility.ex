defmodule NASR.Entities.ParachuteJumpAreaContactFacility do
  @moduledoc "Entity struct for PJA4 (CONTACT FACILITY FREQUENCY DATA) records"
  import NASR.Utils

  defstruct [
    :record_type_indicator,
    :pja_id,
    :contact_facility_text
  ]

  @type t() :: %__MODULE__{
          record_type_indicator: String.t() | nil,
          pja_id: String.t() | nil,
          contact_facility_text: String.t() | nil
        }

  @spec new(map()) :: t()
  def new(entry) do
    %__MODULE__{
      record_type_indicator: entry.record_type_indicator,
      pja_id: entry.pja_id,
      contact_facility_text: entry.contact_facility_name
    }
  end
end
