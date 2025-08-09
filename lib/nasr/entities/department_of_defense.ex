defmodule NASR.Entities.DepartmentOfDefense do
  @moduledoc "Entity struct for DOD records"
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
      record_type_indicator: entry.identifier_group_code,
      id: entry.location_identifier,
      type: entry.type,
      raw_data: entry
    }
  end
end