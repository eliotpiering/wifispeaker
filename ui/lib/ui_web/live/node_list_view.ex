defmodule UiWeb.NodeListView do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <%= for node <- @nodes do %>
      <div class="">
        <div>
          <%= node %>
        </div>
      </div>
    <% end %>
    """
  end

  def mount(_session, socket) do
    {:ok, assign(socket, nodes: Node.list())}
  end
end
