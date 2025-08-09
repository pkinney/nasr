defmodule NASR.Entities.AirRouteTrafficControlCenterFrequencyRemarksData do
  @moduledoc "Entity struct for AFF4 records"
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
      record_type_indicator: entry.record_type_indicator,
      id: entry.air_route_traffic_control_center_identifier,
      type: entry.type,
      raw_data: entry
    }
  end
end