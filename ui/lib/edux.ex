defmodule Ui.Edux do

  def ui_state do
    %{nodes: get_nodes(),
      streams: get_streams()
    }
  end

  defp get_streams do
    []
  end

  defp get_nodes do
    Ui.State.list() |> to_valid_frontend_state |> Map.values
  end

  def update({"adjust_volume", volume, id}) do
    Ui.State.list()
    |> Enum.map(fn {key, value} ->
      if to_string(key) == id do
        updated_value = Map.put(value, :volume, volume)
        # optomistically update
        Ui.State.update(key, value.pid, updated_value)

        #actually update
        # Firmware.Receiver.update_volume(volume) # update for real
        {key, updated_value}
      else
        {key, value}
      end
    end)
    |> to_valid_frontend_state
  end

  defp to_valid_frontend_state(state) do
    state |> Enum.reduce(%{}, fn ({k, map}, acc) -> Map.put(acc, k, Map.delete(map, :pid)) end)
  end
end
