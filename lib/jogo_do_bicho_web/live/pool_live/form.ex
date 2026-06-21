defmodule JogoDoBichoWeb.PoolLive.Form do
  use JogoDoBichoWeb, :live_view

  alias JogoDoBicho.Pools
  alias JogoDoBicho.Pools.Pool
  alias JogoDoBicho.Tournaments

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage pool records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="pool-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:name]} type="text" label="Name" />

        <.input
          field={@form[:tournament_id]}
          type="select"
          label="Tournament"
          options={Enum.map(@tournaments, &{&1.name, &1.id})}
        />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Pool</.button>
          <.button navigate={return_path(@current_scope, @return_to, @pool)}>Cancel</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    {:ok,
    socket
    |> assign(:tournaments, Tournaments.list_tournaments())
    |> assign(:return_to, return_to(params["return_to"]))
    |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    pool = Pools.get_pool!(socket.assigns.current_scope, id)

    socket
    |> assign(:page_title, "Edit Pool")
    |> assign(:pool, pool)
    |> assign(:form, to_form(Pools.change_pool(socket.assigns.current_scope, pool)))
  end

  defp apply_action(socket, :new, _params) do
    pool = %Pool{}

    socket
    |> assign(:page_title, "New Pool")
    |> assign(:pool, pool)
    |> assign(:form, to_form(Pools.change_pool(socket.assigns.current_scope, pool)))
  end

  @impl true
  def handle_event("validate", %{"pool" => pool_params}, socket) do
    changeset = Pools.change_pool(socket.assigns.current_scope, socket.assigns.pool, pool_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"pool" => pool_params}, socket) do
    save_pool(socket, socket.assigns.live_action, pool_params)
  end

  defp save_pool(socket, :edit, pool_params) do
    case Pools.update_pool(socket.assigns.current_scope, socket.assigns.pool, pool_params) do
      {:ok, pool} ->
        {:noreply,
         socket
         |> put_flash(:info, "Pool updated successfully")
         |> push_navigate(
           to: return_path(socket.assigns.current_scope, socket.assigns.return_to, pool)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_pool(socket, :new, pool_params) do
    case Pools.create_pool(socket.assigns.current_scope, pool_params) do
      {:ok, pool} ->
        {:noreply,
         socket
         |> put_flash(:info, "Pool created successfully")
         |> push_navigate(
           to: return_path(socket.assigns.current_scope, socket.assigns.return_to, pool)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path(_scope, "index", _pool), do: ~p"/pools"
  defp return_path(_scope, "show", pool), do: ~p"/pools/#{pool}"
end
