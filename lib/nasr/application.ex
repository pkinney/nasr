defmodule NASR.Application do
  @moduledoc false
  use Application

  @impl true
  def start(_type, _args) do
    Supervisor.start_link([NASR.Server], strategy: :one_for_one, name: Sup.App)
  end
end
