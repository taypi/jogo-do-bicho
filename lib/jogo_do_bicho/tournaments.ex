defmodule JogoDoBicho.Tournaments do
  @moduledoc """
  The Tournaments context.
  """

  import Ecto.Query, warn: false
  alias JogoDoBicho.Repo

  alias JogoDoBicho.Tournaments.Tournament

  def list_tournaments do
    Repo.all(Tournament)
  end

  def get_tournament!(id) do
    Repo.get!(Tournament, id)
  end

  def create_tournament(attrs \\ %{}) do
    Repo.insert(Tournament.changeset(attrs))
  end

  def update_tournament(%Tournament{} = tournament, attrs) do
    tournament
    |> Tournament.changeset(attrs)
    |> Repo.update()
  end

  def delete_tournament(%Tournament{} = tournament) do
    Repo.delete(tournament)
  end

  def change_tournament(%Tournament{} = tournament, attrs \\ %{}) do
    Tournament.changeset(tournament, attrs)
  end

  def active_tournaments(date \\ Date.utc_today()) do
  Tournament
  |> where(
    [t],
    t.start_date <= ^date and
      t.end_date >= ^date
  )
  |> Repo.all()
end

  alias JogoDoBicho.Tournaments.TournamentTeam
  alias JogoDoBicho.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any tournament_team changes.

  The broadcasted messages match the pattern:

    * {:created, %TournamentTeam{}}
    * {:updated, %TournamentTeam{}}
    * {:deleted, %TournamentTeam{}}

  """
  def subscribe_tournament_teams(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(JogoDoBicho.PubSub, "user:#{key}:tournament_teams")
  end

  defp broadcast_tournament_team(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(JogoDoBicho.PubSub, "user:#{key}:tournament_teams", message)
  end

  @doc """
  Returns the list of tournament_teams.

  ## Examples

      iex> list_tournament_teams(scope)
      [%TournamentTeam{}, ...]

  """
  def list_tournament_teams(%Scope{} = scope) do
    Repo.all_by(TournamentTeam, user_id: scope.user.id)
  end

  @doc """
  Gets a single tournament_team.

  Raises `Ecto.NoResultsError` if the Tournament team does not exist.

  ## Examples

      iex> get_tournament_team!(scope, 123)
      %TournamentTeam{}

      iex> get_tournament_team!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_tournament_team!(%Scope{} = scope, id) do
    Repo.get_by!(TournamentTeam, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a tournament_team.

  ## Examples

      iex> create_tournament_team(scope, %{field: value})
      {:ok, %TournamentTeam{}}

      iex> create_tournament_team(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tournament_team(%Scope{} = scope, attrs) do
    with {:ok, tournament_team = %TournamentTeam{}} <-
           %TournamentTeam{}
           |> TournamentTeam.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast_tournament_team(scope, {:created, tournament_team})
      {:ok, tournament_team}
    end
  end

  @doc """
  Updates a tournament_team.

  ## Examples

      iex> update_tournament_team(scope, tournament_team, %{field: new_value})
      {:ok, %TournamentTeam{}}

      iex> update_tournament_team(scope, tournament_team, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tournament_team(%Scope{} = scope, %TournamentTeam{} = tournament_team, attrs) do
    true = tournament_team.user_id == scope.user.id

    with {:ok, tournament_team = %TournamentTeam{}} <-
           tournament_team
           |> TournamentTeam.changeset(attrs, scope)
           |> Repo.update() do
      broadcast_tournament_team(scope, {:updated, tournament_team})
      {:ok, tournament_team}
    end
  end

  @doc """
  Deletes a tournament_team.

  ## Examples

      iex> delete_tournament_team(scope, tournament_team)
      {:ok, %TournamentTeam{}}

      iex> delete_tournament_team(scope, tournament_team)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tournament_team(%Scope{} = scope, %TournamentTeam{} = tournament_team) do
    true = tournament_team.user_id == scope.user.id

    with {:ok, tournament_team = %TournamentTeam{}} <-
           Repo.delete(tournament_team) do
      broadcast_tournament_team(scope, {:deleted, tournament_team})
      {:ok, tournament_team}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tournament_team changes.

  ## Examples

      iex> change_tournament_team(scope, tournament_team)
      %Ecto.Changeset{data: %TournamentTeam{}}

  """
  def change_tournament_team(%Scope{} = scope, %TournamentTeam{} = tournament_team, attrs \\ %{}) do
    true = tournament_team.user_id == scope.user.id

    TournamentTeam.changeset(tournament_team, attrs, scope)
  end
end
