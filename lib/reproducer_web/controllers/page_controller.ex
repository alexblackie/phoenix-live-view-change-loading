defmodule ReproducerWeb.PageController do
  use ReproducerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
