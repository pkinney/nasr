defmodule NASR.Entities.ParachuteJumpAreaUserGroup do
  @moduledoc "Entity struct for PJA3 (USER GROUP) records"
  import NASR.Utils

  defstruct [
    :record_type_indicator,
    :pja_id,
    :user_group_text
  ]

  @type t() :: %__MODULE__{
          record_type_indicator: String.t() | nil,
          pja_id: String.t() | nil,
          user_group_text: String.t() | nil
        }

  @spec new(map()) :: t()
  def new(entry) do
    %__MODULE__{
      record_type_indicator: entry.record_type_indicator,
      pja_id: entry.pja_id,
      user_group_text: entry.pja_user_group_name
    }
  end
end
