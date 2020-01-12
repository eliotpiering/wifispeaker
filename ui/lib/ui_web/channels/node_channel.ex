defmodule UiWeb.NodeChannel do
  use Phoenix.Channel

  def join("node:" <> node_name, message, socket) do
    send(self, :after_join)
    {:ok, socket}
  end

  def handle_info(:after_join, socket) do
    broadcast!(socket, "new_state", %{nodes: Ui.Edux.get_nodes})
    Firmware.StatePubSub.subscribe() # 
    {:noreply, socket}
  end

  def handle_in("adjust_volume", %{"id" => id, "volume" => volume}, socket) do
    new_nodes = Ui.Edux.update({"adjust_volume", volume, id})
    broadcast!(socket, "new_state", %{nodes: new_nodes})
    {:noreply, socket}
  end

  def handle_info(:state_update, socket) do
    IO.inspect("state update")
    push(socket, "new_state", %{nodes: Ui.Edux.get_nodes})
  end
end
