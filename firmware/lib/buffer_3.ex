defmodule Firmware.Buffer3 do
  use Agent
  # matches @chunk_size_in_bytes 400 from Firmware.ParsePcm
  @chunk_size 400

  # (44100 * 16 * 2) / 8
  @bytes_in_second 176_400

  def start_link() do
    Agent.start_link(fn -> <<>> end)
  end

  def push(pid, chunk) do
    # TODO keep track of size of queue and if size > some count pop the first item off the queue and the push the item on
    Agent.update(pid, fn binary ->
      if byte_size(binary) > @bytes_in_second do
        <<_throwaway::binary-size(@chunk_size), rest::binary>> = binary
        rest <> chunk
      else
        binary <> chunk
      end
    end)
  end

  def pull(pid) do
    Agent.get_and_update(pid, fn binary ->
      with <<one_chunk::binary-size(@chunk_size), rest::binary>> <- binary do
        {one_chunk, rest}
      else
        err -> {nil, binary}
      end
    end)
  end
end
