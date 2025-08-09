defmodule NASR.Entities.ILSMarkerBeaconDataTest do
  use ExUnit.Case

  describe "new/1" do
    test "creates struct from real-world ILS5 sample data" do
      sample_data = %{
        type: :ils5,
        record_type_indicator: "ILS5",
        blank: "",
        airport_site_number_identifier_ex_04508_a: "00128.*A",
        ils_runway_end_identifier_ex_18_36l: "05",
        ils_system_type_see_ils1_record_type_for_list: "ILS",
        indicating_source_of_latitude_longitude: "K",
        indicating_source_of_distance: "",
        marker_type_im___inner_marker_mm___middle: "MM",
        status_of_marker_beacon_operational: "DECOMMISSIONED",
        date_of_marker_beacon_operational_status: "07/26/2011",
        latitude_of_marker_beacon_formatted: "33-34-36.798N",
        latitude_of_marker_beacon_all_seconds: "120876.798N",
        longitude_of_marker_beacon_formatted: "085-52-23.984W",
        longitude_of_marker_beacon_all_seconds: "309143.984W",
        distance_of_marker_beacon: "",
        of_marker_beacon: "",
        elevation_of_marker_beacon: "590",
        facility_type_of_marker_locator: "MARKER",
        location_identifier_of_beacon_at_marker: "NB",
        name_of_the_marker_locator_beacon: "",
        frequency_of_locator_beacon_at_middle_marker: "",
        identifier_navaid_type_of_navigation: "",
        powered_ndb_status_of_marker_beacon: "",
        provided_by_marker: ""
      }

      result = NASR.Entities.ILSMarkerBeaconData.new(sample_data)

      assert result.record_type_indicator == "ILS5"
      assert result.airport_site_number == "00128.*A"
      assert result.ils_runway_end_identifier == "05"
      assert result.ils_system_type == :ils
      assert result.marker_type == :middle_marker
      assert result.operational_status == :decommissioned
      assert result.operational_status_date == ~D[2011-07-26]
      assert result.latitude_formatted == "33-34-36.798N"
      assert result.latitude_seconds == "120876.798N"
      assert result.longitude_formatted == "085-52-23.984W"
      assert result.longitude_seconds == "309143.984W"
      assert result.position_source == :ngs
      assert result.site_elevation == 590.0
      assert result.facility_type == :marker
      assert result.location_identifier == "NB"
    end

    test "converts marker types to atoms" do
      test_cases = [
        {"IM", :inner_marker},
        {"MM", :middle_marker},
        {"OM", :outer_marker}
      ]

      for {input, expected} <- test_cases do
        sample_data = %{
          type: :ils5,
          record_type_indicator: "ILS5",
          blank: "",
          airport_site_number_identifier_ex_04508_a: "00128.*A",
          ils_runway_end_identifier_ex_18_36l: "05",
          ils_system_type_see_ils1_record_type_for_list: "ILS",
          indicating_source_of_latitude_longitude: "K",
          indicating_source_of_distance: "",
          marker_type_im___inner_marker_mm___middle: input,
          status_of_marker_beacon_operational: "OPERATIONAL IFR",
          date_of_marker_beacon_operational_status: "07/26/2011",
          latitude_of_marker_beacon_formatted: "33-34-36.798N",
          latitude_of_marker_beacon_all_seconds: "120876.798N",
          longitude_of_marker_beacon_formatted: "085-52-23.984W",
          longitude_of_marker_beacon_all_seconds: "309143.984W",
          distance_of_marker_beacon: "",
          of_marker_beacon: "",
          elevation_of_marker_beacon: "590",
          facility_type_of_marker_locator: "MARKER",
          location_identifier_of_beacon_at_marker: "NB",
          name_of_the_marker_locator_beacon: "",
          frequency_of_locator_beacon_at_middle_marker: "",
          identifier_navaid_type_of_navigation: "",
          powered_ndb_status_of_marker_beacon: "",
          provided_by_marker: ""
        }

        result = NASR.Entities.ILSMarkerBeaconData.new(sample_data)
        assert result.marker_type == expected
      end
    end

    test "converts facility types to atoms" do
      test_cases = [
        {"MARKER", :marker},
        {"COMLO", :comlo},
        {"NDB", :ndb},
        {"MARKER/COMLO", :marker_comlo},
        {"MARKER/NDB", :marker_ndb}
      ]

      for {input, expected} <- test_cases do
        sample_data = %{
          type: :ils5,
          record_type_indicator: "ILS5",
          blank: "",
          airport_site_number_identifier_ex_04508_a: "00128.*A",
          ils_runway_end_identifier_ex_18_36l: "05",
          ils_system_type_see_ils1_record_type_for_list: "ILS",
          indicating_source_of_latitude_longitude: "K",
          indicating_source_of_distance: "",
          marker_type_im___inner_marker_mm___middle: "MM",
          status_of_marker_beacon_operational: "OPERATIONAL IFR",
          date_of_marker_beacon_operational_status: "07/26/2011",
          latitude_of_marker_beacon_formatted: "33-34-36.798N",
          latitude_of_marker_beacon_all_seconds: "120876.798N",
          longitude_of_marker_beacon_formatted: "085-52-23.984W",
          longitude_of_marker_beacon_all_seconds: "309143.984W",
          distance_of_marker_beacon: "",
          of_marker_beacon: "",
          elevation_of_marker_beacon: "590",
          facility_type_of_marker_locator: input,
          location_identifier_of_beacon_at_marker: "NB",
          name_of_the_marker_locator_beacon: "",
          frequency_of_locator_beacon_at_middle_marker: "",
          identifier_navaid_type_of_navigation: "",
          powered_ndb_status_of_marker_beacon: "",
          provided_by_marker: ""
        }

        result = NASR.Entities.ILSMarkerBeaconData.new(sample_data)
        assert result.facility_type == expected
      end
    end
  end
end