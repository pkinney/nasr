defmodule NASR.Runway do
  @moduledoc false
  import NASR.Utils

  defstruct ~w(identifier airport_nasr_id width length surface surface_secondary condition edge_lights_intensity)a

  @type t() :: %__MODULE__{}

  @spec new(map()) :: t()
  def new(entity) do
    {surface, surface_secondary, condition} = convert_surface_type_and_condition(entity.runway_surface_type_and_condition)

    %__MODULE__{
      identifier: entity.base_end_identifier,
      airport_nasr_id: entity.landing_facility_site_number,
      length: safe_str_to_int(entity.physical_runway_length_nearest_foot),
      width: safe_str_to_int(entity.physical_runway_width_nearest_foot),
      surface: surface,
      surface_secondary: surface_secondary,
      condition: condition,
      edge_lights_intensity: convert_runway_lights_edge_intensity(entity.runway_lights_edge_intensity)
    }
  end

  defp convert_surface_type_and_condition(a) do
    a
    |> String.split(~r/[-\/]/)
    |> case do
      [s] ->
        {convert_surface_type(s), nil, :unknown}

      [s, c] when byte_size(c) == 1 ->
        {convert_surface_type(s), nil, convert_condition(c)}

      [s, c] ->
        {convert_surface_type(s), convert_surface_type(c), :unknown}

      [s, s2, c] ->
        {convert_surface_type(s), convert_surface_type(s2), convert_condition(c)}
    end
  end

  defp convert_surface_type("ALUM"), do: :aluminum
  defp convert_surface_type("ALUMINUM"), do: :aluminum
  defp convert_surface_type("ASPH"), do: :asphalt
  defp convert_surface_type("BRICK"), do: :brick
  defp convert_surface_type("CALICHE"), do: :caliche
  defp convert_surface_type("CONC"), do: :concrete
  defp convert_surface_type("CORAL"), do: :coral
  defp convert_surface_type("DECK"), do: :deck
  defp convert_surface_type("DIRT"), do: :dirt
  defp convert_surface_type("GRASS"), do: :grass
  defp convert_surface_type("GRAVEL"), do: :gravel
  defp convert_surface_type("GRE"), do: :gre
  defp convert_surface_type("GRVL"), do: :gravel
  defp convert_surface_type("MATS"), do: :mats
  defp convert_surface_type("METAL"), do: :metal
  defp convert_surface_type("NSTD"), do: :nonstandard
  defp convert_surface_type("OIL&CHIP"), do: :oil_chip
  defp convert_surface_type("PEM"), do: :pem
  defp convert_surface_type("PFC"), do: :pfc
  defp convert_surface_type("PSP"), do: :psp
  defp convert_surface_type("ROOF"), do: :roof
  defp convert_surface_type("ROOFTOP"), do: :rooftop
  defp convert_surface_type("SAND"), do: :sand
  defp convert_surface_type("SNOW"), do: :snow
  defp convert_surface_type("SOD"), do: :sod
  defp convert_surface_type("STEEL"), do: :steel
  defp convert_surface_type("T"), do: :t
  defp convert_surface_type("TOP"), do: :top
  defp convert_surface_type("TREATED"), do: :treated
  defp convert_surface_type("TRTD"), do: :treated
  defp convert_surface_type("TURF"), do: :turf
  defp convert_surface_type("WATER"), do: :water
  defp convert_surface_type("WOOD"), do: :wood
  defp convert_surface_type(_), do: :unknown

  defp convert_condition("E"), do: :fair
  defp convert_condition("G"), do: :good
  defp convert_condition("F"), do: :fair
  defp convert_condition("P"), do: :poor
  defp convert_condition("L"), do: :failed

  defp convert_runway_lights_edge_intensity("HIGH"), do: :high
  defp convert_runway_lights_edge_intensity("MED"), do: :medium
  defp convert_runway_lights_edge_intensity("LOW"), do: :low
  defp convert_runway_lights_edge_intensity("NSTD"), do: :non_standard
  defp convert_runway_lights_edge_intensity("NONE"), do: :none
  defp convert_runway_lights_edge_intensity(_), do: :unknown
end
