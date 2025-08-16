defmodule NASR.Entities.MaximumAuthorizedAltitude.Shape do
  @moduledoc """
  Represents Maximum Authorized Altitude Shape information from the NASR MAA_SHP data.

  This entity contains geographic boundary points that define the precise shape and 
  extent of Maximum Authorized Altitude areas. For irregularly shaped airspace areas,
  multiple coordinate points define the boundary polygon, ensuring accurate geographic
  representation of the special use airspace.

  Shape data is critical for flight planning systems, GPS navigation databases, and
  air traffic control systems to accurately determine when aircraft are entering,
  operating within, or exiting special use airspace areas. The coordinate points
  are typically ordered sequentially to form a closed polygon boundary.

  ## Fields

  * `:effective_date` - The 28 Day NASR Subscription Effective Date in format 'YYYY/MM/DD'
  * `:maa_id` - Maximum Authorized Altitude Identifier
  * `:point_seq` - Sequence number for boundary points (defines polygon order)
  * `:latitude` - Latitude coordinate of boundary point in Decimal Format
  * `:longitude` - Longitude coordinate of boundary point in Decimal Format
  """
  import NASR.Utils

  defstruct ~w(
    effective_date
    maa_id
    point_seq
    latitude
    longitude
  )a

  @type t() :: %__MODULE__{
          effective_date: Date.t() | nil,
          maa_id: String.t(),
          point_seq: integer() | nil,
          latitude: float() | nil,
          longitude: float() | nil
        }

  @spec type() :: String.t()
  def type, do: "MAA_SHP"

  @spec new(map()) :: t()
  def new(entity) do
    %__MODULE__{
      effective_date: parse_date(Map.fetch!(entity, "EFF_DATE")),
      maa_id: Map.fetch!(entity, "MAA_ID"),
      point_seq: safe_str_to_int(Map.fetch!(entity, "POINT_SEQ")),
      latitude: parse_coordinate(Map.fetch!(entity, "LATITUDE")),
      longitude: parse_coordinate(Map.fetch!(entity, "LONGITUDE"))
    }
  end

  defp parse_coordinate(nil), do: nil
  defp parse_coordinate(""), do: nil
  defp parse_coordinate(coord) when is_binary(coord) do
    # Parse coordinates in format like "33-54-12.8500N" or "087-19-53.7600W"
    coord = String.trim(coord)
    
    cond do
      String.ends_with?(coord, "N") or String.ends_with?(coord, "S") or 
      String.ends_with?(coord, "E") or String.ends_with?(coord, "W") ->
        parse_dms_coordinate(coord)
      
      true ->
        safe_str_to_float(coord)
    end
  end

  defp parse_dms_coordinate(coord) do
    direction = String.last(coord)
    coord_without_dir = String.slice(coord, 0, String.length(coord) - 1)
    
    case String.split(coord_without_dir, "-") do
      [degrees, minutes, seconds] ->
        deg = safe_str_to_float(degrees) || 0
        min = safe_str_to_float(minutes) || 0
        sec = safe_str_to_float(seconds) || 0
        
        decimal = deg + (min / 60.0) + (sec / 3600.0)
        
        # Apply negative for South/West coordinates
        case direction do
          "S" -> -decimal
          "W" -> -decimal
          _ -> decimal
        end
      
      _ ->
        safe_str_to_float(coord_without_dir)
    end
  end
end