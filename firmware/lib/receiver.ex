defmodule Firmware.Receiver do
  alias Firmware.Receiver
  alias Firmware.Buffer
  use GenServer

  def start_link([]) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init([]) do
    {:ok, []}
  end

  def subscribe(topic) do
    GenServer.call(Receiver, {:subscribe, topic})
  end

  def unsubscribe(topic) do
    GenServer.call(Receiver, {:unsubscribe, topic})
  end

  # TODO should these be handle cast or handle call?
  @impl true
  def handle_cast({:broadcast, data}, _) do
    Buffer.push(data)
    {:noreply, []}
  end

  def handle_call({:subscribe, topic}, _from, _state) do
    :pg2.join(topic, self())

    {:reply, :ok, _state}
  end

  def handle_call({:unsubscribe, topic}, _from, _state) do
    :pg2.get_local_members(topic)
    |> Enum.each(fn member -> :pg2.leave(topic, member) end)

    {:reply, :ok, _state}
  end
end
