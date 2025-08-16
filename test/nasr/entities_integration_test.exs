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
    test "handles all entity types from stream_raw without returning nil", %{entity_samples: entity_samples} do
      Enum.map(entity_samples, fn entity ->
        struct = NASR.from_raw(entity)
        assert struct != nil, "Entity should not return nil: #{inspect(entity)}"
        assert Map.has_key?(struct, :__struct__), "Entity should be a struct: #{inspect(struct)}"
      end)

      :ok
    end

    test "all entities have an example in the sample", %{entity_samples: samples} do
      # There are some entity types that may not have samples in the current NASR data
      exceptions = ~w()

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
  end
end
