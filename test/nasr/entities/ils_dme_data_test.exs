defmodule NASR.Entities.ILSDMEDataTest do
  use ExUnit.Case

  describe "new/1" do
    test "creates struct from real-world ILS4 sample data" do
      sample_data = %{
        type: :ils4,
        record_type_indicator: "ILS4",
        blank: "",
        airport_site_number_identifier_ex_04508_a: "00146.*A",
        ils_runway_end_identifier_ex_18_36l: "36",
        ils_system_type_see_ils1_record_type_for_list: "ILS/DME",
        indicating_source_of_latitude_longitude: "F",
        indicating_source_of_distance: "",
        status_of_dme_operational_ifr: "OPERATIONAL IFR",
        date_of_dme_operational_status: "07/28/2022",
        latitude_of_dme_transponder_antenna: "117442.810N",
        longitude_of_dme_transponder_antenna: "307568.880W",
        distance_of_dme_transmitter_antenna: "",
        of_dme_transponder_antenna: "",
        elevation_of_dme_transponder_antenna: "779",
        channel_on_which_distance_data_is_transmitted: "38X",
        distance_of_dme: ""
      }

      result = NASR.Entities.ILSDMEData.new(sample_data)

      assert result.record_type_indicator == "ILS4"
      assert result.airport_site_number == "00146.*A"
      assert result.ils_runway_end_identifier == "36"
      assert result.ils_system_type == :ils_dme
      assert result.operational_status == :operational_ifr
      assert result.operational_status_date == ~D[2022-07-28]
      assert result.latitude_seconds == "117442.810N"
      assert result.longitude_seconds == "307568.880W"
      assert result.position_source == :faa
      assert result.site_elevation == 779.0
      assert result.dme_channel == "38X"
    end

    test "handles empty values gracefully" do
      sample_data = %{
        type: :ils4,
        record_type_indicator: "ILS4",
        blank: "",
        airport_site_number_identifier_ex_04508_a: "00146.*A",
        ils_runway_end_identifier_ex_18_36l: "36",
        ils_system_type_see_ils1_record_type_for_list: "ILS/DME",
        indicating_source_of_latitude_longitude: "F",
        indicating_source_of_distance: "",
        status_of_dme_operational_ifr: "OPERATIONAL IFR",
        date_of_dme_operational_status: "",
        latitude_of_dme_transponder_antenna: "",
        longitude_of_dme_transponder_antenna: "",
        distance_of_dme_transmitter_antenna: "",
        of_dme_transponder_antenna: "",
        elevation_of_dme_transponder_antenna: "",
        channel_on_which_distance_data_is_transmitted: "",
        distance_of_dme: ""
      }

      result = NASR.Entities.ILSDMEData.new(sample_data)

      assert result.operational_status_date == nil
      assert result.site_elevation == nil
      assert result.distance_from_approach_end == nil
    end
  end
end