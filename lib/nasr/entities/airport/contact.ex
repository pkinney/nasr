defmodule NASR.Entities.Airport.Contact do
  @moduledoc """
  Represents Airport Contact Information from the NASR APT_CON data.

  This entity contains contact information for various roles at airport facilities,
  including managers, owners, assistant managers, and other personnel.

  ## Fields

  * `:site_no` - Landing Facility Site Number (unique identifying number)
  * `:site_type_code` - Landing Facility Type Code
  * `:arpt_id` - Location Identifier (unique 3-4 character alphanumeric identifier)
  * `:city` - Airport Associated City Name
  * `:state_code` - Associated State Post Office Code
  * `:country_code` - Country Post Office Code
  * `:title` - Title of Contact (e.g., MANAGER, OWNER, ASST-MGR, etc.)
  * `:name` - Facility Contact Name for the title
  * `:address_line_1` - Contact Address Line 1
  * `:address_line_2` - Contact Address Line 2
  * `:contact_city` - Contact City
  * `:contact_state` - Contact State
  * `:zip_code` - Contact Zip Code
  * `:zip_plus_four` - Contact Zip Plus Four
  * `:phone_number` - Contact Phone Number
  * `:eff_date` - The 28 Day NASR Subscription Effective Date

  """
  import NASR.Utils

  defstruct ~w(
    site_no
    site_type_code
    arpt_id
    city
    state_code
    country_code
    title
    name
    address_line_1
    address_line_2
    contact_city
    contact_state
    zip_code
    zip_plus_four
    phone_number
    eff_date
  )a

  @type t() :: %__MODULE__{
          site_no: String.t(),
          site_type_code: String.t(),
          arpt_id: String.t(),
          city: String.t(),
          state_code: String.t(),
          country_code: String.t(),
          title: String.t(),
          name: String.t(),
          address_line_1: String.t(),
          address_line_2: String.t(),
          contact_city: String.t(),
          contact_state: String.t(),
          zip_code: String.t(),
          zip_plus_four: String.t(),
          phone_number: String.t(),
          eff_date: Date.t() | nil
        }

  @spec new(map()) :: t()
  def new(entity) do
    %__MODULE__{
      site_no: Map.fetch!(entity, "SITE_NO"),
      site_type_code: Map.fetch!(entity, "SITE_TYPE_CODE"),
      arpt_id: Map.fetch!(entity, "ARPT_ID"),
      city: Map.fetch!(entity, "CITY"),
      state_code: Map.fetch!(entity, "STATE_CODE"),
      country_code: Map.fetch!(entity, "COUNTRY_CODE"),
      title: Map.fetch!(entity, "TITLE"),
      name: Map.fetch!(entity, "NAME"),
      address_line_1: Map.fetch!(entity, "ADDRESS1"),
      address_line_2: Map.fetch!(entity, "ADDRESS2"),
      contact_city: Map.fetch!(entity, "TITLE_CITY"),
      contact_state: Map.fetch!(entity, "STATE"),
      zip_code: Map.fetch!(entity, "ZIP_CODE"),
      zip_plus_four: Map.fetch!(entity, "ZIP_PLUS_FOUR"),
      phone_number: Map.fetch!(entity, "PHONE_NO"),
      eff_date: parse_date(Map.fetch!(entity, "EFF_DATE"))
    }
  end

  @spec type() :: String.t()
  def type(), do: "APT_CON"
end