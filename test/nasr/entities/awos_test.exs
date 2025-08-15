defmodule NASR.Entities.AWOSTest do
  use ExUnit.Case
  alias NASR.Entities.AWOS

  describe "new/1" do
    test "creates AWOS struct from CSV data" do
      raw_data = %{
        "EFF_DATE" => "2025/08/07",
        "ASOS_AWOS_ID" => "00U",
        "ASOS_AWOS_TYPE" => "AWOS-3",
        "STATE_CODE" => "MT",
        "CITY" => "HARDIN",
        "COUNTRY_CODE" => "US",
        "COMMISSIONED_DATE" => "",
        "NAVAID_FLAG" => "N",
        "LAT_DEG" => "45",
        "LAT_MIN" => "44",
        "LAT_SEC" => "43.15",
        "LAT_HEMIS" => "N",
        "LAT_DECIMAL" => "45.74531944",
        "LONG_DEG" => "107",
        "LONG_MIN" => "39",
        "LONG_SEC" => "35.13",
        "LONG_HEMIS" => "W",
        "LONG_DECIMAL" => "-107.65975833",
        "ELEV" => "3085",
        "SURVEY_METHOD_CODE" => "",
        "PHONE_NO" => "406-665-4241",
        "SECOND_PHONE_NO" => "",
        "SITE_NO" => "12385.2",
        "SITE_TYPE_CODE" => "A",
        "REMARK" => ""
      }

      awos = AWOS.new(raw_data)

      assert awos.effective_date == ~D[2025-08-07]
      assert awos.asos_awos_id == "00U"
      assert awos.asos_awos_type == "AWOS-3"
      assert awos.state_code == "MT"
      assert awos.city == "HARDIN"
      assert awos.country_code == "US"
      assert awos.commissioned_date == ""
      assert awos.navaid_flag == false
      assert awos.latitude == 45.74531944
      assert awos.longitude == -107.65975833
      assert awos.elevation == 3085.0
      assert awos.survey_method_code == nil
      assert awos.phone_no == "406-665-4241"
      assert awos.second_phone_no == ""
      assert awos.site_no == "12385.2"
      assert awos.site_type_code == :airport
      assert awos.remark == ""
    end

    test "handles survey method codes" do
      raw_data = %{
        "EFF_DATE" => "2025/08/07",
        "ASOS_AWOS_ID" => "TEST",
        "ASOS_AWOS_TYPE" => "AWOS-1",
        "STATE_CODE" => "NY",
        "CITY" => "TEST CITY",
        "COUNTRY_CODE" => "US",
        "COMMISSIONED_DATE" => "",
        "NAVAID_FLAG" => "Y",
        "LAT_DECIMAL" => "42.74262222",
        "LONG_DECIMAL" => "-78.04690555",
        "ELEV" => "1558",
        "SURVEY_METHOD_CODE" => "E",
        "PHONE_NO" => "585-237-0235",
        "SECOND_PHONE_NO" => "",
        "SITE_NO" => "15942.",
        "SITE_TYPE_CODE" => "H",
        "REMARK" => "Test remark"
      }

      awos = AWOS.new(raw_data)

      assert awos.navaid_flag == true
      assert awos.survey_method_code == :estimated
      assert awos.site_type_code == :heliport
      assert awos.remark == "Test remark"
    end

    test "handles surveyed method code" do
      raw_data = %{
        "EFF_DATE" => "2025/08/07",
        "ASOS_AWOS_ID" => "TEST",
        "ASOS_AWOS_TYPE" => "ASOS",
        "STATE_CODE" => "CA",
        "CITY" => "TEST CITY",
        "COUNTRY_CODE" => "US",
        "COMMISSIONED_DATE" => "",
        "NAVAID_FLAG" => "N",
        "LAT_DECIMAL" => "36.0",
        "LONG_DECIMAL" => "-120.0",
        "ELEV" => "500",
        "SURVEY_METHOD_CODE" => "S",
        "PHONE_NO" => "",
        "SECOND_PHONE_NO" => "",
        "SITE_NO" => "",
        "SITE_TYPE_CODE" => "G",
        "REMARK" => ""
      }

      awos = AWOS.new(raw_data)

      assert awos.survey_method_code == :surveyed
      assert awos.site_type_code == :gliderport
    end

    test "handles all site type codes" do
      site_type_codes = [
        {"A", :airport},
        {"B", :balloonport},
        {"C", :seaplane_base},
        {"G", :gliderport},
        {"H", :heliport},
        {"U", :ultralight}
      ]

      for {code, expected_atom} <- site_type_codes do
        raw_data = %{
          "EFF_DATE" => "2025/08/07",
          "ASOS_AWOS_ID" => "TEST",
          "ASOS_AWOS_TYPE" => "AWOS-1",
          "STATE_CODE" => "TX",
          "CITY" => "TEST",
          "COUNTRY_CODE" => "US",
          "COMMISSIONED_DATE" => "",
          "NAVAID_FLAG" => "N",
          "LAT_DECIMAL" => "30.0",
          "LONG_DECIMAL" => "-100.0",
          "ELEV" => "1000",
          "SURVEY_METHOD_CODE" => "",
          "PHONE_NO" => "",
          "SECOND_PHONE_NO" => "",
          "SITE_NO" => "",
          "SITE_TYPE_CODE" => code,
          "REMARK" => ""
        }

        awos = AWOS.new(raw_data)
        assert awos.site_type_code == expected_atom
      end
    end
  end

  describe "type/0" do
    test "returns correct type string" do
      assert AWOS.type() == "AWOS"
    end
  end
end