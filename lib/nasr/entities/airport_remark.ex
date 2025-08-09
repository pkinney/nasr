defmodule NASR.Entities.AirportRemark do
  @moduledoc false

  defstruct [
    :airport_nasr_id,
    :text,
    :element
  ]

  @type t() :: %__MODULE__{}

  @spec new(map()) :: t()
  def new(entity) do
    %__MODULE__{
      airport_nasr_id: entity.landing_facility_site_number,
      text: entity.remark_text,
      element: entity.remark_element_name
    }
  end
end
