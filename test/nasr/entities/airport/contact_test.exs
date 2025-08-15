defmodule NASR.Entities.Airport.ContactTest do
  use ExUnit.Case

  describe "new/1" do
    test "creates struct from airport contact data" do
      sample_data = %{
        "SITE_NO" => "04513.0*A",
        "SITE_TYPE_CODE" => "AIRPORT",
        "ARPT_ID" => "LAX",
        "CITY" => "LOS ANGELES",
        "STATE_CODE" => "CA",
        "COUNTRY_CODE" => "US",
        "TITLE" => "MANAGER",
        "NAME" => "KEITH WILSCHETZ",
        "ADDRESS1" => "1 WORLD WAY",
        "ADDRESS2" => "SUITE 218",
        "TITLE_CITY" => "LOS ANGELES",
        "STATE" => "CA",
        "ZIP_CODE" => "90045",
        "ZIP_PLUS_FOUR" => "1234",
        "PHONE_NO" => "310-646-5252",
        "EFF_DATE" => "2025/08/07"
      }

      result = NASR.Entities.Airport.Contact.new(sample_data)

      assert result.site_no == "04513.0*A"
      assert result.arpt_id == "LAX"
      assert result.city == "LOS ANGELES"
      assert result.state_code == "CA"
      assert result.country_code == "US"
      assert result.title == "MANAGER"
      assert result.name == "KEITH WILSCHETZ"
      assert result.address_line_1 == "1 WORLD WAY"
      assert result.address_line_2 == "SUITE 218"
      assert result.contact_city == "LOS ANGELES"
      assert result.contact_state == "CA"
      assert result.zip_code == "90045"
      assert result.zip_plus_four == "1234"
      assert result.phone_number == "310-646-5252"
      assert result.effective_date == ~D[2025-08-07]
    end

    test "handles various contact titles" do
      test_cases = [
        "MANAGER",
        "OWNER",
        "ASST-MGR",
        "PRESIDENT",
        "DIRECTOR",
        "OPERATIONS"
      ]

      for title <- test_cases do
        sample_data = create_sample_data(%{"TITLE" => title})
        result = NASR.Entities.Airport.Contact.new(sample_data)
        assert result.title == title
      end
    end

    test "handles empty address fields" do
      sample_data = create_sample_data(%{
        "ADDRESS1" => "123 MAIN ST",
        "ADDRESS2" => "",
        "ZIP_PLUS_FOUR" => ""
      })
      
      result = NASR.Entities.Airport.Contact.new(sample_data)
      
      assert result.address_line_1 == "123 MAIN ST"
      assert result.address_line_2 == ""
      assert result.zip_plus_four == ""
    end

    test "handles complete address information" do
      sample_data = create_sample_data(%{
        "NAME" => "JOHN DOE",
        "ADDRESS1" => "123 AIRPORT BLVD",
        "ADDRESS2" => "BUILDING A, SUITE 100",
        "TITLE_CITY" => "AVIATION CITY",
        "STATE" => "FL",
        "ZIP_CODE" => "33122",
        "ZIP_PLUS_FOUR" => "5678",
        "PHONE_NO" => "305-555-0123"
      })
      
      result = NASR.Entities.Airport.Contact.new(sample_data)
      
      assert result.name == "JOHN DOE"
      assert result.address_line_1 == "123 AIRPORT BLVD"
      assert result.address_line_2 == "BUILDING A, SUITE 100"
      assert result.contact_city == "AVIATION CITY"
      assert result.contact_state == "FL"
      assert result.zip_code == "33122"
      assert result.zip_plus_four == "5678"
      assert result.phone_number == "305-555-0123"
    end

    test "handles phone number formats" do
      test_cases = [
        "310-646-5252",
        "(310) 646-5252",
        "3106465252",
        "310.646.5252"
      ]

      for phone <- test_cases do
        sample_data = create_sample_data(%{"PHONE_NO" => phone})
        result = NASR.Entities.Airport.Contact.new(sample_data)
        assert result.phone_number == phone
      end
    end

    test "handles multiple contacts for same airport" do
      # Manager
      manager_data = create_sample_data(%{
        "TITLE" => "MANAGER",
        "NAME" => "JANE SMITH"
      })
      manager_result = NASR.Entities.Airport.Contact.new(manager_data)
      
      # Owner
      owner_data = create_sample_data(%{
        "TITLE" => "OWNER",
        "NAME" => "AIRPORT AUTHORITY"
      })
      owner_result = NASR.Entities.Airport.Contact.new(owner_data)
      
      assert manager_result.title == "MANAGER"
      assert manager_result.name == "JANE SMITH"
      assert owner_result.title == "OWNER"
      assert owner_result.name == "AIRPORT AUTHORITY"
      assert manager_result.arpt_id == owner_result.arpt_id
    end

    test "parses dates correctly" do
      sample_data = create_sample_data(%{"EFF_DATE" => "2023/12/15"})
      result = NASR.Entities.Airport.Contact.new(sample_data)
      assert result.effective_date == ~D[2023-12-15]
    end
  end

  test "type/0 returns correct CSV filename" do
    assert NASR.Entities.Airport.Contact.type() == "APT_CON"
  end

  # Helper function to create sample data with default values
  defp create_sample_data(overrides) do
    Map.merge(%{
      "SITE_NO" => "12345.*A",
      "SITE_TYPE_CODE" => "AIRPORT",
      "ARPT_ID" => "TEST",
      "CITY" => "TEST CITY",
      "STATE_CODE" => "TX",
      "COUNTRY_CODE" => "US",
      "TITLE" => "MANAGER",
      "NAME" => "TEST MANAGER",
      "ADDRESS1" => "123 AIRPORT RD",
      "ADDRESS2" => "",
      "TITLE_CITY" => "TEST CITY",
      "STATE" => "TX",
      "ZIP_CODE" => "12345",
      "ZIP_PLUS_FOUR" => "",
      "PHONE_NO" => "555-123-4567",
      "EFF_DATE" => "2025/08/07"
    }, overrides)
  end
end