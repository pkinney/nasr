defmodule NASR.Entities.MiscellaneousActivityAreaTimesOfUse do
  @moduledoc "Entity struct for MAA3 (TIMES OF USE) records"
  import NASR.Utils

  defstruct [
    :record_type_indicator,
    :maa_id,
    :times_of_use_text
  ]

  @type t() :: %__MODULE__{
    record_type_indicator: String.t() | nil,
    maa_id: String.t() | nil,
    times_of_use_text: String.t() | nil
  }

  @spec new(map()) :: t()
  def new(entry) do
    %__MODULE__{
      record_type_indicator: entry.record_type_indicator,
      maa_id: entry.maa_id,
      times_of_use_text: entry.times_of_use_information_text
    }
  end
end