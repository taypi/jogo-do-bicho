defmodule JogoDoBichoWeb.PoolLive.Show do
  use JogoDoBichoWeb, :live_view

  alias JogoDoBicho.Pools

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        Pool {@pool.id}
        <:subtitle>This is a pool record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/pools"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/pools/#{@pool}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit pool
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Name">{@pool.name}</:item>
        <:item title="Invite link">{@pool.name}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    if connected?(socket) do
      socket.assigns.current_scope
      |> Pools.get_pool!(id)
      |> Pools.subscribe_pool()
    end

    {:ok,
     socket
     |> assign(:page_title, "Show Pool")
     |> assign(:pool, Pools.get_pool!(socket.assigns.current_scope, id))}
  end

  @impl true
  def handle_info(
        {:updated, %JogoDoBicho.Pools.Pool{id: id} = pool},
        %{assigns: %{pool: %{id: id}}} = socket
      ) do
    {:noreply, assign(socket, :pool, pool)}
  end

  def handle_info(
        {:deleted, %JogoDoBicho.Pools.Pool{id: id}},
        %{assigns: %{pool: %{id: id}}} = socket
      ) do
    {:noreply,
     socket
     |> put_flash(:error, "The current pool was deleted.")
     |> push_navigate(to: ~p"/pools")}
  end

  def handle_info({type, %JogoDoBicho.Pools.Pool{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, socket}
  end
end
