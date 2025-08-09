defmodule NASR.Entities.ILSGlideSlopeDataTest do
  use ExUnit.Case

  describe "new/1" do
    test "creates struct from real-world ILS3 sample data" do
      sample_data = %{
        type: :ils3,
        record_type_indicator: "ILS3",
        blank: "",
        airport_site_number_identifier_ex_04508_a: "00128.*A",
        ils_runway_end_identifier_ex_18_36l: "05",
        ils_system_type_see_ils1_record_type_for_list: "ILS",
        indicating_source_of_latitude_longitude: "K",
        indicating_source_of_distance: "",
        status_of_glide_slope_operational_ifr: "OPERATIONAL IFR",
        date_of_glide_slope_operational_status: "07/25/1991",
        latitude_of_glide_slope_transmitter_antenna: "120901.832N",
        longitude_of_glide_slope_transmitter_antenna: "309115.942W",
        distance_of_glide_slope_transmitter_antenna: "",
        of_glide_slope_transmitter_antenna: "",
        elevation_of_glide_slope_transmitter_antenna: "590.8",
        glide_slope_class_type: "GLIDE SLOPE",
        glide_slope_angle_in_degrees: "3.00",
        glide_slope_transmission_frequency: "332.90",
        elevation_of_runway_at_point_adjacent_to_the: ""
      }

      result = NASR.Entities.ILSGlideSlopeData.new(sample_data)

      assert result.record_type_indicator == "ILS3"
      assert result.airport_site_number == "00128.*A"
      assert result.ils_runway_end_identifier == "05"
      assert result.ils_system_type == :ils
      assert result.operational_status == :operational_ifr
      assert result.operational_status_date == ~D[1991-07-25]
      assert result.latitude_seconds == "120901.832N"
      assert result.longitude_seconds == "309115.942W"
      assert result.position_source == :ngs
      assert result.site_elevation == 590.8
      assert result.glide_slope_class_type == :glide_slope
      assert result.glide_slope_angle == 3.00
      assert result.transmission_frequency == 332.90
    end

    test "converts glide slope class types to atoms" do
      test_cases = [
        {"GLIDE SLOPE", :glide_slope},
        {"GLIDE SLOPE/DME", :glide_slope_dme}
      ]

      for {input, expected} <- test_cases do
        sample_data = %{
          type: :ils3,
          record_type_indicator: "ILS3",
          blank: "",
          airport_site_number_identifier_ex_04508_a: "00128.*A",
          ils_runway_end_identifier_ex_18_36l: "05",
          ils_system_type_see_ils1_record_type_for_list: "ILS",
          indicating_source_of_latitude_longitude: "K",
          indicating_source_of_distance: "",
          status_of_glide_slope_operational_ifr: "OPERATIONAL IFR",
          date_of_glide_slope_operational_status: "07/25/1991",
          latitude_of_glide_slope_transmitter_antenna: "120901.832N",
          longitude_of_glide_slope_transmitter_antenna: "309115.942W",
          distance_of_glide_slope_transmitter_antenna: "",
          of_glide_slope_transmitter_antenna: "",
          elevation_of_glide_slope_transmitter_antenna: "590.8",
          glide_slope_class_type: input,
          glide_slope_angle_in_degrees: "3.00",
          glide_slope_transmission_frequency: "332.90",
          elevation_of_runway_at_point_adjacent_to_the: ""
        }

        result = NASR.Entities.ILSGlideSlopeData.new(sample_data)
        assert result.glide_slope_class_type == expected
      end
    end
  end
end