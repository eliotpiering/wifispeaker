defmodule UiWeb.StreamChannel do
  use Phoenix.Channel

  def join("stream:" <> node_name, message, socket) do
    send(self, :after_join)
    {:ok, socket}
  end

  def handle_info(:after_join, socket) do
    broadcast!(socket, "new_node_state", %{nodes: Ui.Edux.get_nodes})
    Firmware.StatePubSub.subscribe() # 
    {:noreply, socket}
  end

  def handle_in("adjust_volume", %{"id" => id, "volume" => volume}, socket) do
    #TODO better api for ui updates (should always get a list of nodes back?)
    new_nodes = Ui.Edux.update({"adjust_volume", volume, id}) |> Map.values 
    broadcast!(socket, "new_node_state", %{nodes: new_nodes})
    {:noreply, socket}
  end

  def handle_info(:state_update, socket) do
    push(socket, "new_node_state", %{nodes: Ui.Edux.get_nodes})
  end
end
