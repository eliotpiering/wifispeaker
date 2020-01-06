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
    # Supervisor.start_link(children(@target), opts)
    Supervisor.start_link(children("host"), opts)
  end

  # List all child processes to be supervised
  def children("host") do
    [
      {Firmware.Buffer, Firmware.Buffer},
      Firmware.BufferIn,
      Firmware.AlsaPlayer,
      Firmware.Receiver,
      Firmware.Parser,
      Firmware.Server
    ]
  end
end
