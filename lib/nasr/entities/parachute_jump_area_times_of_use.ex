defmodule NASR.Entities.ParachuteJumpAreaTimesOfUse do
  @moduledoc "Entity struct for PJA2 (TIMES OF USE) records"
  import NASR.Utils

  defstruct [
    :record_type_indicator,
    :pja_id,
    :times_of_use_text
  ]

  @type t() :: %__MODULE__{
          record_type_indicator: String.t() | nil,
          pja_id: String.t() | nil,
          times_of_use_text: String.t() | nil
        }

  @spec new(map()) :: t()
  def new(entry) do
    %__MODULE__{
      record_type_indicator: entry.record_type_indicator,
      pja_id: entry.pja_id,
      times_of_use_text: entry.times_of_use_description
    }
  end
end
