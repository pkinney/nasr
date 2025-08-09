defmodule NASR.Entities.AirRouteTrafficControlCenter do
  @moduledoc "Entity struct for ARTCC records"
  import NASR.Utils
  
  defstruct [
    :record_type_indicator,
    :id,
    :type,
    :raw_data
  ]
  
  @type t() :: %__MODULE__{
    record_type_indicator: String.t() | nil,
    id: String.t() | nil,
    type: atom() | nil,
    raw_data: map() | nil
  }
  
  @spec new(map()) :: t()
  def new(entry) do
    %__MODULE__{
      record_type_indicator: entry.record_identifier,
      id: entry.record_identifier,
      type: entry.type,
      raw_data: entry
    }
  end
end