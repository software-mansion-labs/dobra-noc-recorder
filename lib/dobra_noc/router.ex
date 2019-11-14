defmodule DobraNoc.Router do
  use Plug.Router
  plug Plug.Logger, log: :debug
  plug :match

  plug Plug.Parsers,
    parsers: [:json],
    json_decoder: Jason

  plug :dispatch

  post "/save_rec" do
    with %{"from" => from, "to" => to, "location" => location}
         when is_integer(from) and is_integer(to) <- conn.body_params do
      send(DobraNoc.Pipeline, {:save_rec, %{from: from, to: to, location: location}})
      send_resp(conn, 200, "ok")
    else
      _ -> send_resp(conn, 400, "invalid request")
    end
  end

  match _ do
    send_resp(conn, 404, "not found")
  end
end
