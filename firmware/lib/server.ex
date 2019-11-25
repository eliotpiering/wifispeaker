defmodule Firmware.Server do
  use GenServer

  # CLIENT API
  def start_link do
    GenServer.start_link(__MODULE__, [])
  end

  def broadcast(data) do
    :pg2.get_members(topic())
    |> Enum.each(fn pid ->
      GenServer.cast(pid, {:broadcast, data})
    end)
  end

  def subscribe(topic) do
    {:ok, server} = start_link()
    :pg2.join(topic, server)
  end

  def unsubscribe(topic) do
    :pg2.get_local_members()
    |> Enum.each(fn member -> :pg2.leave(topic, member) end)
  end

  # SERVER
  @impl true
  def init([]) do
    :ok = :pg2.create(topic())
    {:ok, []}
  end

  @impl true
  def handle_cast({:broadcast, data}, _) do
    Firmware.Buffer.push(data)
    {:noreply, []}
  end

  # HELPERS

  defp topic() do
    Node.self()
  end
end
