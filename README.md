# NASR

An Elixir library for streaming FAA NASR 28‑day subscription data, converting rows to typed structs with parsing helpers, and leaving a `meta` map on every entity for consumer annotations.

## Installation

Add to `mix.exs`:

```elixir
def deps do
  [
    {:nasr, "~> 0.1.0"}
  ]
end
```

## Usage

Stream raw CSV rows (string-keyed maps) with file/type markers:

```elixir
NASR.stream_raw(file: "path/to/nasr.zip")
# => %{
#      "__FILE__" => "FIX_BASE.csv",
#      "__TYPE__" => "FIX_BASE",
#      "FIX_ID" => "SASIE",
#      "FIX_ID_OLD" => "SASS",
#      "LAT_DECIMAL" => "45.0",
#      "LONG_DECIMAL" => "-93.0",
#      "STATE_CODE" => "MN",
#      "COUNTRY_CODE" => "US",
#      "ICAO_REGION_CODE" => "K3",
#      "FIX_USE_CODE" => "CN",
#      "ARTCC_ID_HIGH" => "ZMP",
#      "ARTCC_ID_LOW" => "ZMP",
#      "CHARTING_REMARK" => "Remark",
#      "PITCH_FLAG" => "Y",
#      "CATCH_FLAG" => "N",
#      "SUA_ATCAA_FLAG" => "Y",
#      "MIN_RECEP_ALT" => "5000",
#      "COMPULSORY" => "LOW",
#      "CHARTS" => "Chart1",
#      "EFF_DATE" => "2025/11/27"
#      # numeric fields and flags remain strings until parsed by entity modules
#      # headers are trimmed/ASCII-sanitized; values are untouched raw CSV strings
#    }
```

Stream typed entities (structs) with parsed fields and `meta` defaulting to `%{}`:

```elixir
NASR.stream_entities(file: "path/to/nasr.zip", include: ["FIX_BASE"])
# => %NASR.Entities.Fix{
#      __struct__: NASR.Entities.Fix,
#      fix_id: "SASIE",
#      fix_id_old: "SASS",
#      latitude: 45.0,
#      longitude: -93.0,
#      state_code: "MN",
#      country_code: "US",
#      icao_region_code: "K3",
#      fix_use_code: :computer_navigation_fix,
#      artcc_id_high: "ZMP",
#      artcc_id_low: "ZMP",
#      charting_remark: "Remark",
#      pitch_flag: true,
#      catch_flag: false,
#      sua_atcaa_flag: true,
#      min_recep_alt: 5000,
#      compulsory: :low,
#      charts: ["Chart1"],
#      effective_date: ~D[2025-11-27],
#      meta: %{}
#    }
#    # fields are parsed to ints/floats/dates/atoms where applicable
#    # unknown enums pass through as strings; meta is reserved for consumers
```

List available CSV types in a NASR archive:

```elixir
NASR.list_types(file: "path/to/nasr.zip")
```

Schema drift check between cycles (downloads current and prior cycles):

```bash
mix nasr.schema_diff 1
```

### What the streams contain

- `stream_raw/1` yields maps keyed by CSV headers (strings), plus:
  - `"__FILE__"`: the CSV filename (e.g., `"APT_BASE.csv"`)
  - `"__TYPE__"`: the CSV type without extension (e.g., `"APT_BASE"`)
- `stream_entities/1` yields structs (one per entity module) with:
  - Parsed fields (dates, ints/floats, atoms for enums)
  - `meta: %{}` reserved for consumer annotations
  - Only entities with a matching module are emitted; unknown types are skipped

Streams are lazy; collect with `Enum.take/2`, `Enum.to_list/1`, etc.

### Current NASR ZIP resolution

If you don’t pass `:file` or `:url`, `NASR.stream_raw/1` uses `NASR.Utils.get_current_nasr_url/0` to scrape the FAA NASR subscription page and locate the current “Download” link. It then downloads that ZIP to a temp file before streaming the nested `CSV_Data/*.zip` contents. To pin a specific cycle, provide `file: "/path/to/28DaySubscription_Effective_YYYY-MM-DD.zip"` or `url: "https://nfdc.faa.gov/webContent/28DaySub/28DaySubscription_Effective_YYYY-MM-DD.zip"`.

## Entity Modules

Each entity implements `type/0` (CSV type) and `new/1` (raw map -> struct). All structs include `meta: %{}`. Module docs in `lib/nasr/entities/**` have full field detail.

- `NASR.Entities.Airport` — airport base attributes (IDs, city/state/country, status/ownership/use)
  - `Airport.Runway` — runway physical dimensions, surface (primary/secondary), lighting, PCN/weights
  - `Airport.AttendanceSchedule` — attendance/operating schedules
  - `Airport.Remark` — airport remarks text
  - `Airport.RunwayEnd` — end-specific data (threshold, elevation, markings, lighting)
  - `Airport.ArrestingSystems` — arresting system details per runway end
- `NASR.Entities.Fix` — fixes/waypoints (IDs, lat/long, use codes, ARTCC, flags)
  - `Fix.ChartingInformation` — charting info for fixes
  - `Fix.NavaidMakeup` — navaid makeup text for fixes
- `NASR.Entities.Nav` — navaids (VOR/DME/TACAN/NDB) with location, service volumes, ownership
  - `Nav.Remarks` — navaid remarks
  - `Nav.Checkpoint` — VOR receiver checkpoints
- `NASR.Entities.HoldingPattern` — holding pattern base (fix, course, altitudes, speeds)
  - `HoldingPattern.Charting` — charting data for holdings
  - `HoldingPattern.Remarks` — holding remarks
  - `HoldingPattern.SpeedAltitude` — additional speed/altitude constraints
- `NASR.Entities.Airway` — airway base and MEA data
  - `Airway.SegmentAltitude` — segment altitudes/constraints
- `NASR.Entities.MilitaryTrainingRoute` — MTR base routes (IDs, type, floor/ceiling)
  - `MilitaryTrainingRoute.Point` — route points and sequencing
  - `MilitaryTrainingRoute.Width` — route widths
  - `MilitaryTrainingRoute.Terrain` — terrain following operations
  - `MilitaryTrainingRoute.StandardOperatingProcedure` — operating procedures
  - `MilitaryTrainingRoute.Agency` — responsible agency
- `NASR.Entities.PreferredRoute` — preferred/TEC routes (orig/dest, descriptions, times)
  - `PreferredRoute.Segment` — segment descriptions
  - `PreferredRoute.RemoteFormat` — remote-format route string representation
- `NASR.Entities.ClassAirspace` — controlled airspace classes (B/C/D/E) by site ID
- `NASR.Entities.Communication` — communication facilities and frequencies
- `NASR.Entities.FlightServiceStation` — FSS facilities
  - `FlightServiceStation.Remarks` — FSS remarks
- `NASR.Entities.AWOS` — AWOS/ASOS station records
- `NASR.Entities.Radar` — radar facility data
- `NASR.Entities.MaximumAuthorizedAltitude` — MAA base data (airspace caps)
  - `MaximumAuthorizedAltitude.Shape` — polygon coordinates
  - `MaximumAuthorizedAltitude.Control` — controlling agency details
  - `MaximumAuthorizedAltitude.Remarks` — MAA remarks
- `NASR.Entities.ATC` — ATC communications base data
  - `ATC.Service` — service details
  - `ATC.ATIS` — ATIS data
  - `ATC.Remarks` — ATC remarks
- `NASR.Entities.ParachuteJumpingArea` — parachute jumping area data
  - `ParachuteJumpingArea.Contact` — contact/frequency info
- `NASR.Entities.WeatherLocation` — weather reporting locations
  - `WeatherLocation.Service` — associated services
- `NASR.Entities.STAR` — standard terminal arrivals (STAR) definitions
  - `STAR.Route` — STAR route sequences
  - `STAR.Airport` — STAR airport associations
- `NASR.Entities.DepartureProcedure` — departure procedures (DP) definitions
  - `DepartureProcedure.Route` — DP route sequences
  - `DepartureProcedure.Airport` — DP airport associations
- `NASR.Entities.AirRouteBoundary` — ARTCC boundary data
  - `AirRouteBoundary.Segment` — boundary segments
- `NASR.Entities.LocationIdentifier` — location identifier records (LID)
- `NASR.Entities.MilitaryOperations` — military operations areas
- `NASR.Entities.CodedDepartureRoute` — coded departure routes (CDR)
- `NASR.Entities.Frequency` — frequency records

Call `NASR.entity_modules/0` to enumerate the full list at runtime.

## Development

- Run tests: `mix test`
- Formatting: `mix format`
- Lint/QA: `mix validate` (format/credo/dialyzer; may require network/permissions)
- Schema drift: `mix nasr.schema_diff 1`

## Notes

- `stream_raw/1` expects the NASR root ZIP containing `CSV_Data/*.zip` with CSV files.
- Headers are trimmed and sanitized before mapping rows.
- Parsing helpers live in `NASR.Utils` (safe numeric/date conversion, Y/N flags, AIRAC helpers).
