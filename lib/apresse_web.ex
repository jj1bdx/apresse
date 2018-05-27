defmodule ApresseWeb do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    :aprs_receiver.start()

    children = [
      # Start the endpoint when the application starts
      supervisor(ApresseWeb.Endpoint, []),
    ]

    opts = [strategy: :one_for_one, name: ApresseWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end

end
