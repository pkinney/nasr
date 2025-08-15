defmodule NASR.Entities.Airport.Remarks do
  @moduledoc """
  Represents Airport Remarks from the NASR APT_RMK data.

  This entity contains free-form text remarks that provide additional information
  about specific aspects of airport facilities, operations, or conditions.

  ## Fields

  * `:site_no` - Landing Facility Site Number (unique identifying number)
  * `:site_type_code` - Landing Facility Type Code
  * `:arpt_id` - Location Identifier (unique 3-4 character alphanumeric identifier)
  * `:city` - Airport Associated City Name
  * `:state_code` - Associated State Post Office Code
  * `:country_code` - Country Post Office Code
  * `:legacy_element_number` - Legacy Remark Element Number (equivalent to legacy APT.txt element name)
  * `:table_name` - NASR Table name associated with the remark
  * `:reference_column_name` - NASR Column name associated with the remark (GENERAL_REMARK for non-specific remarks)
  * `:element` - Specific element that the remark text pertains to
  * `:reference_column_sequence_no` - Sequence number assigned to Reference Column Remark
  * `:remark_text` - Free form text that further describes a specific information item
  * `:eff_date` - The 28 Day NASR Subscription Effective Date

  ## Remark Categories

  The table_name and element fields help categorize remarks by their subject:
  - AIRPORT ATTEND SCHED: SKED SEQ NO
  - AIRPORT CONTACT: TITLE
  - AIRPORT SERVICE: SERVICE TYPE CODE
  - ARRESTING DEVICE: RWY END ID _ ARREST DEVICE CODE
  - FUEL TYPE: FUEL TYPE
  - RUNWAY: RWY ID
  - RUNWAY END: RWY END ID
  - RUNWAY END OBSTN: RWY END ID
  - RUNWAY SURFACE TYPE: RWY ID

  ## Data Source

  This data comes from the FAA's National Airspace System Resources (NASR) subscription,
  specifically from the APT_RMK.csv file. The data is updated on a 28-day cycle.
  """
  import NASR.Utils

  defstruct ~w(
    site_no
    site_type_code
    arpt_id
    city
    state_code
    country_code
    legacy_element_number
    table_name
    reference_column_name
    element
    reference_column_sequence_no
    remark_text
    eff_date
  )a

  @type t() :: %__MODULE__{}

  @spec new(map()) :: t()
  def new(entity) do
    %__MODULE__{
      site_no: Map.fetch!(entity, "SITE_NO"),
      site_type_code: Map.fetch!(entity, "SITE_TYPE_CODE"),
      arpt_id: Map.fetch!(entity, "ARPT_ID"),
      city: Map.fetch!(entity, "CITY"),
      state_code: Map.fetch!(entity, "STATE_CODE"),
      country_code: Map.fetch!(entity, "COUNTRY_CODE"),
      legacy_element_number: Map.fetch!(entity, "LEGACY_ELEMENT_NUMBER"),
      table_name: Map.fetch!(entity, "TAB_NAME"),
      reference_column_name: Map.fetch!(entity, "REF_COL_NAME"),
      element: Map.fetch!(entity, "ELEMENT"),
      reference_column_sequence_no: safe_str_to_int(Map.fetch!(entity, "REF_COL_SEQ_NO")),
      remark_text: Map.fetch!(entity, "REMARK"),
      eff_date: parse_date(Map.fetch!(entity, "EFF_DATE"))
    }
  end

  @spec type() :: String.t()
  def type(), do: "APT_RMK"
end