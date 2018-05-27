defmodule ApresseWeb.Endpoint do
  use Plug.Builder

  #plug Plug.Logger

  plug Plug.Static,
    at: "/static", from: :apresse_web

  plug ApresseWeb.APRSMap

  plug :not_found
  plug :halt

  def not_found(conn, _) do
    Plug.Conn.send_resp(conn, 404, ["not found"," ", "here"])
  end

  def halt(conn, _) do
    Plug.Conn.halt(conn)
  end

  def init(options) do
    options
  end

  defp get_env(name, defval) do
    Application.get_env(:apresse_web, name, defval)
  end

  def start_link() do
    {:ok, _} = Plug.Adapters.Cowboy.http ApresseWeb.Endpoint, [],
    port: get_env(:port, 8080),
    ip: get_env(:ip, {127, 0, 0, 1})
  end
end
