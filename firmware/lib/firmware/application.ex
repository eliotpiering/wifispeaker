defmodule Firmware.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  @target Mix.Project.config()[:target]

  use Application

  import Supervisor.Spec, warn: false

  def start(_type, _args) do
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options

    opts = [strategy: :one_for_one, name: Firmware.Supervisor]
    Supervisor.start_link(children(@target), opts)
  end

  # List all child processes to be supervised
  def children("host") do
    [
      # Starts a worker by calling: Firmware.Worker.start_link(arg)
      # {Firmware.Worker, arg},

      # {Phoenix.PubSub.PG2, name: MyApp.PubSub},
      # supervisor(Pheonix.PubSub.PG2, [:my_pubsub])
    ]
  end

  def children(_target) do
    [
      # %{
      #   id: Phoenix.PubSub.PG2,
      #   start: {Phoenix.PubSub.PG2, :start_link, [:my_pubsub, []]}
      #   }

      # {Phoenix.PubSub.PG2, name: Firmware.PubSub},
      # supervisor(MyApp.PubSub, [:my_pubsub])
      # Starts a worker by calling: Firmware.Worker.start_link(arg)
      # {Firmware.Worker, arg},
    ]
  end
end
