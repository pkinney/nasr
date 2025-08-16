defmodule NASR.Entities.ClassAirspace do
  @moduledoc """
  Represents Class Airspace information from the NASR CLS_ARSP data.

  Class Airspace entities define controlled airspace areas around airports
  where air traffic control services are provided. Each class of airspace
  has different operational requirements, equipment requirements, and
  communication procedures.

  ## Airspace Classes

  * **Class B** - Busiest airports with high-volume commercial traffic
  * **Class C** - Airports with moderate commercial traffic
  * **Class D** - Airports with control towers but less traffic than Class C
  * **Class E** - Controlled airspace not designated as A, B, C, or D

  ## Fields

  * `:effective_date` - The 28 Day NASR Subscription Effective Date in format 'YYYY/MM/DD'
  * `:site_no` - Landing Facility Site Number (unique identifying number)
  * `:site_type_code` - Landing Facility Type Code ('A' for Airport)
  * `:state_code` - Associated State Post Office Code
  * `:arpt_id` - Location Identifier (unique 3-4 character alphanumeric identifier)
  * `:city` - Airport Associated City Name
  * `:country_code` - Country Post Office Code (typically 'US')
  * `:class_b_airspace` - Presence of Class B airspace (boolean)
  * `:class_c_airspace` - Presence of Class C airspace (boolean)
  * `:class_d_airspace` - Presence of Class D airspace (boolean)
  * `:class_e_airspace` - Presence of Class E airspace (boolean)
  * `:airspace_hrs` - Hours of Operation for the airspace
  * `:remark` - Additional remarks about airspace operations
  """
  import NASR.Utils

  defstruct ~w(
    effective_date
    site_no
    site_type_code
    state_code
    arpt_id
    city
    country_code
    class_b_airspace
    class_c_airspace
    class_d_airspace
    class_e_airspace
    airspace_hrs
    remark
  )a

  @type t() :: %__MODULE__{
          effective_date: Date.t() | nil,
          site_no: String.t(),
          site_type_code: String.t(),
          state_code: String.t(),
          arpt_id: String.t(),
          city: String.t(),
          country_code: String.t(),
          class_b_airspace: boolean() | nil,
          class_c_airspace: boolean() | nil,
          class_d_airspace: boolean() | nil,
          class_e_airspace: boolean() | nil,
          airspace_hrs: String.t(),
          remark: String.t()
        }

  @spec type() :: String.t()
  def type, do: "CLS_ARSP"

  @spec new(map()) :: t()
  def new(entity) do
    %__MODULE__{
      effective_date: parse_date(Map.fetch!(entity, "EFF_DATE")),
      site_no: Map.fetch!(entity, "SITE_NO"),
      site_type_code: Map.fetch!(entity, "SITE_TYPE_CODE"),
      state_code: Map.fetch!(entity, "STATE_CODE"),
      arpt_id: Map.fetch!(entity, "ARPT_ID"),
      city: Map.fetch!(entity, "CITY"),
      country_code: Map.fetch!(entity, "COUNTRY_CODE"),
      class_b_airspace: convert_yn(Map.fetch!(entity, "CLASS_B_AIRSPACE")),
      class_c_airspace: convert_yn(Map.fetch!(entity, "CLASS_C_AIRSPACE")),
      class_d_airspace: convert_yn(Map.fetch!(entity, "CLASS_D_AIRSPACE")),
      class_e_airspace: convert_yn(Map.fetch!(entity, "CLASS_E_AIRSPACE")),
      airspace_hrs: Map.fetch!(entity, "AIRSPACE_HRS"),
      remark: Map.fetch!(entity, "REMARK")
    }
  end
end