defmodule ApresseWeb.APRSMap do
  @moduledoc """

  TBD. A standalone plug module to pick APRS data from ETS
  and convert them into map data through templates.


  """

  # Note for module development:
  # No compression
  # No caching (since the contents of directory may vary every time)

  @behaviour Plug
  @allowed_methods ~w(GET HEAD)

  import Plug.Conn
  alias Plug.Conn
  
  @spec init(any()) :: no_return() 
  
  def init(_opts) do
    # do nothing here
  end

  @spec call(Plug.Conn.t, any()) :: Plug.Conn.t | no_return()

  def call(conn = %Conn{method: meth}, _)
    when meth in @allowed_methods do
    dump_aprs_map(conn)
  end

  @spec call(Plug.Conn.t, any()) :: Plug.Conn.t | no_return()

  def call(conn, _opts) do
    conn
  end

  defp dump_aprs_map(conn) do
    conn
    |> put_resp_header("content-type", "text/html")
    |> send_resp(200, make_aprs_map())
    |> halt
  end

  require EEx

  EEx.function_from_file(:defp, :header_html,
    "lib/templates/apresse_web_header.html.eex", [
  ])

  EEx.function_from_file(:defp, :footer_html,
    "lib/templates/apresse_web_footer.html.eex", [
  ])

  EEx.function_from_file(:defp, :mapentry_html,
    "lib/templates/apresse_web_mapentry.html.eex", [
      :source,
      :lat,
      :long
    ])

  defp make_aprs_map() do
    # Plug.conn.send_resp/3 accepts IOlist in the body
    [
      header_html(),
      Enum.map(:ets.tab2list(:aprs_positions),
        fn({_, source, lat, long}) -> mapentry_html(source, lat, long) end),
      footer_html()
    ]
  end
end
