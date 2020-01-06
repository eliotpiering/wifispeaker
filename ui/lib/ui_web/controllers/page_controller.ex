defmodule UiWeb.PageController do
  use UiWeb, :controller

  def index(conn, _) do
    IO.inspect(Node.list(), label: "Node list")
    live_render(conn, UiWeb.NodeListView, session: %{nodes: Node.list()})
  end
end
