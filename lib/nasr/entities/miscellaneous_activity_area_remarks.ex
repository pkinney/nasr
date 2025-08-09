defmodule NASR.Entities.MiscellaneousActivityAreaRemarks do
  @moduledoc "Entity struct for MAA7 (BASE REMARKS TEXT) records"
  import NASR.Utils

  defstruct [
    :record_type_indicator,
    :maa_id,
    :remarks_text
  ]

  @type t() :: %__MODULE__{
    record_type_indicator: String.t() | nil,
    maa_id: String.t() | nil,
    remarks_text: String.t() | nil
  }

  @spec new(map()) :: t()
  def new(entry) do
    %__MODULE__{
      record_type_indicator: entry.record_type_indicator,
      maa_id: entry.maa_id,
      remarks_text: entry.base_remarks_text
    }
  end
end