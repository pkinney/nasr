defmodule NASR.Entities.MiscellaneousActivityAreaUserGroup do
  @moduledoc "Entity struct for MAA4 (USER GROUP) records"
  import NASR.Utils

  defstruct [
    :record_type_indicator,
    :maa_id,
    :user_group_text
  ]

  @type t() :: %__MODULE__{
    record_type_indicator: String.t() | nil,
    maa_id: String.t() | nil,
    user_group_text: String.t() | nil
  }

  @spec new(map()) :: t()
  def new(entry) do
    %__MODULE__{
      record_type_indicator: entry.type_indicator,
      maa_id: entry.id,
      user_group_text: entry.user_group_name
    }
  end
end