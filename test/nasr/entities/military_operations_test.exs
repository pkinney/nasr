defmodule NASR.Entities.MilitaryOperationsTest do
  use ExUnit.Case
  alias NASR.Entities.MilitaryOperations

  describe "new/1" do
    test "creates MilitaryOperations struct from MIL_OPS sample data" do
      sample_data = create_sample_data(%{})

      result = MilitaryOperations.new(sample_data)

      assert result.effective_date == ~D[2025-08-07]
      assert result.site_number == "00124."
      assert result.site_type_code == :airport
      assert result.state_code == "AL"
      assert result.airport_id == "79J"
      assert result.city == "ANDALUSIA"
      assert result.country_code == "US"
      assert result.military_operations_code == :restricted
      assert result.military_operations_call == ""
      assert result.military_operations_hours == ""
      assert result.amcp_hours == ""
      assert result.pmsv_hours == ""
      assert result.remark == ""
    end

    test "handles different site type codes" do
      site_types = [
        {"A", :airport},
        {"H", :heliport},
        {"S", :seaplane_base},
        {"G", :gliderport},
        {"B", :balloonport},
        {"U", :ultralight}
      ]

      for {input, expected} <- site_types do
        sample_data = create_sample_data(%{"SITE_TYPE_CODE" => input})
        result = MilitaryOperations.new(sample_data)
        assert result.site_type_code == expected
      end
    end

    test "handles different military operations codes" do
      mil_ops_codes = [
        {"A", :active},
        {"R", :restricted},
        {"N", :none}
      ]

      for {input, expected} <- mil_ops_codes do
        sample_data = create_sample_data(%{"MIL_OPS_OPER_CODE" => input})
        result = MilitaryOperations.new(sample_data)
        assert result.military_operations_code == expected
      end
    end

    test "handles active military operations with call sign and hours" do
      active_data = create_sample_data(%{
        "MIL_OPS_OPER_CODE" => "A",
        "MIL_OPS_CALL" => "DIXIE",
        "MIL_OPS_HRS" => "0700-1730 TUE-SUN",
        "ARPT_ID" => "BHM",
        "CITY" => "BIRMINGHAM"
      })

      result = MilitaryOperations.new(active_data)
      assert result.military_operations_code == :active
      assert result.military_operations_call == "DIXIE"
      assert result.military_operations_hours == "0700-1730 TUE-SUN"
      assert result.airport_id == "BHM"
      assert result.city == "BIRMINGHAM"
    end

    test "handles 24-hour operations" do
      continuous_data = create_sample_data(%{
        "MIL_OPS_OPER_CODE" => "R",
        "MIL_OPS_CALL" => "CAIRNS OPNS",
        "MIL_OPS_HRS" => "24",
        "ARPT_ID" => "OZR",
        "CITY" => "FORT NOVOSEL (OZARK)"
      })

      result = MilitaryOperations.new(continuous_data)
      assert result.military_operations_code == :restricted
      assert result.military_operations_call == "CAIRNS OPNS"
      assert result.military_operations_hours == "24"
      assert result.airport_id == "OZR"
      assert result.city == "FORT NOVOSEL (OZARK)"
    end

    test "handles AMCP and PMSV hours" do
      service_data = create_sample_data(%{
        "MIL_OPS_OPER_CODE" => "N",
        "MIL_OPS_HRS" => "1430-0600Z DLY, CLSD HOL, OT BY NOTAM.",
        "AMCP_HRS" => "0600-2300",
        "PMSV_HRS" => "PART-TIME",
        "ARPT_ID" => "NYL",
        "CITY" => "YUMA"
      })

      result = MilitaryOperations.new(service_data)
      assert result.military_operations_code == :none
      assert result.military_operations_hours == "1430-0600Z DLY, CLSD HOL, OT BY NOTAM."
      assert result.amcp_hours == "0600-2300"
      assert result.pmsv_hours == "PART-TIME"
      assert result.airport_id == "NYL"
      assert result.city == "YUMA"
    end

    test "handles heliport operations" do
      heliport_data = create_sample_data(%{
        "SITE_TYPE_CODE" => "H",
        "MIL_OPS_OPER_CODE" => "R",
        "MIL_OPS_CALL" => "ROBERTS OPNS",
        "MIL_OPS_HRS" => "0800-1700 EXC HOL",
        "ARPT_ID" => "SYL",
        "CITY" => "CAMP ROBERTS/SAN MIGUEL",
        "STATE_CODE" => "CA"
      })

      result = MilitaryOperations.new(heliport_data)
      assert result.site_type_code == :heliport
      assert result.military_operations_code == :restricted
      assert result.military_operations_call == "ROBERTS OPNS"
      assert result.military_operations_hours == "0800-1700 EXC HOL"
      assert result.airport_id == "SYL"
      assert result.city == "CAMP ROBERTS/SAN MIGUEL"
      assert result.state_code == "CA"
    end

    test "handles complex remarks" do
      remark_data = create_sample_data(%{
        "REMARK" => "(PMSV_HRS) FULL SVC AVBL 1400-0400Z++ WKD; 1600-0000Z++ WKEND; CLSD FEDERAL HOL. AERODROME TAF COMPLETED BY 26 OWS; FOR UPDTD FCST CTC MXF WX DSN 493-2071, C334-953-2071. ASOS IN USE, AUGMENTED WHEN NECESSARY DUR AFLD OPR HR."
      })

      result = MilitaryOperations.new(remark_data)
      assert result.remark == "(PMSV_HRS) FULL SVC AVBL 1400-0400Z++ WKD; 1600-0000Z++ WKEND; CLSD FEDERAL HOL. AERODROME TAF COMPLETED BY 26 OWS; FOR UPDTD FCST CTC MXF WX DSN 493-2071, C334-953-2071. ASOS IN USE, AUGMENTED WHEN NECESSARY DUR AFLD OPR HR."
    end

    test "handles empty/nil values correctly" do
      empty_data = create_sample_data(%{
        "MIL_OPS_CALL" => "",
        "MIL_OPS_HRS" => "",
        "AMCP_HRS" => "",
        "PMSV_HRS" => "",
        "REMARK" => "",
        "MIL_OPS_OPER_CODE" => ""
      })

      result = MilitaryOperations.new(empty_data)

      assert result.military_operations_call == ""
      assert result.military_operations_hours == ""
      assert result.amcp_hours == ""
      assert result.pmsv_hours == ""
      assert result.remark == ""
      assert result.military_operations_code == nil
    end

    test "handles unknown codes as strings" do
      unknown_data = create_sample_data(%{
        "SITE_TYPE_CODE" => "X",
        "MIL_OPS_OPER_CODE" => "Z"
      })

      result = MilitaryOperations.new(unknown_data)
      assert result.site_type_code == "X"
      assert result.military_operations_code == "Z"
    end

    test "handles Guard Operations" do
      guard_data = create_sample_data(%{
        "MIL_OPS_OPER_CODE" => "A",
        "MIL_OPS_CALL" => "GUARD OPERATIONS",
        "ARPT_ID" => "PHX",
        "CITY" => "PHOENIX",
        "REMARK" => "(MIL_OPS_HRS) OPS 1200-0100Z MON-THU; 1200-2200Z FRI, 48 HR PPR. CLSD WKEND, HOL. AMOPS D853-9162/C602-302-9162. 24 HR CP D853-9071. BIRDS INVOF; BASH PHASE I JAN-FEB & JUN-SEP MIG SEASON INCREASED BIRD ACTV. PHASE II HVY BIRD ACT. BWC UPON REQUEST. SEE AP1."
      })

      result = MilitaryOperations.new(guard_data)
      assert result.military_operations_code == :active
      assert result.military_operations_call == "GUARD OPERATIONS"
      assert result.airport_id == "PHX"
      assert result.city == "PHOENIX"
      assert String.contains?(result.remark, "BIRDS INVOF")
      assert String.contains?(result.remark, "BWC UPON REQUEST")
    end
  end

  describe "type/0" do
    test "returns correct type string" do
      assert MilitaryOperations.type() == "MIL_OPS"
    end
  end

  # Helper function to create sample data with default values
  defp create_sample_data(overrides) do
    Map.merge(%{
      "EFF_DATE" => "2025/08/07",
      "SITE_NO" => "00124.",
      "SITE_TYPE_CODE" => "A",
      "STATE_CODE" => "AL",
      "ARPT_ID" => "79J",
      "CITY" => "ANDALUSIA",
      "COUNTRY_CODE" => "US",
      "MIL_OPS_OPER_CODE" => "R",
      "MIL_OPS_CALL" => "",
      "MIL_OPS_HRS" => "",
      "AMCP_HRS" => "",
      "PMSV_HRS" => "",
      "REMARK" => ""
    }, overrides)
  end
end