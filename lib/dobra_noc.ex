defmodule DobraNoc do
  use Application

  @impl true
  def start(_type, _args) do
    {:ok, ip} =
      System.get_env("DOBRANOC_IP", "127.0.0.1") |> to_charlist() |> :inet.parse_address()

    port = System.get_env("DOBRANOC_PORT", "8123") |> String.to_integer()

    children = [
      {Plug.Cowboy, scheme: :http, plug: DobraNoc.Router, options: [ip: ip, port: port]},
      %{
        id: DobraNoc.Pipeline,
        start: {DobraNoc.Pipeline, :start_play, [[name: DobraNoc.Pipeline]]}
      }
    ]

    options = [strategy: :one_for_one, name: __MODULE__]
    Supervisor.start_link(children, options)
  end
end
