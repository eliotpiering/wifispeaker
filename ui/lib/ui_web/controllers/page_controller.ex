defmodule UiWeb.PageController do
  use UiWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def dashboard(conn, _params) do
    render(conn, "dashboard.html", %{nodes: Node.list})
  end
end
