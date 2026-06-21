defmodule JogoDoBichoWeb.PageController do
  use JogoDoBichoWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
