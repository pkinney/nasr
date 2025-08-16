defmodule NASR.Entities.AirRouteBoundary.Segment do
  @moduledoc """
  Represents Air Route Boundary Segment information from the NASR ARB_SEG data.

  Air Route Boundary Segments define the specific geographic boundaries between
  Air Route Traffic Control Centers (ARTCCs). These segments form continuous
  boundary lines that separate areas of responsibility for different air traffic
  control centers at various altitude levels.

  ## Altitude Types

  * **HIGH** - High altitude segments (typically above 18,000 feet)
  * **LOW** - Low altitude segments (typically below 18,000 feet)

  ## Boundary Point Types

  * **Common Boundaries** - Shared boundaries between multiple ARTCCs
  * **Exclusive Boundaries** - Boundaries specific to one ARTCC

  ## Fields

  * `:effective_date` - The 28 Day NASR Subscription Effective Date in format 'YYYY/MM/DD'
  * `:record_id` - Unique record identifier for the boundary segment
  * `:location_id` - ARTCC location identifier
  * `:location_name` - ARTCC location name
  * `:altitude` - Altitude level designation (:high, :low)
  * `:boundary_type` - Type of boundary (:artcc)
  * `:point_sequence` - Sequence number of the boundary point
  * `:latitude_degrees` - Latitude degrees component
  * `:latitude_minutes` - Latitude minutes component
  * `:latitude_seconds` - Latitude seconds component
  * `:latitude_hemisphere` - Latitude hemisphere ('N' or 'S')
  * `:latitude_decimal` - Latitude in decimal degrees
  * `:longitude_degrees` - Longitude degrees component
  * `:longitude_minutes` - Longitude minutes component
  * `:longitude_seconds` - Longitude seconds component
  * `:longitude_hemisphere` - Longitude hemisphere ('E' or 'W')
  * `:longitude_decimal` - Longitude in decimal degrees
  * `:boundary_point_description` - Description of the boundary point and common areas
  * `:nas_description_flag` - National Airspace System description flag
  """
  import NASR.Utils

  defstruct ~w(
    effective_date
    record_id
    location_id
    location_name
    altitude
    boundary_type
    point_sequence
    latitude_degrees
    latitude_minutes
    latitude_seconds
    latitude_hemisphere
    latitude_decimal
    longitude_degrees
    longitude_minutes
    longitude_seconds
    longitude_hemisphere
    longitude_decimal
    boundary_point_description
    nas_description_flag
  )a

  @type t() :: %__MODULE__{
          effective_date: Date.t() | nil,
          record_id: String.t(),
          location_id: String.t(),
          location_name: String.t(),
          altitude: :high | :low | String.t() | nil,
          boundary_type: :artcc | String.t() | nil,
          point_sequence: integer() | nil,
          latitude_degrees: integer() | nil,
          latitude_minutes: integer() | nil,
          latitude_seconds: float() | nil,
          latitude_hemisphere: String.t(),
          latitude_decimal: float() | nil,
          longitude_degrees: integer() | nil,
          longitude_minutes: integer() | nil,
          longitude_seconds: float() | nil,
          longitude_hemisphere: String.t(),
          longitude_decimal: float() | nil,
          boundary_point_description: String.t(),
          nas_description_flag: String.t()
        }

  @spec type() :: String.t()
  def type, do: "ARB_SEG"

  @spec new(map()) :: t()
  def new(entity) do
    %__MODULE__{
      effective_date: parse_date(Map.fetch!(entity, "EFF_DATE")),
      record_id: Map.fetch!(entity, "REC_ID"),
      location_id: Map.fetch!(entity, "LOCATION_ID"),
      location_name: Map.fetch!(entity, "LOCATION_NAME"),
      altitude: parse_altitude(Map.fetch!(entity, "ALTITUDE")),
      boundary_type: parse_boundary_type(Map.fetch!(entity, "TYPE")),
      point_sequence: safe_str_to_int(Map.fetch!(entity, "POINT_SEQ")),
      latitude_degrees: safe_str_to_int(Map.fetch!(entity, "LAT_DEG")),
      latitude_minutes: safe_str_to_int(Map.fetch!(entity, "LAT_MIN")),
      latitude_seconds: safe_str_to_float(Map.fetch!(entity, "LAT_SEC")),
      latitude_hemisphere: Map.fetch!(entity, "LAT_HEMIS"),
      latitude_decimal: safe_str_to_float(Map.fetch!(entity, "LAT_DECIMAL")),
      longitude_degrees: safe_str_to_int(Map.fetch!(entity, "LONG_DEG")),
      longitude_minutes: safe_str_to_int(Map.fetch!(entity, "LONG_MIN")),
      longitude_seconds: safe_str_to_float(Map.fetch!(entity, "LONG_SEC")),
      longitude_hemisphere: Map.fetch!(entity, "LONG_HEMIS"),
      longitude_decimal: safe_str_to_float(Map.fetch!(entity, "LONG_DECIMAL")),
      boundary_point_description: Map.fetch!(entity, "BNDRY_PT_DESCRIP"),
      nas_description_flag: Map.fetch!(entity, "NAS_DESCRIP_FLAG")
    }
  end

  defp parse_altitude(nil), do: nil
  defp parse_altitude(""), do: nil
  defp parse_altitude(altitude) when is_binary(altitude) do
    case String.trim(altitude) do
      "HIGH" -> :high
      "LOW" -> :low
      other -> other
    end
  end

  defp parse_boundary_type(nil), do: nil
  defp parse_boundary_type(""), do: nil
  defp parse_boundary_type(type) when is_binary(type) do
    case String.trim(type) do
      "ARTCC" -> :artcc
      other -> other
    end
  end
end