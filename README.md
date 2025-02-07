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
