defmodule JogoDoBichoWeb.TournamentLive.Bracket do
  use JogoDoBichoWeb, :live_view

  import JogoDoBichoWeb.Bracket

  alias JogoDoBicho.Tournaments

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>

      <.header>
        {@tournament.name}
        <:subtitle>
          Tournament bracket
        </:subtitle>
      </.header>

      <.bracket stages={@stages} />

    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    tournament =
      Tournaments.get_tournament!(
        socket.assigns.current_scope,
        id
      )

    stages =
      Tournaments.list_stages(tournament)

    {:ok,
      socket
      |> assign(:page_title, "#{tournament.name} Bracket")
      |> assign(:tournament, tournament)
      |> assign(:stages, stages)}
  end
end
