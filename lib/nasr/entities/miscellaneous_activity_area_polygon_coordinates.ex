defmodule NASR.Entities.MiscellaneousActivityAreaPolygonCoordinates do
  @moduledoc "Entity struct for MAA2 (POLYGON COORDINATES) records"
  import NASR.Utils

  defstruct [
    :record_type_indicator,
    :maa_id,
    :polygon_coordinates_text
  ]

  @type t() :: %__MODULE__{
    record_type_indicator: String.t() | nil,
    maa_id: String.t() | nil,
    polygon_coordinates_text: String.t() | nil
  }

  @spec new(map()) :: t()
  def new(entry) do
    %__MODULE__{
      record_type_indicator: entry.type_indicator,
      maa_id: entry.id,
      polygon_coordinates_text: nil
    }
  end
end