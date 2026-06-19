defmodule NASR.TestSetup do
  @moduledoc false

  def load_nasr_zip_if_needed do
    data_dir = "data"
    nasr_file_path = Path.join(data_dir, "nasr.zip")

    File.mkdir_p!(data_dir)

    if !File.exists?(nasr_file_path) do
      IO.puts("Downloading NASR file to: #{nasr_file_path}")
      downloaded_file = NASR.Utils.download(NASR.Utils.get_current_nasr_url())
      File.cp!(downloaded_file, nasr_file_path)
      File.rm!(downloaded_file)
    end

    nasr_file_path
  end
end
