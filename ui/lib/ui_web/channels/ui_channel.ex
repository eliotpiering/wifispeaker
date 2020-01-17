defmodule UiWeb.UiChannel do
  use Phoenix.Channel

  def join("ui:" <> node_name, message, socket) do
    send(self, :after_join)
    {:ok, socket}
  end

  def handle_info(:after_join, socket) do
    broadcast!(socket, "new_state", Ui.Edux.ui_state())
    Firmware.StatePubSub.subscribe()
    {:noreply, socket}
  end

  def handle_in("adjust_volume", %{"id" => id, "volume" => volume}, socket) do
    Ui.Edux.update({"adjust_volume", volume, id})
    {:noreply, socket}
  end

  def handle_info(:state_update, socket) do
    broadcast!(socket, "new_state", Ui.Edux.ui_state())
  end
end
