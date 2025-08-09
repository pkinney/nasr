defmodule NASR.EntitiesTypeTest do
  use ExUnit.Case

  @moduletag timeout: 60_000

  setup_all do
    Application.ensure_all_started(:nasr)

    # Ensure data directory exists and download NASR file if needed
    data_dir = "data"
    nasr_file_path = Path.join(data_dir, "nasr.zip")

    File.mkdir_p!(data_dir)

    if !File.exists?(nasr_file_path) do
      IO.puts("Downloading NASR file to: #{nasr_file_path}")
      downloaded_file = NASR.Utils.download(NASR.Utils.get_current_nasr_url())
      File.cp!(downloaded_file, nasr_file_path)
      File.rm!(downloaded_file)
    end

    # Collect one raw entity of each type from the NASR stream
    entity_samples =
      [file: nasr_file_path]
      |> NASR.stream_raw()
      |> Enum.uniq_by(fn entity ->
        Map.get(entity, :type)
      end)

    {:ok, entity_samples: entity_samples}
  end

  describe("entity for each type") do
    test "all entity modules have a type" do
      Enum.each(NASR.Entities.entity_modules(), fn module ->
        type = NASR.Entities.entity_to_type(module)

        assert type,
               "Entity module #{module} should have a corresponding type"
      end)
    end

    test "all types have an entity module", %{entity_samples: samples} do
      Enum.each(samples, fn %{type: type} ->
        assert NASR.Entities.type_to_entity(type),
               "Entity type #{type} should have a corresponding module"
      end)
    end

    test "all entities have an example in the sample", %{entity_samples: samples} do
      # There are some entity types that may not have samples in the current NASR data
      exceptions = ~w(ats3 ats5 fix4)a

      Enum.each(NASR.Entities.entity_modules(), fn module ->
        type = NASR.Entities.entity_to_type(module)

        if type not in exceptions do
          assert Enum.any?(samples, fn sample -> sample.type == type end),
                 "No sample found for entity type #{type}"
        end
      end)
    end

    Enum.each(NASR.Entities.entity_modules(), fn module_under_test ->
      test "entity module #{module_under_test} can be created from sample data", %{entity_samples: samples} do
        module = unquote(module_under_test)
        IO.inspect(module)
        type = NASR.Entities.entity_to_type(module)

        samples
        |> Enum.find(fn sample ->
          sample.type == type
        end)
        |> case do
          # we test for this elsewhere
          nil ->
            :ok

          sample ->
            entity = NASR.Entities.from_raw(sample)

            assert entity.__struct__ == module,
                   "Entity module #{module} should match the sample type #{type}"
        end
      end
    end)

    test "all samples are successfully converted to the correct entity struct", %{entity_samples: samples} do
      Enum.each(samples, fn sample ->
        entity = NASR.Entities.from_raw(sample)

        refute is_nil(entity),
               "Sample of type #{sample.type} could not be converted to module"

        assert NASR.Entities.entity_to_type(entity.__struct__) == sample.type
      end)
    end
  end
end
