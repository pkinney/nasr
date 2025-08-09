defmodule NASR.Entities.ParachuteJumpAreaRemarks do
  @moduledoc "Entity struct for PJA5 (REMARKS) records"
  import NASR.Utils

  defstruct [
    :record_type_indicator,
    :pja_id,
    :remarks_text
  ]

  @type t() :: %__MODULE__{
          record_type_indicator: String.t() | nil,
          pja_id: String.t() | nil,
          remarks_text: String.t() | nil
        }

  @spec new(map()) :: t()
  def new(entry) do
    %__MODULE__{
      record_type_indicator: entry.record_type_indicator,
      pja_id: entry.pja_id,
      remarks_text: entry.additional_remarks
    }
  end
end
