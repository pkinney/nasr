defmodule NASR.Runway do
  @moduledoc false
  import NASR.Utils

  defstruct ~w(identifier airport width length surface_type condition)a

  @type t() :: %__MODULE__{}

  @spec new(map()) :: t()
  def new(entity) do
    %__MODULE__{
      identifier: entity.base_end_identifier,
      airport: entity.landing_facility_site_number,
      length: safe_str_to_int(entity.physical_runway_length_nearest_foot),
      width: safe_str_to_int(entity.physical_runway_width_nearest_foot)
    }
  end
end
