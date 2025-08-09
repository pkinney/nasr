defmodule NASR.Entities do
  @moduledoc false
  alias NASR.Entities.Airport
  alias NASR.Entities.AirportAirspace
  alias NASR.Entities.AirportAttendance
  alias NASR.Entities.AirportRemark
  alias NASR.Entities.AirRouteTrafficControlCenter
  alias NASR.Entities.AirRouteTrafficControlCenterBaseData
  alias NASR.Entities.AirRouteTrafficControlCenterCommunicationsFrequencyData
  alias NASR.Entities.AirRouteTrafficControlCenterFrequencyRemarksData
  alias NASR.Entities.AirRouteTrafficControlCenterSiteRemarksData
  alias NASR.Entities.AirwayBasicData
  alias NASR.Entities.AirwayChangeoverPoint
  alias NASR.Entities.AirwayChangeoverPointException
  alias NASR.Entities.AirwayPointDescription
  alias NASR.Entities.AirwayPointRemarks
  alias NASR.Entities.AirwayRemarks
  alias NASR.Entities.AutomatedTerminalInformationSystemAirwayPointDescription
  alias NASR.Entities.AutomatedTerminalInformationSystemAirwayPointRemarksText
  alias NASR.Entities.AutomatedTerminalInformationSystemAirwayRemarkText
  alias NASR.Entities.AutomatedTerminalInformationSystemBaseData
  alias NASR.Entities.AutomatedTerminalInformationSystemChangeoverPointDescription
  alias NASR.Entities.AutomatedTerminalInformationSystemChangeoverPointExceptionText
  alias NASR.Entities.AutomatedWeatherObservingSystemBaseData
  alias NASR.Entities.AutomatedWeatherObservingSystemRemarks
  alias NASR.Entities.CommunicationFacilityData
  alias NASR.Entities.DepartmentOfDefense
  alias NASR.Entities.FixBaseData
  alias NASR.Entities.FixChartingInformation
  alias NASR.Entities.FixILSMakeup
  alias NASR.Entities.FixNavaidMakeup
  alias NASR.Entities.FixRemarks
  alias NASR.Entities.FlightServiceStationData
  alias NASR.Entities.HoldingPatternBaseData
  alias NASR.Entities.HoldingPatternChartingData
  alias NASR.Entities.HoldingPatternOtherAltitudeSpeedInfo
  alias NASR.Entities.HoldingPatternRemarksText
  alias NASR.Entities.ILSBaseData
  alias NASR.Entities.ILSDMEData
  alias NASR.Entities.ILSGlideSlopeData
  alias NASR.Entities.ILSLocalizerData
  alias NASR.Entities.ILSMarkerBeaconData
  alias NASR.Entities.ILSRemarks
  alias NASR.Entities.LocationIdentifier
  alias NASR.Entities.MilitaryTrainingRouteAgencyData
  alias NASR.Entities.MilitaryTrainingRouteBaseData
  alias NASR.Entities.MilitaryTrainingRoutePointData
  alias NASR.Entities.MilitaryTrainingRouteProcedures
  alias NASR.Entities.MilitaryTrainingRouteTerrainFollowing
  alias NASR.Entities.MilitaryTrainingRouteWidth
  alias NASR.Entities.MiscellaneousActivityAreaBaseData
  alias NASR.Entities.MiscellaneousActivityAreaCheckNotams
  alias NASR.Entities.MiscellaneousActivityAreaContactFacility
  alias NASR.Entities.MiscellaneousActivityAreaPolygonCoordinates
  alias NASR.Entities.MiscellaneousActivityAreaRemarks
  alias NASR.Entities.MiscellaneousActivityAreaTimesOfUse
  alias NASR.Entities.MiscellaneousActivityAreaUserGroup
  alias NASR.Entities.NavigationAidAirspaceFixes
  alias NASR.Entities.NavigationAidBaseData
  alias NASR.Entities.NavigationAidFanMarkers
  alias NASR.Entities.NavigationAidHoldingPatterns
  alias NASR.Entities.NavigationAidRemarks
  alias NASR.Entities.NavigationAidVORCheckpoints
  alias NASR.Entities.ParachuteJumpAreaContactFacility
  alias NASR.Entities.ParachuteJumpAreaData
  alias NASR.Entities.ParachuteJumpAreaRemarks
  alias NASR.Entities.ParachuteJumpAreaTimesOfUse
  alias NASR.Entities.ParachuteJumpAreaUserGroup
  alias NASR.Entities.PreferredRouteData
  alias NASR.Entities.PreferredRouteSegment
  alias NASR.Entities.Runway
  alias NASR.Entities.StandardTerminalArrivalRoute
  alias NASR.Entities.TowerAirspaceData
  alias NASR.Entities.TowerATISData
  alias NASR.Entities.TowerBaseData
  alias NASR.Entities.TowerCommunicationsFrequencies
  alias NASR.Entities.TowerOperationHours
  alias NASR.Entities.TowerRadarData
  alias NASR.Entities.TowerRemarks
  alias NASR.Entities.TowerSatelliteAirportData
  alias NASR.Entities.TowerSatelliteAirportServices
  alias NASR.Entities.WxStation

  require Logger

  @entity_type_map %{
    Airport => {"apt", :apt},
    AirportAirspace => {"apt", :apt_ars},
    AirportAttendance => {"apt", :apt_att},
    AirportRemark => {"apt", :apt_rmk},
    Runway => {"apt", :apt_rwy},
    AirRouteTrafficControlCenter => {"artcc", :artcc},
    WxStation => {"wxl", :wxl},
    ILSBaseData => {"ils", :ils1},
    ILSLocalizerData => {"ils", :ils2},
    ILSGlideSlopeData => {"ils", :ils3},
    ILSDMEData => {"ils", :ils4},
    ILSMarkerBeaconData => {"ils", :ils5},
    ILSRemarks => {"ils", :ils6},
    PreferredRouteData => {"pfr", :pfr1},
    PreferredRouteSegment => {"pfr", :pfr2},
    ParachuteJumpAreaData => {"pja", :pja1},
    ParachuteJumpAreaTimesOfUse => {"pja", :pja2},
    ParachuteJumpAreaUserGroup => {"pja", :pja3},
    ParachuteJumpAreaContactFacility => {"pja", :pja4},
    ParachuteJumpAreaRemarks => {"pja", :pja5},
    LocationIdentifier => {"usa", :usa},
    NavigationAidBaseData => {"nav", :nav1},
    NavigationAidRemarks => {"nav", :nav2},
    NavigationAidAirspaceFixes => {"nav", :nav3},
    NavigationAidHoldingPatterns => {"nav", :nav4},
    NavigationAidFanMarkers => {"nav", :nav5},
    NavigationAidVORCheckpoints => {"nav", :nav6},
    FixBaseData => {"fix", :fix1},
    FixNavaidMakeup => {"fix", :fix2},
    FixILSMakeup => {"fix", :fix3},
    FixRemarks => {"fix", :fix4},
    FixChartingInformation => {"fix", :fix5},
    TowerBaseData => {"twr", :twr1},
    TowerOperationHours => {"twr", :twr2},
    TowerCommunicationsFrequencies => {"twr", :twr3},
    TowerSatelliteAirportServices => {"twr", :twr4},
    TowerRadarData => {"twr", :twr5},
    TowerRemarks => {"twr", :twr6},
    TowerSatelliteAirportData => {"twr", :twr7},
    TowerAirspaceData => {"twr", :twr8},
    TowerATISData => {"twr", :twr9},
    AirwayBasicData => {"awy", :awy1},
    AirwayPointDescription => {"awy", :awy2},
    AirwayChangeoverPoint => {"awy", :awy3},
    AirwayPointRemarks => {"awy", :awy4},
    AirwayChangeoverPointException => {"awy", :awy5},
    AirwayRemarks => {"awy", :awy_rmk},
    MilitaryTrainingRouteBaseData => {"mtr", :mtr1},
    MilitaryTrainingRouteProcedures => {"mtr", :mtr2},
    MilitaryTrainingRouteWidth => {"mtr", :mtr3},
    MilitaryTrainingRouteTerrainFollowing => {"mtr", :mtr4},
    MilitaryTrainingRoutePointData => {"mtr", :mtr5},
    MilitaryTrainingRouteAgencyData => {"mtr", :mtr6},
    MiscellaneousActivityAreaBaseData => {"maa", :maa1},
    MiscellaneousActivityAreaPolygonCoordinates => {"maa", :maa2},
    MiscellaneousActivityAreaTimesOfUse => {"maa", :maa3},
    MiscellaneousActivityAreaUserGroup => {"maa", :maa4},
    MiscellaneousActivityAreaContactFacility => {"maa", :maa5},
    MiscellaneousActivityAreaCheckNotams => {"maa", :maa6},
    MiscellaneousActivityAreaRemarks => {"maa", :maa7},
    AutomatedTerminalInformationSystemBaseData => {"ats", :ats1},
    AutomatedTerminalInformationSystemAirwayPointDescription => {"ats", :ats2},
    AutomatedTerminalInformationSystemChangeoverPointDescription => {"ats", :ats3},
    AutomatedTerminalInformationSystemAirwayPointRemarksText => {"ats", :ats4},
    AutomatedTerminalInformationSystemChangeoverPointExceptionText => {"ats", :ats5},
    AutomatedTerminalInformationSystemAirwayRemarkText => {"ats", :ats_rmk},
    CommunicationFacilityData => {"com", :com},
    DepartmentOfDefense => {"dod", :dod},
    FlightServiceStationData => {"fss", :fss},
    AirRouteTrafficControlCenterBaseData => {"aff", :aff1},
    AirRouteTrafficControlCenterSiteRemarksData => {"aff", :aff2},
    AirRouteTrafficControlCenterCommunicationsFrequencyData => {"aff", :aff3},
    AirRouteTrafficControlCenterFrequencyRemarksData => {"aff", :aff4},
    HoldingPatternBaseData => {"hp", :hp1},
    HoldingPatternChartingData => {"hp", :hp2},
    HoldingPatternOtherAltitudeSpeedInfo => {"hp", :hp3},
    HoldingPatternRemarksText => {"hp", :hp4},
    AutomatedWeatherObservingSystemBaseData => {"awos", :awos1},
    AutomatedWeatherObservingSystemRemarks => {"awos", :awos2},
    StandardTerminalArrivalRoute => {"star", :star}
  }

  @type_to_entity_map Map.new(@entity_type_map, fn {module, {_, type}} -> {type, module} end)

  def stream(zip_file, apt_file, layout) do
    zip_file
    |> Unzip.file_stream!(apt_file)
    |> Stream.map(fn c -> IO.iodata_to_binary(c) end)
    |> NimbleCSV.RFC4180.to_line_stream()
    |> Stream.map(fn line ->
      String.trim_trailing(line, "\r\n")
    end)
    |> Stream.map(fn line -> decode_line(line, layout) end)
    |> Stream.reject(&is_nil(&1))
  end

  def load(zip_file, apt_file, layout) do
    Enum.to_list(stream(zip_file, apt_file, layout))
  end

  defp decode_line(line, layout) do
    type_string = line |> String.slice(0, layout.key_length) |> String.trim()
    type = Map.get(layout.types, type_string)

    if type == nil do
      Logger.warning("[#{__MODULE__}] type #{inspect(type_string)} in line: #{line}")
    end

    layout.fields
    |> Enum.filter(fn {heading, _, _, _, _, _} -> heading == type end)
    |> Map.new(fn {_, just, type, len, start, key} -> {key, extract(line, {just, type, len, start})} end)
    |> Map.put(:type, type)
  end

  defp extract(line, {"L", "AN", len, start}) do
    line |> safe_slice(start - 1, len) |> String.trim_trailing()
  end

  defp extract(line, {"R", "AN", len, start}) do
    line |> safe_slice(start - 1, len) |> String.trim_leading()
  end

  defp extract(line, {"L", "N", len, start}) do
    line |> safe_slice(start - 1, len) |> String.trim_trailing()
  end

  defp extract(line, {"R", "N", len, start}) do
    line |> safe_slice(start - 1, len) |> String.trim_leading()
  end

  defp safe_slice(line, start, len) do
    line_length = byte_size(line)

    cond do
      start < 0 -> ""
      start >= line_length -> ""
      start + len > line_length -> binary_part(line, start, line_length - start)
      len <= 0 -> ""
      true -> binary_part(line, start, len)
    end
  end

  def entity_modules do
    with {:ok, list} <- :application.get_key(:nasr, :modules) do
      Enum.filter(list, &(length(Module.split(&1)) > 2 and &1 |> Module.split() |> Enum.take(2) == ~w(NASR Entities)))
    end
  end

  def type_to_entity(type) when is_atom(type) do
    Map.get(@type_to_entity_map, type)
  end

  def entity_to_category(module) when is_atom(module) do
    case Map.get(@entity_type_map, module) do
      nil -> nil
      {category, _type} -> category
    end
  end

  def entity_to_type(module) when is_atom(module) do
    case Map.get(@entity_type_map, module) do
      nil -> nil
      {_category, type} -> type
    end
  end

  def from_raw(%{type: type} = entity) when is_atom(type) do
    case type_to_entity(type) do
      nil -> nil
      module when is_atom(module) -> apply(module, :new, [entity])
    end
  end

  # def from_raw(%{type: :apt} = entity), do: NASR.Airport.new(entity)
  # def from_raw(%{type: :apt_rwy} = entity), do: NASR.Runway.new(entity)
  # def from_raw(%{type: :apt_rmk} = entity), do: NASR.AirportRemark.new(entity)
  # def from_raw(%{type: :apt_att} = entity), do: NASR.AirportAttendance.new(entity)
  # def from_raw(%{type: :ils1} = entity), do: ILSBaseData.new(entity)
  # def from_raw(%{type: :ils2} = entity), do: ILSLocalizerData.new(entity)
  # def from_raw(%{type: :ils3} = entity), do: ILSGlideSlopeData.new(entity)
  # def from_raw(%{type: :ils4} = entity), do: ILSDMEData.new(entity)
  # def from_raw(%{type: :ils5} = entity), do: ILSMarkerBeaconData.new(entity)
  # def from_raw(%{type: :ils6} = entity), do: ILSRemarks.new(entity)
  # def from_raw(%{type: :pfr1} = entity), do: PreferredRouteData.new(entity)
  # def from_raw(%{type: :pfr2} = entity), do: PreferredRouteSegment.new(entity)
  # def from_raw(%{type: :pja1} = entity), do: ParachuteJumpAreaData.new(entity)
  # def from_raw(%{type: :usa} = entity), do: LocationIdentifier.new(entity)
  # def from_raw(%{type: :nav1} = entity), do: NavigationAidBaseData.new(entity)
  # def from_raw(%{type: :nav2} = entity), do: NavigationAidRemarks.new(entity)
  # def from_raw(%{type: :nav3} = entity), do: NavigationAidAirspaceFixes.new(entity)
  # def from_raw(%{type: :nav4} = entity), do: NavigationAidHoldingPatterns.new(entity)
  # def from_raw(%{type: :nav5} = entity), do: NavigationAidFanMarkers.new(entity)
  # def from_raw(%{type: :nav6} = entity), do: NavigationAidVORCheckpoints.new(entity)
  # def from_raw(%{type: :pja2} = entity), do: ParachuteJumpAreaTimesOfUse.new(entity)
  # def from_raw(%{type: :pja3} = entity), do: ParachuteJumpAreaUserGroup.new(entity)
  # def from_raw(%{type: :pja4} = entity), do: ParachuteJumpAreaContactFacility.new(entity)
  # def from_raw(%{type: :pja5} = entity), do: ParachuteJumpAreaRemarks.new(entity)
  # def from_raw(%{type: :fix1} = entity), do: FixBaseData.new(entity)
  # def from_raw(%{type: :fix2} = entity), do: FixNavaidMakeup.new(entity)
  # def from_raw(%{type: :fix3} = entity), do: FixILSMakeup.new(entity)
  # def from_raw(%{type: :fix4} = entity), do: FixRemarks.new(entity)
  # def from_raw(%{type: :fix5} = entity), do: FixChartingInformation.new(entity)
  # def from_raw(%{type: :twr1} = entity), do: TowerBaseData.new(entity)
  # def from_raw(%{type: :twr2} = entity), do: TowerOperationHours.new(entity)
  # def from_raw(%{type: :twr3} = entity), do: TowerCommunicationsFrequencies.new(entity)
  # def from_raw(%{type: :twr4} = entity), do: TowerSatelliteAirportServices.new(entity)
  # def from_raw(%{type: :twr5} = entity), do: TowerRadarData.new(entity)
  # def from_raw(%{type: :twr6} = entity), do: TowerRemarks.new(entity)
  # def from_raw(%{type: :twr7} = entity), do: TowerSatelliteAirportData.new(entity)
  # def from_raw(%{type: :twr8} = entity), do: TowerAirspaceData.new(entity)
  # def from_raw(%{type: :twr9} = entity), do: TowerATISData.new(entity)
  # def from_raw(%{type: :awy1} = entity), do: AirwayBasicData.new(entity)
  # def from_raw(%{type: :awy2} = entity), do: AirwayPointDescription.new(entity)
  # def from_raw(%{type: :awy3} = entity), do: AirwayChangeoverPoint.new(entity)
  # def from_raw(%{type: :awy4} = entity), do: AirwayPointRemarks.new(entity)
  # def from_raw(%{type: :awy5} = entity), do: AirwayChangeoverPointException.new(entity)
  # def from_raw(%{type: :mtr1} = entity), do: MilitaryTrainingRouteBaseData.new(entity)
  # def from_raw(%{type: :mtr2} = entity), do: MilitaryTrainingRouteProcedures.new(entity)
  # def from_raw(%{type: :mtr3} = entity), do: MilitaryTrainingRouteWidth.new(entity)
  # def from_raw(%{type: :mtr4} = entity), do: MilitaryTrainingRouteTerrainFollowing.new(entity)
  # def from_raw(%{type: :mtr5} = entity), do: MilitaryTrainingRoutePointData.new(entity)
  # def from_raw(%{type: :mtr6} = entity), do: MilitaryTrainingRouteAgencyData.new(entity)
  # def from_raw(%{type: :maa1} = entity), do: MiscellaneousActivityAreaBaseData.new(entity)
  # def from_raw(%{type: :maa2} = entity), do: MiscellaneousActivityAreaPolygonCoordinates.new(entity)
  # def from_raw(%{type: :maa3} = entity), do: MiscellaneousActivityAreaTimesOfUse.new(entity)
  # def from_raw(%{type: :maa4} = entity), do: MiscellaneousActivityAreaUserGroup.new(entity)
  # def from_raw(%{type: :maa5} = entity), do: MiscellaneousActivityAreaContactFacility.new(entity)
  # def from_raw(%{type: :maa6} = entity), do: MiscellaneousActivityAreaCheckNotams.new(entity)
  # def from_raw(%{type: :maa7} = entity), do: MiscellaneousActivityAreaRemarks.new(entity)
  # def from_raw(%{type: :ats1} = entity), do: AutomatedTerminalInformationSystemBaseData.new(entity)

  # def from_raw(%{type: :ats2} = entity), do: AutomatedTerminalInformationSystemAirwayPointDescription.new(entity)

  # def from_raw(%{type: :ats3} = entity), do: AutomatedTerminalInformationSystemChangeoverPointDescription.new(entity)

  # def from_raw(%{type: :ats4} = entity), do: AutomatedTerminalInformationSystemAirwayPointRemarksText.new(entity)

  # def from_raw(%{type: :ats5} = entity), do: AutomatedTerminalInformationSystemChangeoverPointExceptionText.new(entity)

  # def from_raw(%{type: :ats_rmk} = entity), do: AutomatedTerminalInformationSystemAirwayRemarkText.new(entity)

  # def from_raw(%{type: :com} = entity), do: CommunicationFacilityData.new(entity)
  # def from_raw(%{type: :fss} = entity), do: FlightServiceStationData.new(entity)
  # def from_raw(%{type: :aff1} = entity), do: AirRouteTrafficControlCenterBaseData.new(entity)
  # def from_raw(%{type: :aff2} = entity), do: AirRouteTrafficControlCenterSiteRemarksData.new(entity)

  # def from_raw(%{type: :aff3} = entity), do: AirRouteTrafficControlCenterCommunicationsFrequencyData.new(entity)

  # def from_raw(%{type: :aff4} = entity), do: AirRouteTrafficControlCenterFrequencyRemarksData.new(entity)
  # def from_raw(%{type: :hp1} = entity), do: HoldingPatternBaseData.new(entity)
  # def from_raw(%{type: :hp2} = entity), do: HoldingPatternChartingData.new(entity)
  # def from_raw(%{type: :hp3} = entity), do: HoldingPatternOtherAltitudeSpeedInfo.new(entity)
  # def from_raw(%{type: :hp4} = entity), do: HoldingPatternRemarksText.new(entity)
  # def from_raw(%{type: :awos1} = entity), do: AutomatedWeatherObservingSystemBaseData.new(entity)
  # def from_raw(%{type: :awos2} = entity), do: AutomatedWeatherObservingSystemRemarks.new(entity)
  # def from_raw(_), do: nil
end
