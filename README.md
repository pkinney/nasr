# Nasr

## Download FAA Data Releases

- **NASR** - https://www.faa.gov/air_traffic/flight_info/aeronav/aero_data/NASR_Subscription/
- **CIFP** - https://www.faa.gov/air_traffic/flight_info/aeronav/digital_products/cifp/download/

## Usage

### Improving Performance

```bash
mix nasr.preprocess
```

This will read in the NASR data from the zip file, convert it to Elixir terms, and save those terms to a local file.

Calling `NASR.stream/2` will selectively choose the raw zip file or the preprocessed files. Using the preprocessed file will increase the streaming speed up to \_\_\_\_%.

## Entity Modules

### Airport Data
- `NASR.Airport` (APT) - Airport base data
- `NASR.AirportAttendance` (APT_ATT) - Airport attendance schedules
- `NASR.AirportRemark` (APT_RMK) - Airport remarks
- `NASR.Runway` (APT_RWY) - Runway data

### ILS Data
- `NASR.Entities.ILSBaseData` (ILS1) - ILS base data
- `NASR.Entities.ILSLocalizerData` (ILS2) - ILS localizer data
- `NASR.Entities.ILSGlideSlopeData` (ILS3) - ILS glide slope data
- `NASR.Entities.ILSDMEData` (ILS4) - ILS distance measuring equipment data
- `NASR.Entities.ILSMarkerBeaconData` (ILS5) - ILS marker beacon data
- `NASR.Entities.ILSRemarks` (ILS6) - ILS remarks

### Preferred Route Data
- `NASR.Entities.PreferredRouteData` (PFR1) - Base route data
- `NASR.Entities.PreferredRouteSegment` (PFR2) - Route segment descriptions

### Parachute Jump Area Data
- `NASR.Entities.ParachuteJumpAreaData` (PJA1) - Base airspace data
- `NASR.Entities.ParachuteJumpAreaTimesOfUse` (PJA2) - Times of use information
- `NASR.Entities.ParachuteJumpAreaUserGroup` (PJA3) - User group information
- `NASR.Entities.ParachuteJumpAreaContactFacility` (PJA4) - Contact facility frequency data
- `NASR.Entities.ParachuteJumpAreaRemarks` (PJA5) - Remarks about parachute jump areas

### Navigation Aid Data
- `NASR.Entities.NavigationAidBaseData` (NAV1) - Navigation aid base data
- `NASR.Entities.NavigationAidRemarks` (NAV2) - Navigation aid remarks
- `NASR.Entities.NavigationAidAirspaceFixes` (NAV3) - Airspace fixes associated with navigation aids
- `NASR.Entities.NavigationAidHoldingPatterns` (NAV4) - Holding patterns associated with navigation aids
- `NASR.Entities.NavigationAidFanMarkers` (NAV5) - Fan markers associated with navigation aids
- `NASR.Entities.NavigationAidVORCheckpoints` (NAV6) - VOR receiver checkpoints associated with navigation aids

### Fix Data
- `NASR.Entities.FixBaseData` (FIX1) - Base fix data
- `NASR.Entities.FixNavaidMakeup` (FIX2) - Fix navaid makeup text
- `NASR.Entities.FixILSMakeup` (FIX3) - Fix ILS makeup text
- `NASR.Entities.FixRemarks` (FIX4) - Fix remarks text
- `NASR.Entities.FixChartingInformation` (FIX5) - Fix charting information

### Location Identifier Data
- `NASR.Entities.LocationIdentifier` (USA) - Location identifiers

### Tower/Terminal Communications Data
- `NASR.Entities.TowerBaseData` (TWR1) - Base tower/terminal communications data
- `NASR.Entities.TowerOperationHours` (TWR2) - Operation hours
- `NASR.Entities.TowerCommunicationsFrequencies` (TWR3) - Communications frequencies
- `NASR.Entities.TowerSatelliteAirportServices` (TWR4) - Satellite airport services
- `NASR.Entities.TowerRadarData` (TWR5) - Radar data
- `NASR.Entities.TowerRemarks` (TWR6) - Remarks
- `NASR.Entities.TowerSatelliteAirportData` (TWR7) - Satellite airport data
- `NASR.Entities.TowerAirspaceData` (TWR8) - Airspace classes (B/C/D/E)
- `NASR.Entities.TowerATISData` (TWR9) - ATIS data

### Airway Data
- `NASR.Entities.AirwayBasicData` (AWY1) - Basic airway and MEA data
- `NASR.Entities.AirwayPointDescription` (AWY2) - Airway point descriptions
- `NASR.Entities.AirwayChangeoverPoint` (AWY3) - Changeover points
- `NASR.Entities.AirwayPointRemarks` (AWY4) - Point remarks
- `NASR.Entities.AirwayChangeoverPointException` (AWY5) - Changeover point exceptions

### Military Training Route Data
- `NASR.Entities.MilitaryTrainingRouteBaseData` (MTR1) - Base route data
- `NASR.Entities.MilitaryTrainingRouteProcedures` (MTR2) - Operating procedures
- `NASR.Entities.MilitaryTrainingRouteWidth` (MTR3) - Route width descriptions
- `NASR.Entities.MilitaryTrainingRouteTerrainFollowing` (MTR4) - Terrain following operations
- `NASR.Entities.MilitaryTrainingRoutePointData` (MTR5) - Route point data
- `NASR.Entities.MilitaryTrainingRouteAgencyData` (MTR6) - Agency data

### Miscellaneous Activity Area Data
- `NASR.Entities.MiscellaneousActivityAreaBaseData` (MAA1) - Base activity area data
- `NASR.Entities.MiscellaneousActivityAreaPolygonCoordinates` (MAA2) - Polygon coordinates
- `NASR.Entities.MiscellaneousActivityAreaTimesOfUse` (MAA3) - Times of use
- `NASR.Entities.MiscellaneousActivityAreaUserGroup` (MAA4) - User groups
- `NASR.Entities.MiscellaneousActivityAreaContactFacility` (MAA5) - Contact facilities
- `NASR.Entities.MiscellaneousActivityAreaCheckNotams` (MAA6) - Check NOTAMs
- `NASR.Entities.MiscellaneousActivityAreaRemarks` (MAA7) - Remarks

### Automated Terminal Information System Data
- `NASR.Entities.AutomatedTerminalInformationSystemBaseData` (ATS1) - Base ATIS data
- `NASR.Entities.AutomatedTerminalInformationSystemAirwayPointDescription` (ATS2) - Airway point descriptions
- `NASR.Entities.AutomatedTerminalInformationSystemChangeoverPointDescription` (ATS3) - Changeover point descriptions
- `NASR.Entities.AutomatedTerminalInformationSystemAirwayPointRemarksText` (ATS4) - Airway point remarks
- `NASR.Entities.AutomatedTerminalInformationSystemChangeoverPointExceptionText` (ATS5) - Changeover point exceptions
- `NASR.Entities.AutomatedTerminalInformationSystemAirwayRemarkText` (ATS_RMK) - Airway remark text

### Communication Facility Data
- `NASR.Entities.CommunicationFacilityData` (COM) - Communication facility data

### Flight Service Station Data
- `NASR.Entities.FlightServiceStationData` (FSS) - Flight service station data

### Air Route Traffic Control Center Data
- `NASR.Entities.AirRouteTrafficControlCenterBaseData` (AFF1) - Base ARTCC data
- `NASR.Entities.AirRouteTrafficControlCenterSiteRemarksData` (AFF2) - Site remarks
- `NASR.Entities.AirRouteTrafficControlCenterCommunicationsFrequencyData` (AFF3) - Communications frequencies
- `NASR.Entities.AirRouteTrafficControlCenterFrequencyRemarksData` (AFF4) - Frequency remarks

### Holding Pattern Data
- `NASR.Entities.HoldingPatternBaseData` (HP1) - Base holding pattern data
- `NASR.Entities.HoldingPatternChartingData` (HP2) - Charting data
- `NASR.Entities.HoldingPatternOtherAltitudeSpeedInfo` (HP3) - Other altitude/speed information
- `NASR.Entities.HoldingPatternRemarksText` (HP4) - Remarks text

### Automated Weather Observing System Data
- `NASR.Entities.AutomatedWeatherObservingSystemBaseData` (AWOS1) - Base AWOS/ASOS data
- `NASR.Entities.AutomatedWeatherObservingSystemRemarks` (AWOS2) - AWOS/ASOS remarks
