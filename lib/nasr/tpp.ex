defmodule NASR.TPP do
  @moduledoc false
  import SweetXml

  require Logger

  def stream_recent do
    date = NASR.Utils.get_airac_cycle_for_date()
    url = "https://aeronav.faa.gov/d-tpp/#{date}/xml_data/d-TPP_Metafile.xml"
    stream_records(url: url)
  end

  def stream_records(opts \\ nil) do
    date = Timex.format!(DateTime.utc_now(), "{YY}{0M}")
    url = "https://aeronav.faa.gov/d-tpp/#{date}/xml_data/d-TPP_Metafile.xml"
    opts = opts || [url: url]

    cond do
      Keyword.has_key?(opts, :file) ->
        stream_file(Keyword.get(opts, :file))

      Keyword.has_key?(opts, :url) ->
        url = Keyword.get(opts, :url)
        file = NASR.Utils.download(url)
        stream_records(file: file)
    end
  end

  defp stream_file(filename) do
    stream = File.stream!(filename)
    cycle = xpath(stream, ~x"//digital_tpp/@cycle"s)
    base_url = ["https://aeronav.faa.gov", "d-tpp", cycle] |> Path.join() |> IO.inspect()

    stream
    |> SweetXml.stream!(fn emit ->
      [
        hook_fun: fn
          e, state when elem(e, 1) == :airport_name ->
            code = xpath(e, ~x"./@apt_ident"s)

            r =
              e
              |> xpath(~x"./record"l,
                name: ~x"./chart_name/text()"s,
                proc_id: ~x"./procuid/text()"s,
                chart_code: ~x"./chart_code/text()"s,
                civil: ~x"./civil/text()"s,
                pdf: transform_by(~x"./pdf_name/text()"s, &Path.join([base_url, &1])),
                airport: ~x"./../airport_name"
              )
              |> Enum.map(fn chart ->
                Map.put(chart, :airport, code)
              end)

            emit.(r)
            {e, state}

          e, state ->
            {e, state}
        end
      ]
    end)
    |> Stream.flat_map(& &1)
  end
end
