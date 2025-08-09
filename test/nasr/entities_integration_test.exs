defmodule NASR.EntitiesIntegrationTest do
  use ExUnit.Case

  @moduletag timeout: 60_000

  describe "NASR.Entities.from_raw/1" do
    @tag :integration
    test "handles all entity types from stream_raw without returning nil" do
      # Track entity types and their counts
      entity_stats = %{
        total_entities: 0,
        nil_entities: 0,
        processed_types: MapSet.new(),
        error_types: MapSet.new()
      }

      # Process the stream with a reasonable limit to avoid overwhelming the test
      # Limit to first 10k entities for testing
      final_stats =
        Enum.reduce(NASR.stream_raw(), entity_stats, fn raw_entity, stats ->
          entity_type = Map.get(raw_entity, :type)

          try do
            result = NASR.Entities.from_raw(raw_entity)

            updated_stats = %{
              stats
              | total_entities: stats.total_entities + 1,
                processed_types: MapSet.put(stats.processed_types, entity_type)
            }

            if is_nil(result) do
              IO.puts("Warning: from_raw returned nil for entity type: #{inspect(entity_type)}")
              %{updated_stats | nil_entities: stats.nil_entities + 1}
            else
              updated_stats
            end
          rescue
            error ->
              IO.puts("Error processing entity type #{inspect(entity_type)}: #{inspect(error)}")
              %{stats | total_entities: stats.total_entities + 1, error_types: MapSet.put(stats.error_types, entity_type)}
          end
        end)

      # Print statistics
      IO.puts("Integration test results:")
      IO.puts("  Total entities processed: #{final_stats.total_entities}")
      IO.puts("  Entity types encountered: #{MapSet.size(final_stats.processed_types)}")
      IO.puts("  Entity types: #{final_stats.processed_types |> Enum.sort() |> Enum.join(", ")}")
      IO.puts("  Entities returning nil: #{final_stats.nil_entities}")
      IO.puts("  Entity types with errors: #{MapSet.size(final_stats.error_types)}")

      if MapSet.size(final_stats.error_types) > 0 do
        IO.puts("  Error types: #{final_stats.error_types |> Enum.sort() |> Enum.join(", ")}")
      end

      # Assertions
      assert final_stats.total_entities > 0
      assert final_stats.nil_entities == 0
      assert MapSet.size(final_stats.error_types) == 0
      assert MapSet.size(final_stats.processed_types) > 10

      :ok
    end

    @tag :integration
    test "from_raw returns structs that match expected patterns" do
      # Sample a few entities and verify they have expected structure
      sample_entities =
        NASR.stream_raw()
        |> Stream.take(100)
        |> Stream.map(&NASR.Entities.from_raw/1)
        |> Stream.reject(&is_nil/1)
        |> Enum.take(10)

      assert length(sample_entities) > 0, "Should get some processed entities"

      # Verify each entity is a struct with the expected pattern
      for entity <- sample_entities do
        assert is_struct(entity), "Entity should be a struct: #{inspect(entity)}"
        assert Map.has_key?(entity, :__struct__), "Entity should have __struct__ key"

        # Verify the module exists and follows naming convention
        module = entity.__struct__
        assert is_atom(module), "Module should be an atom"
        module_name = to_string(module)
        assert String.starts_with?(module_name, "Elixir.NASR."), "Module should be in NASR namespace"
      end

      :ok
    end

    test "from_raw handles unknown entity types gracefully" do
      unknown_entity = %{type: :unknown_test_type, some_field: "test"}
      result = NASR.Entities.from_raw(unknown_entity)

      # Unknown types should return nil (handled by the catch-all pattern)
      assert is_nil(result), "Unknown entity types should return nil"
    end
  end
end
