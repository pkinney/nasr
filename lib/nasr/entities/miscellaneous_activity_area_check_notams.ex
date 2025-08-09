defmodule NASR.Entities.MiscellaneousActivityAreaCheckNotams do
  @moduledoc "Entity struct for MAA6 (CHECK FOR NOTAMS) records"
  import NASR.Utils

  defstruct [
    :record_type_indicator,
    :maa_id,
    :check_notams_text
  ]

  @type t() :: %__MODULE__{
    record_type_indicator: String.t() | nil,
    maa_id: String.t() | nil,
    check_notams_text: String.t() | nil
  }

  @spec new(map()) :: t()
  def new(entry) do
    %__MODULE__{
      record_type_indicator: entry.record_type_indicator,
      maa_id: entry.maa_id,
      check_notams_text: entry.check_for_notams_information_text
    }
  end
end