defmodule NASR.Entities.MilitaryTrainingRoute.AgencyTest do
  use ExUnit.Case
  alias NASR.Entities.MilitaryTrainingRoute.Agency

  describe "new/1" do
    test "creates Agency struct from MTR_AGY sample data" do
      sample_data = create_sample_data(%{})

      result = Agency.new(sample_data)

      assert result.effective_date == ~D[2025-08-07]
      assert result.route_type_code == :instrument_route
      assert result.route_id == "002"
      assert result.artcc == "ZTL"
      assert result.agency_type == :operating
      assert result.agency_name == "COMSTRKFIGHTWINGLANT"
      assert result.station == "OCEANA NAS"
      assert result.address == ""
      assert result.city == "VIRGINIA BEACH"
      assert result.state_code == "VA"
      assert result.zip_code == "23460"
      assert result.commercial_number == "757-433-9141"
      assert result.dsn_number == "433-9141"
      assert result.hours == ""
    end

    test "handles different route type codes" do
      route_types = [
        {"IR", :instrument_route},
        {"VR", :visual_route}
      ]

      for {input, expected} <- route_types do
        sample_data = create_sample_data(%{"ROUTE_TYPE_CODE" => input})
        result = Agency.new(sample_data)
        assert result.route_type_code == expected
      end
    end

    test "handles different agency types" do
      agency_types = [
        {"O", :operating},
        {"S1", :scheduling1},
        {"S2", :scheduling2}
      ]

      for {input, expected} <- agency_types do
        sample_data = create_sample_data(%{"AGENCY_TYPE" => input})
        result = Agency.new(sample_data)
        assert result.agency_type == expected
      end
    end

    test "handles scheduling agency S1" do
      s1_data = create_sample_data(%{
        "AGENCY_TYPE" => "S1",
        "AGENCY_NAME" => "FACSFAC  VACAPES",
        "STATION" => "OCEANA NAS",
        "COMMERCIAL_NO" => "757-433-1228",
        "DSN_NO" => "433-1228",
        "HOURS" => "SEE GENERAL REMARKS"
      })

      result = Agency.new(s1_data)
      assert result.agency_type == :scheduling1
      assert result.agency_name == "FACSFAC  VACAPES"
      assert result.station == "OCEANA NAS"
      assert result.commercial_number == "757-433-1228"
      assert result.dsn_number == "433-1228"
      assert result.hours == "SEE GENERAL REMARKS"
    end

    test "handles Air Force base operations" do
      af_data = create_sample_data(%{
        "ROUTE_ID" => "012",
        "ARTCC" => "ZDC",
        "AGENCY_TYPE" => "O",
        "AGENCY_NAME" => "4 OSS / OSOR",
        "STATION" => "SEYMOUR JOHNSON AFB",
        "CITY" => "",
        "STATE_CODE" => "NC",
        "ZIP_CODE" => "27531-5004",
        "COMMERCIAL_NO" => "919-722-2672",
        "DSN_NO" => "722-2672"
      })

      result = Agency.new(af_data)
      assert result.route_id == "012"
      assert result.artcc == "ZDC"
      assert result.agency_type == :operating
      assert result.agency_name == "4 OSS / OSOR"
      assert result.station == "SEYMOUR JOHNSON AFB"
      assert result.city == ""
      assert result.state_code == "NC"
      assert result.zip_code == "27531-5004"
      assert result.commercial_number == "919-722-2672"
      assert result.dsn_number == "722-2672"
    end

    test "handles Navy operations with hours" do
      navy_data = create_sample_data(%{
        "ROUTE_ID" => "016",
        "ARTCC" => "ZJX",
        "AGENCY_TYPE" => "S1",
        "AGENCY_NAME" => "23 OSS/OSO",
        "STATION" => "MOODY AFB",
        "STATE_CODE" => "GA",
        "ZIP_CODE" => "31699-1899",
        "COMMERCIAL_NO" => "229-257-7831",
        "DSN_NO" => "460-7831",
        "HOURS" => "MON-FRI 0830-1700L, EXCEPT HOL"
      })

      result = Agency.new(navy_data)
      assert result.route_id == "016"
      assert result.artcc == "ZJX"
      assert result.agency_type == :scheduling1
      assert result.agency_name == "23 OSS/OSO"
      assert result.station == "MOODY AFB"
      assert result.state_code == "GA"
      assert result.zip_code == "31699-1899"
      assert result.commercial_number == "229-257-7831"
      assert result.dsn_number == "460-7831"
      assert result.hours == "MON-FRI 0830-1700L, EXCEPT HOL"
    end

    test "handles FACSFAC operations" do
      facsfac_data = create_sample_data(%{
        "ROUTE_ID" => "018",
        "ARTCC" => "ZJX",
        "AGENCY_TYPE" => "O",
        "AGENCY_NAME" => "FACSFAC  JAX",
        "STATION" => "NAS JACKSONVILLE",
        "STATE_CODE" => "FL",
        "ZIP_CODE" => "32212",
        "COMMERCIAL_NO" => "904-542-2004/2005",
        "DSN_NO" => "942-2004/2005"
      })

      result = Agency.new(facsfac_data)
      assert result.route_id == "018"
      assert result.artcc == "ZJX"
      assert result.agency_type == :operating
      assert result.agency_name == "FACSFAC  JAX"
      assert result.station == "NAS JACKSONVILLE"
      assert result.state_code == "FL"
      assert result.zip_code == "32212"
      assert result.commercial_number == "904-542-2004/2005"
      assert result.dsn_number == "942-2004/2005"
    end

    test "handles training wing operations" do
      training_data = create_sample_data(%{
        "ROUTE_ID" => "021",
        "ARTCC" => "ZJX ZTL",
        "AGENCY_TYPE" => "O",
        "AGENCY_NAME" => "TRAINING  AIR WING SIX",
        "STATION" => "",
        "CITY" => "PENSACOLA",
        "STATE_CODE" => "FL",
        "ZIP_CODE" => "32508-5509",
        "COMMERCIAL_NO" => "850-452-2875",
        "DSN_NO" => "459-2875"
      })

      result = Agency.new(training_data)
      assert result.route_id == "021"
      assert result.artcc == "ZJX ZTL"
      assert result.agency_type == :operating
      assert result.agency_name == "TRAINING  AIR WING SIX"
      assert result.station == ""
      assert result.city == "PENSACOLA"
      assert result.state_code == "FL"
      assert result.zip_code == "32508-5509"
      assert result.commercial_number == "850-452-2875"
      assert result.dsn_number == "459-2875"
    end

    test "handles Marine Corps operations" do
      marines_data = create_sample_data(%{
        "ROUTE_ID" => "023",
        "ARTCC" => "ZJX",
        "AGENCY_TYPE" => "O",
        "AGENCY_NAME" => "CO, MCAS CHERRY POINT, NC",
        "STATION" => "",
        "CITY" => "CHERRY POINT",
        "STATE_CODE" => "NC",
        "ZIP_CODE" => "28533",
        "COMMERCIAL_NO" => "",
        "DSN_NO" => "582-4040/41"
      })

      result = Agency.new(marines_data)
      assert result.route_id == "023"
      assert result.artcc == "ZJX"
      assert result.agency_type == :operating
      assert result.agency_name == "CO, MCAS CHERRY POINT, NC"
      assert result.station == ""
      assert result.city == "CHERRY POINT"
      assert result.state_code == "NC"
      assert result.zip_code == "28533"
      assert result.commercial_number == ""
      assert result.dsn_number == "582-4040/41"
    end

    test "handles multiple phone numbers" do
      multi_phone_data = create_sample_data(%{
        "COMMERCIAL_NO" => "919-722-2129/2124",
        "DSN_NO" => "722-2129/2124"
      })

      result = Agency.new(multi_phone_data)
      assert result.commercial_number == "919-722-2129/2124"
      assert result.dsn_number == "722-2129/2124"
    end

    test "handles Visual Route agencies" do
      vr_data = create_sample_data(%{
        "ROUTE_TYPE_CODE" => "VR",
        "ROUTE_ID" => "1234",
        "AGENCY_TYPE" => "S1",
        "AGENCY_NAME" => "VR SCHEDULING AGENCY"
      })

      result = Agency.new(vr_data)
      assert result.route_type_code == :visual_route
      assert result.route_id == "1234"
      assert result.agency_type == :scheduling1
      assert result.agency_name == "VR SCHEDULING AGENCY"
    end

    test "handles empty/nil values correctly" do
      empty_data = create_sample_data(%{
        "ADDRESS" => "",
        "CITY" => "",
        "STATION" => "",
        "COMMERCIAL_NO" => "",
        "HOURS" => "",
        "AGENCY_TYPE" => "",
        "ROUTE_TYPE_CODE" => ""
      })

      result = Agency.new(empty_data)

      assert result.address == ""
      assert result.city == ""
      assert result.station == ""
      assert result.commercial_number == ""
      assert result.hours == ""
      assert result.agency_type == nil
      assert result.route_type_code == nil
    end

    test "handles unknown codes as strings" do
      unknown_data = create_sample_data(%{
        "ROUTE_TYPE_CODE" => "XR",
        "AGENCY_TYPE" => "S3"
      })

      result = Agency.new(unknown_data)
      assert result.route_type_code == "XR"
      assert result.agency_type == "S3"
    end
  end

  describe "type/0" do
    test "returns correct type string" do
      assert Agency.type() == "MTR_AGY"
    end
  end

  # Helper function to create sample data with default values
  defp create_sample_data(overrides) do
    Map.merge(%{
      "EFF_DATE" => "2025/08/07",
      "ROUTE_TYPE_CODE" => "IR",
      "ROUTE_ID" => "002",
      "ARTCC" => "ZTL",
      "AGENCY_TYPE" => "O",
      "AGENCY_NAME" => "COMSTRKFIGHTWINGLANT",
      "STATION" => "OCEANA NAS",
      "ADDRESS" => "",
      "CITY" => "VIRGINIA BEACH",
      "STATE_CODE" => "VA",
      "ZIP_CODE" => "23460",
      "COMMERCIAL_NO" => "757-433-9141",
      "DSN_NO" => "433-9141",
      "HOURS" => ""
    }, overrides)
  end
end