defmodule Firmware.BufferIn do
  use Agent
  # matches @chunk_size_in_bytes 400 from Firmware.ParsePcm
  @chunk_size 400

  def start_link([]) do
    Agent.start_link(fn -> <<>> end, name: __MODULE__)
  end

  def push(chunk) do
    # TODO keep track of size of queue and if size > some count pop the first item off the queue and the push the item on
    Agent.update(__MODULE__, fn binary -> binary <> chunk end)
  end

  def pull() do
    Agent.get_and_update(__MODULE__, fn binary ->
      with <<one_chunk::binary-size(@chunk_size), rest::binary>> <- binary do
        {one_chunk, rest}
      else
        err -> {nil, binary}
      end
    end)
  end
end
