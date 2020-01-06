defmodule Firmware.Parser do
  # use GenServer
  alias Firmware.ParsePcm
  alias __MODULE__

  @native_time_chunk_length 1000

  def child_spec([]) do
    %{
      id: Parser,
      start: {Parser, :start_link, []}
    }
  end

  def start_link() do
    Task.start_link(fn -> parse_infinite_chunks() end)
  end

  # def start_link([]) do
  #   GenServer.start_link(__MODULE__, [], name: __MODULE__)
  # end

  def parse(pid, data) do
    GenServer.cast(pid, {:parse, data})
  end

  def reset(pid) do
    GenServer.call(pid, :reset)
  end

  # # SERVER
  # @impl true
  # def init([]) do
  #   state = %{
  #     time: nil
  #   }

  #   {:ok, state}
  # end

  def parse_infinite_chunks() do
    case Firmware.BufferIn.pull() do
      nil ->
        Process.sleep(1)
        parse_infinite_chunks()

      data ->
        now = System.os_time(441_000)
        start_time = now + 441_000
        Firmware.Server.broadcast({start_time, data})
        parse_infinite_chunks(start_time + @native_time_chunk_length)

    end
  end

  def parse_infinite_chunks(time) do
    case Firmware.BufferIn.pull() do
      nil ->
        Process.sleep(1)
        parse_infinite_chunks(time)

      data ->
        Firmware.Server.broadcast({time, data})
        parse_infinite_chunks(time + @native_time_chunk_length)
    end
  end



  def handle_call(:reset, _from, _state) do
    {:reply, :ok, %{time: nil, leftover: <<>>}}
  end

  def handle_cast({:parse, data}, state = %{time: nil}) do
    now = System.os_time(441_000)
    start_time = now + 441_000 * 10

    new_state = parse_and_send_data(data, start_time, state)
    {:noreply, new_state}
  end

  def handle_cast({:parse, data}, state = %{leftover: leftover, time: time}) do
    new_state = parse_and_send_data(leftover <> data, time, state)
    {:noreply, new_state}
  end

  defp parse_and_send_data(data, time, state) do
    case ParsePcm.parse_chunks(data, time) do
      {:ok, chunks, new_time} ->
        Enum.each(chunks, &Firmware.Server.broadcast(&1))
        %{time: new_time, leftover: <<>>}

      {:error, :not_enough} ->
        %{state | leftover: state.leftover <> data}
    end
  end
end
