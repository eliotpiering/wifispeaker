defmodule Firmware.Server do
  use GenServer

  @native_time_chunk_length 1000

  def start_link([]) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init([]) do
    state = %{
      topic: nil,
      streams: %{},
      active_stream: nil
    }

    {:ok, state, {:continue, :initialize}}
  end

  def broadcast(chunk) do
    GenServer.cast(Firmware.Server, {:broadcast, chunk})
  end

  def register_stream(stream_name) do
    GenServer.call(Firmware.Server, {:register_stream, stream_name})
  end

  def activate_stream(stream_name) do
    #TODO make this into its own seperate task
    GenServer.cast(Firmware.Server, {:activate_stream, stream_name})
  end

  # SERVER
  def handle_continue(:initialize, state) do
    topic_name = Node.self()
    :ok = :pg2.create(topic_name)
    state = Map.put(state, :topic, topic_name)
    {:noreply, state}
  end

  def handle_call({:register_stream, stream_name}, _from, state) do
    # TODO maybe some kind of registry for these streams outside of the server?
    {:ok, buffer} = Firmware.Buffer3.start_link()
    state = Kernel.put_in(state.streams[stream_name], buffer)

    {:reply, {:ok, buffer}, state}
  end

  def handle_cast({:broadcast, chunk}, state) do
    :pg2.get_members(state.topic)
    |> Enum.each(fn pid ->
      GenServer.cast(pid, {:broadcast, chunk})
    end)

    {:noreply, state}
  end

  def handle_cast({:activate_stream, stream_name}, state) do
    state = Map.put(state, :active_stream, stream_name)
    start_time = System.os_time(441_000) + 441_000
    # TODO supervise this and restart if it crashes
    buffer = state.streams[stream_name]
    IO.inspect(buffer, label: "BUFFER")
    Task.start(fn -> broadcast_stream_loop(buffer, start_time) end)
    {:noreply, state}
  end

  defp broadcast_stream_loop(buffer, time, warning \\ 0) do
    case Firmware.Buffer3.pull(buffer) do
      nil ->
        if warning <= 5 do
          Process.sleep(100)
          broadcast_stream_loop(buffer, time, warning+1)
        end

      data ->
        Firmware.Server.broadcast({time, data})
        broadcast_stream_loop(buffer, time + @native_time_chunk_length)
    end
  end
end
