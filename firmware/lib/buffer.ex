defmodule Firmware.Buffer do
  use Agent

  def start_link(name) do
    Agent.start_link(fn -> :queue.new() end, name: name)
  end

  def push(chunk) do
    push(chunk, __MODULE__)
  end

  def push(chunk, name) do
    #TODO keep track of size of queue and if size > some count pop the first item off the queue and the push the item on
    Agent.update(name, fn queue -> :queue.in(chunk, queue) end)
  end

  def pull() do
    pull(__MODULE__)
  end

  def pull(name) do
    Agent.get_and_update(name, fn queue ->
      case :queue.out(queue) do
        {{:value, chunk}, updated_queue} ->
          {chunk, updated_queue}

        {:empty, updated_queue} ->
          {nil, updated_queue}
      end
    end)
  end
end
