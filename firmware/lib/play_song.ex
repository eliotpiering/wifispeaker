defmodule Firmware.PlaySong do
  @channels 2
  @frames_per_second 44100

  def play() do
    Firmware.Buffer.start_link()
    #TODO figure out the proper way to start this guy
    Task.start_link(fn -> play_infinite_chunks() end)
  end

  def play_infinite_chunks() do
    port =
      Port.open(
        {:spawn, "/usr/bin/aplay -f s16_LE -c #{@channels} -r #{@frames_per_second} -"},
        []
      )
    play_infinite_chunks(port)
  end

  def play_infinite_chunks(port) do
    case Firmware.Buffer.pull() do
      nil ->
        Process.sleep(10)
        play_infinite_chunks(port)

      {start_time, chunk} ->
        play_chunk_at(start_time, chunk, port)
        play_infinite_chunks(port)
    end
  end

  def play_chunk_at(time, chunk, port) do
    # now = System.monotonic_time() TODO use this instead of os bc of timewarps
    now = System.os_time(441_000)
    diff = now - time

    cond do
      # early
      diff < 0 ->
        play_chunk_at(time, chunk, port)

      # on time
      diff < 50 ->
        play_chunk(chunk, port)

      # late
      true ->
        :ok
    end
  end

  def play_chunk(chunk, port) do
    send(port, {self(), {:command, chunk}})
  end

end
