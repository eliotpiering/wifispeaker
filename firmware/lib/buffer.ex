defmodule Firmware.Buffer do
  use Agent

  def start_link() do
    Agent.start_link(fn -> :queue.new() end, name: __MODULE__)
  end

  def push(chunk) do
    Agent.update(__MODULE__, fn queue -> :queue.in(chunk, queue) end)
  end

  def pull() do
    Agent.get_and_update(__MODULE__, fn queue ->
      case :queue.out(queue) do
        {{:value, chunk}, updated_queue} ->
          {chunk, updated_queue}

        {:empty, updated_queue} ->
          {nil, updated_queue}
      end
    end)
  end
end
