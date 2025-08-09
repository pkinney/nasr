defmodule NASR.Entities.ILSRemarks do
  @moduledoc "Entity struct for ILS6 (INSTRUMENT LANDING SYSTEM REMARKS) records"
  import NASR.Utils
  
  defstruct [
    :record_type_indicator,
    :airport_site_number,
    :ils_runway_end_identifier,
    :ils_system_type,
    :remarks_text
  ]
  
  @type t() :: %__MODULE__{
    record_type_indicator: String.t() | nil,
    airport_site_number: String.t() | nil,
    ils_runway_end_identifier: String.t() | nil,
    ils_system_type: :ils | :sdf | :localizer | :lda | :ils_dme | :sdf_dme | :loc_dme | :loc_gs | :lda_dme | nil,
    remarks_text: String.t() | nil
  }
  
  @spec new(map()) :: t()
  def new(entry) do
    %__MODULE__{
      record_type_indicator: entry.record_type_indicator,
      airport_site_number: entry.airport_site_number_identifier,
      ils_runway_end_identifier: entry.ils_runway_end_identifier,
      ils_system_type: convert_ils_system_type(entry.ils_system_type_see_ils1_record_for_description),
      remarks_text: entry.ils_remarks_free_form_text
    }
  end
  
  defp convert_ils_system_type("ILS"), do: :ils
  defp convert_ils_system_type("SDF"), do: :sdf
  defp convert_ils_system_type("LOCALIZER"), do: :localizer
  defp convert_ils_system_type("LDA"), do: :lda
  defp convert_ils_system_type("ILS/DME"), do: :ils_dme
  defp convert_ils_system_type("SDF/DME"), do: :sdf_dme
  defp convert_ils_system_type("LOC/DME"), do: :loc_dme
  defp convert_ils_system_type("LOC/GS"), do: :loc_gs
  defp convert_ils_system_type("LDA/DME"), do: :lda_dme
  defp convert_ils_system_type(_), do: nil
end