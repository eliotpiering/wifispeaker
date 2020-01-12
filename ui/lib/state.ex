defmodule Ui.State do
  @behaviour Phoenix.Tracker
  @topic "main"
  alias Phoenix.Tracker

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :supervisor
    }
  end

  def start_link(opts) do
    opts = Keyword.merge([name: __MODULE__], opts)
    Tracker.start_link(__MODULE__, opts, opts)
  end

  def init(opts) do
    server = Keyword.fetch!(opts, :pubsub_server)
    {:ok, %{pubsub_server: server, node_name: Phoenix.PubSub.node_name(server)}}
  end

  def handle_diff(diff, state) do
    Firmware.StatePubSub.notify_update()
    # for {topic, {joins, leaves}} <- diff do
    #   for {key, meta} <- joins do
    #     IO.puts "presence join: key \"#{key}\" with meta #{inspect meta}"
    #   end
    #   for {key, meta} <- leaves do
    #     IO.puts "presence leave: key \"#{key}\" with meta #{inspect meta}"
    #   end
    # end
    {:ok, state}
  end

  # ---------------- Client API --------------------------

  def list() do
    Tracker.list(__MODULE__, @topic)
  end

  def track(key, initial_data) do
    Phoenix.Tracker.track(__MODULE__, self(), @topic, key, initial_data)
  end

  def update(key, data = %{}) do
    update(key, self(), data)
  end

  def update(key, pid, data = %{}) do
    Phoenix.Tracker.update(__MODULE__, pid, @topic, key, data)
  end


end
