defmodule NASR.Entities.NavigationAidAirspaceFixes do
  @moduledoc "Entity struct for NAV3 (COMPULSORY AND NON-COMPULSORY AIRSPACE FIXES ASSOCIATED WITH NAVAID) records"
  import NASR.Utils

  defstruct [
    :record_type_indicator,
    :navaid_facility_identifier,
    :navaid_facility_type,
    :fix_names
  ]

  @type t() :: %__MODULE__{
    record_type_indicator: String.t() | nil,
    navaid_facility_identifier: String.t() | nil,
    navaid_facility_type: String.t() | nil,
    fix_names: [String.t()] | nil
  }

  @spec new(map()) :: t()
  def new(entry) do
    # Parse fix names from the concatenated field
    fix_names = parse_fix_names(entry.name_s_of_fixes_fix_file_the_id_s_of)

    %__MODULE__{
      record_type_indicator: entry.record_type_indicator,
      navaid_facility_identifier: entry.navaid_facility_identifier,
      navaid_facility_type: entry.navaid_facitity_type_ex_vor_dme,
      fix_names: fix_names
    }
  end

  # Parse fix names from format: "FIX NAME*FIX STATE*ICAO REGION CODE"
  # Multiple fixes separated by spaces
  defp parse_fix_names(nil), do: nil
  defp parse_fix_names(""), do: nil
  defp parse_fix_names(fix_string) do
    fix_string
    |> String.trim()
    |> String.split(~r/\s+/, trim: true)
    |> Enum.filter(&(&1 != ""))
    |> case do
      [] -> nil
      fixes -> fixes
    end
  end
end