# AGENTS.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

NASR is an Elixir library for parsing and analyzing FAA National Airspace System Resources (NASR) and digital Terminal Procedures Publication (dTPP) data files. The library streams data from FAA zip files and converts them into structured Elixir entities.

The primary functionality of this module is the parsing and decode of FAA NASR data files into typed Elixir structs. The library supports streaming large data files efficiently, handling nested zip files, and converting raw CSV data into well-defined entities such as airports, fixes, navaids, and procedures.

It's expected that users of this library will load a subset or all of the FAA NASR data into their applications once.

## Development Commands

### Testing

There are two main types of tests: unit tests for individual entity parsing and integration tests for end-to-end streaming.

- `mix test` - Run all tests
- `mix test test/nasr/entities/airport_test.exs` - Run a specific test file

### Quality Assurance

- `mix validate` - Run the complete validation pipeline (clean, compile with warnings as errors, format check, credo, dialyzer)
- `mix format` - Format code
- `mix format --check-formatted` - Check if code is formatted
- `mix credo` - Run static code analysis
- `mix dialyzer` - Run type checking

## Architecture

### Core Streaming System

The library is built around a streaming architecture that processes large FAA data files efficiently:

- **NASR module**: Main entry point providing `stream_raw/1` and `stream_entities/1` functions
- **Dual data source support**: Can read from local files or download from URLs
- **Nested zip handling**: Automatically extracts CSV data from nested zip files within NASR archives
- **Lazy streaming**: Uses Elixir streams to process data without loading entire files into memory

### Entity System

Located in `lib/nasr/entities/`, this follows a consistent pattern:

- **Base entities**: Main entity types (Airport, Fix) go directly in `entities/` folder
- **Sub-entities**: Related entities go in submodules (e.g., `Airport.Runway`, `Airport.Contact`)
- **Entity modules must implement**:
  - `new/1` - Takes raw CSV map, returns entity struct
  - `type/0` - Returns CSV file type (e.g., "APT_BASE")
- **Naming convention**: `_BASE` CSV types become base modules (APT_BASE → Airport), others become submodules (APT_RWY → Airport.Runway)
- **Heirarchical structure**: Entities can nest sub-entities as needed (i.e., Airport has Runways, Contacts, etc.). Each of these entities can stand on its own and be streamed independently. Calling `NASR.stream_entities/1` will yield all supported entities without this nesting. It's necessary to call a specific function like NASR.list_airports/1 to get the nested structure. Since the entities are streamed in an unknown order, the nesting must result in a single list instead of a stream.

### Data Processing Pipeline

1. **Raw streaming**: `stream_raw/1` yields maps with string keys from CSV
2. **Entity conversion**: `stream_entities/1` converts raw maps to typed structs
3. **Type-safe parsing**: Each entity module handles its own field parsing and type conversion
4. **Utility functions**: `NASR.Utils` provides common parsing helpers (`safe_str_to_int/1`, `safe_str_to_float/1`, `convert_yn/1`, `parse_date/1`)

### Entity Documentation Requirements

All entity modules must include:

- Comprehensive `@moduledoc` with field descriptions using atom values (not CSV strings)
- Complete `@type t()` specification with proper types for all fields
- Enumerated values shown as atoms in field descriptions
- No "Data Source" section in moduledoc (covered in README)
- Consistent naming of fields and reuse of parsing utilities

### Test Structure

- **Unit tests**: Test individual entity parsing in `test/nasr/entities/`
- **Integration tests**: Test end-to-end streaming in `entities_integration_test.exs`
- **Test data**: Uses sample CSV data to verify entity conversion functions

### Key Dependencies

- **unzip**: ZIP file handling for NASR archives
- **nimble_csv**: Fast CSV parsing for data streams
- **timex**: Date/time parsing utilities
- **req**: HTTP client for downloading NASR files
- **briefly**: Temporary file management

### Data Flow

```
FAA NASR ZIP → CSV extraction → Raw maps → Entity structs → Application use
```

The library handles the complexity of FAA data formats while providing a clean, typed interface for aviation applications.
