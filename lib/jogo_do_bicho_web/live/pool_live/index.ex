defmodule JogoDoBichoWeb.PoolLive.Index do
  use JogoDoBichoWeb, :live_view

  alias JogoDoBicho.Pools

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        Listing Pools
        <:actions>
          <.button variant="primary" navigate={~p"/pools/new"}>
            <.icon name="hero-plus" /> New Pool
          </.button>
        </:actions>
      </.header>

      <.table
        id="pools"
        rows={@streams.pools}
        row_click={fn {_id, pool} -> JS.navigate(~p"/pools/#{pool}") end}
      >
        <:col :let={{_id, pool}} label="Name">{pool.name}</:col>
        <:action :let={{_id, pool}}>
          <div class="sr-only">
            <.link navigate={~p"/pools/#{pool}"}>Show</.link>
          </div>
          <.link navigate={~p"/pools/#{pool}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, pool}}>
          <.link
            phx-click={JS.push("delete", value: %{id: pool.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Pools.subscribe_pools(socket.assigns.current_scope)
    end

    {:ok,
     socket
     |> assign(:page_title, "Listing Pools")
     |> stream(:pools, list_pools(socket.assigns.current_scope))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    pool = Pools.get_pool!(socket.assigns.current_scope, id)
    {:ok, _} = Pools.delete_pool(socket.assigns.current_scope, pool)

    {:noreply, stream_delete(socket, :pools, pool)}
  end

  @impl true
  def handle_info({type, %JogoDoBicho.Pools.Pool{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, stream(socket, :pools, list_pools(socket.assigns.current_scope), reset: true)}
  end

  defp list_pools(current_scope) do
    Pools.list_pools(current_scope)
  end
end
