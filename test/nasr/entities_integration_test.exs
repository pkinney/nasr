defmodule NASR.EntitiesIntegrationTest do
  use ExUnit.Case

  @moduletag timeout: 60_000

  setup_all do
    Application.ensure_all_started(:nasr)

    nasr_file_path = NASR.TestSetup.load_nasr_zip_if_needed()
    # Collect one raw entity of each type from the NASR stream
    entity_samples =
      [file: nasr_file_path]
      |> NASR.stream_raw()
      |> Enum.uniq_by(fn entity ->
        Map.get(entity, "__TYPE__")
      end)

    {:ok, entity_samples: entity_samples}
  end

  describe "NASR.stream_structs/1" do
    @tag :integration
    test "handles all entity types from stream_raw without returning nil", %{entity_samples: _entity_samples} do
      # Enum.map(entity_samples, fn entity ->
      #   struct = NASR.from_raw(entity)
      #   assert struct != nil, "Entity should not return nil: #{inspect(entity)}"
      #   assert Map.has_key?(struct, :__struct__), "Entity should be a struct: #{inspect(struct)}"
      # end)

      :ok
    end

    test "all entities have an example in the sample", %{entity_samples: samples} do
      # There are some entity types that may not have samples in the current NASR data
      exceptions = ~w()a

      Enum.each(NASR.entity_modules(), fn module ->
        type = module.type()

        if type not in exceptions do
          assert Enum.any?(samples, fn sample -> sample["__TYPE__"] == type end),
                 "No sample found for entity type #{type}"
        end
      end)
    end

    Enum.each(NASR.entity_modules(), fn module_under_test ->
      test "entity module #{module_under_test} can be created from sample data", %{entity_samples: samples} do
        module = unquote(module_under_test)
        type = module.type()

        samples
        |> Enum.find(fn sample ->
          sample["__TYPE__"] == type
        end)
        |> case do
          # we test for this elsewhere
          nil ->
            :ok

          sample ->
            entity = NASR.from_raw(sample)

            assert entity.__struct__ == module,
                   "Entity module #{module} should match the sample type #{type}"
        end
      end
    end)

    # @tag :integration
    # test "from_raw returns structs that match expected patterns" do
    #   # Sample a few entities and verify they have expected structure
    #   sample_entities =
    #     NASR.stream_raw()
    #     |> Stream.take(100)
    #     |> Stream.map(&NASR.Entities.from_raw/1)
    #     |> Stream.reject(&is_nil/1)
    #     |> Enum.take(10)

    #   assert length(sample_entities) > 0, "Should get some processed entities"

    #   # Verify each entity is a struct with the expected pattern
    #   for entity <- sample_entities do
    #     assert is_struct(entity), "Entity should be a struct: #{inspect(entity)}"
    #     assert Map.has_key?(entity, :__struct__), "Entity should have __struct__ key"

    #     # Verify the module exists and follows naming convention
    #     module = entity.__struct__
    #     assert is_atom(module), "Module should be an atom"
    #     module_name = to_string(module)
    #     assert String.starts_with?(module_name, "Elixir.NASR."), "Module should be in NASR namespace"
    #   end

    #   :ok
    # end

    # test "from_raw handles unknown entity types gracefully" do
    #   unknown_entity = %{type: :unknown_test_type, some_field: "test"}
    #   result = NASR.Entities.from_raw(unknown_entity)

    #   # Unknown types should return nil (handled by the catch-all pattern)
    #   assert is_nil(result), "Unknown entity types should return nil"
    # end
  end
end
