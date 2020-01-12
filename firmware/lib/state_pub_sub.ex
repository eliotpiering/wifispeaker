defmodule Firmware.StatePubSub do

  def subscribe do
    Phoenix.PubSub.subscribe(UiWeb.PubSub, topic(), link: true)
  end

  def broadcast(message) do
    Phoenix.PubSub.broadcast(UiWeb.PubSub, topic(), message)
  end

  def notify_update do
    broadcast(:state_update)
  end

  defp topic(), do: "state-update:" <> inspect(Node.self())
  defp topic(node), do: "state-update:" <> node

end
