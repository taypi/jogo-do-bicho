defmodule JogoDoBichoWeb.PoolLive.Join do
  use JogoDoBichoWeb, :live_view

  alias JogoDoBicho.Pools

  def mount(%{"invite_token" => invite_token}, _session, socket) do
    case Pools.join_pool(socket.assigns.current_scope, invite_token) do
      {:ok, pool} ->
        {:ok,
         push_navigate(socket,
           to: ~p"/pools/#{pool}"
         )}

      {:error, _reason} ->
        {:ok,
         socket
         |> put_flash(:error, "Unable to join pool")
         |> push_navigate(to: ~p"/pools")}
    end
  end
end
