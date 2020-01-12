defmodule UiWeb.PageController do
  use UiWeb, :controller

  def index(conn, _) do
    nodes = Node.list() ++ [Node.self()]
    # live_render(conn, UiWeb.NodeListView, session: Ui.State.list())
    render(conn, "index.html")
  end
end
