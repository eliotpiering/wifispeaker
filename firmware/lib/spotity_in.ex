defmodule Firmware.SpotifyIn do
  alias Firmware.Buffer
  use GenServer

  @bits_per_second 1411200 # 44100 * 16 * 2
  @block_size 3200 # 16*2*100 or 100 frames at a time

  def start_link([]) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def stream_name do
    :spotify_in_buffer
  end

  @impl true
  def init([]) do
    state = %{
      port: nil,
      bufffer: nil
    }

    {:ok, state, {:continue, :start_spotify_in}}
  end

  def handle_continue(:start_spotify_in, state) do
    path = System.find_executable("librespot")
    #TODO put this throttle in here in a less crazy way
    cmd = "#{path} --backend pipe -b 320 --name 'WifiSpeaker' --initial-volume 80 | /home/eliot/Develop/throttle-1.2/throttle -b #{@bits_per_second} -s #{@block_size}"

    port =
      Port.open({:spawn, cmd}, [
        :binary,
        :exit_status
        # args: ["--backend pipe -b 320 --name 'WifiSpeaker' --initial-volume 80"]
      ])
    state = Map.put(state, :port, port)

    {:ok, buffer} = Firmware.Server.register_stream(__MODULE__)
    state = Map.put(state, :buffer, buffer)

    {:noreply, state}
  end

  def handle_info({_port, {:data, msg}}, state) do
    Firmware.Buffer3.push(state.buffer, msg)

    {:noreply, state}
  end
end
