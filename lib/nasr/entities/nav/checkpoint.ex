defmodule NASR.Entities.Nav.Checkpoint do
  @moduledoc """
  Represents Navigation Aid Checkpoints from the NASR NAV_CKPT data.

  Navigation aid checkpoints are specific points used for navigation and air traffic
  control in relation to navigation aids. These checkpoints can be either ground
  or air checkpoints with specific bearings and descriptions.

  ## Fields

  * `:effective_date` - The 28 Day NASR Subscription Effective Date in format 'YYYY/MM/DD'
  * `:nav_id` - NAVAID Facility Identifier
  * `:nav_type` - NAVAID Facility Type
  * `:state_code` - Associated State Post Office Code standard two letter abbreviation for US States and Territories
  * `:city` - NAVAID Associated City Name
  * `:country_code` - Country Post Office Code NAVAID Located
  * `:altitude` - Altitude Only When Checkpoint is in Air (integer in feet)
  * `:bearing` - Bearing of Checkpoint (integer in degrees)
  * `:air_ground_code` - Air/Ground Code. Values: `:air`, `:ground`, `:ground_one`
  * `:checkpoint_description` - Narrative Description Associated with the Checkpoint in AIR/Ground
  * `:airport_id` - Airport ID
  * `:state_checkpoint_code` - State Code in Which Associated City is Located
  """
  import NASR.Utils

  defstruct ~w(
    effective_date
    nav_id
    nav_type
    state_code
    city
    country_code
    altitude
    bearing
    air_ground_code
    checkpoint_description
    airport_id
    state_checkpoint_code
  )a

  @type t() :: %__MODULE__{
          effective_date: Date.t() | nil,
          nav_id: String.t(),
          nav_type: String.t(),
          state_code: String.t(),
          city: String.t(),
          country_code: String.t(),
          altitude: integer() | nil,
          bearing: integer() | nil,
          air_ground_code: :air | :ground | :ground_one | String.t() | nil,
          checkpoint_description: String.t(),
          airport_id: String.t(),
          state_checkpoint_code: String.t()
        }

  @spec type() :: String.t()
  def type, do: "NAV_CKPT"

  @spec new(map()) :: t()
  def new(entity) do
    %__MODULE__{
      effective_date: parse_date(Map.fetch!(entity, "EFF_DATE")),
      nav_id: Map.fetch!(entity, "NAV_ID"),
      nav_type: Map.fetch!(entity, "NAV_TYPE"),
      state_code: Map.fetch!(entity, "STATE_CODE"),
      city: Map.fetch!(entity, "CITY"),
      country_code: Map.fetch!(entity, "COUNTRY_CODE"),
      altitude: safe_str_to_int(Map.fetch!(entity, "ALTITUDE")),
      bearing: safe_str_to_int(Map.fetch!(entity, "BRG")),
      air_ground_code: parse_air_ground_code(Map.fetch!(entity, "AIR_GND_CODE")),
      checkpoint_description: Map.fetch!(entity, "CHK_DESC"),
      airport_id: Map.fetch!(entity, "ARPT_ID"),
      state_checkpoint_code: Map.fetch!(entity, "STATE_CHK_CODE")
    }
  end

  defp parse_air_ground_code(nil), do: nil
  defp parse_air_ground_code(""), do: nil
  defp parse_air_ground_code(code) when is_binary(code) do
    case String.trim(code) do
      "A" -> :air
      "G" -> :ground
      "G1" -> :ground_one
      other -> other
    end
  end
end