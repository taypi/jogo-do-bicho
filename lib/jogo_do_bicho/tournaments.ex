defmodule JogoDoBicho.Tournaments do
  @moduledoc """
  The Tournaments context.
  """

  import Ecto.Query, warn: false
  alias JogoDoBicho.Repo

  alias JogoDoBicho.Tournaments.Tournament
  alias JogoDoBicho.Tournaments.Stage

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

  # defp broadcast_tournament_team(%Scope{} = scope, message) do
  #   key = scope.user.id

  #   Phoenix.PubSub.broadcast(JogoDoBicho.PubSub, "user:#{key}:tournament_teams", message)
  # end

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
  def create_tournament_team(attrs) do
    %TournamentTeam{}
    |> TournamentTeam.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tournament_team.

  ## Examples

      iex> update_tournament_team(scope, tournament_team, %{field: new_value})
      {:ok, %TournamentTeam{}}

      iex> update_tournament_team(scope, tournament_team, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tournament_team(tournament_team, attrs) do
    tournament_team
    |> TournamentTeam.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a tournament_team.

  ## Examples

      iex> delete_tournament_team(scope, tournament_team)
      {:ok, %TournamentTeam{}}

      iex> delete_tournament_team(scope, tournament_team)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tournament_team(tournament_team) do
    Repo.delete(tournament_team)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tournament_team changes.

  ## Examples

      iex> change_tournament_team(scope, tournament_team)
      %Ecto.Changeset{data: %TournamentTeam{}}

  """
  def change_tournament_team(tournament_team, attrs \\ %{}) do
    TournamentTeam.changeset(tournament_team, attrs)
  end

  alias JogoDoBicho.Tournaments.Stage
  alias JogoDoBicho.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any stage changes.

  The broadcasted messages match the pattern:

    * {:created, %Stage{}}
    * {:updated, %Stage{}}
    * {:deleted, %Stage{}}

  """
  def subscribe_stages(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(JogoDoBicho.PubSub, "user:#{key}:stages")
  end

  # defp broadcast_stage(%Scope{} = scope, message) do
  #   key = scope.user.id

  #   Phoenix.PubSub.broadcast(JogoDoBicho.PubSub, "user:#{key}:stages", message)
  # end

  @doc """
  Gets a single stage.

  Raises `Ecto.NoResultsError` if the Stage does not exist.

  ## Examples

      iex> get_stage!(scope, 123)
      %Stage{}

      iex> get_stage!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_stage!(%Scope{} = scope, id) do
    Repo.get_by!(Stage, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a stage.

  ## Examples

      iex> create_stage(scope, %{field: value})
      {:ok, %Stage{}}

      iex> create_stage(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_stage(attrs) do
    %Stage{}
    |> Stage.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a stage.

  ## Examples

      iex> update_stage(scope, stage, %{field: new_value})
      {:ok, %Stage{}}

      iex> update_stage(scope, stage, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_stage(%Stage{} = stage, attrs) do
    stage
    |> Stage.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a stage.

  ## Examples

      iex> delete_stage(scope, stage)
      {:ok, %Stage{}}

      iex> delete_stage(scope, stage)
      {:error, %Ecto.Changeset{}}

  """
  def delete_stage(%Stage{} = stage) do
    Repo.delete(stage)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking stage changes.

  ## Examples

      iex> change_stage(scope, stage)
      %Ecto.Changeset{data: %Stage{}}

  """
  def change_stage(%Stage{} = stage, attrs \\ %{}) do
    Stage.changeset(stage, attrs)
  end

  alias JogoDoBicho.Tournaments.Slot
  alias JogoDoBicho.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any slot changes.

  The broadcasted messages match the pattern:

    * {:created, %Slot{}}
    * {:updated, %Slot{}}
    * {:deleted, %Slot{}}

  """
  def subscribe_slots(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(JogoDoBicho.PubSub, "user:#{key}:slots")
  end

  # defp broadcast_slot(%Scope{} = scope, message) do
  #   key = scope.user.id

  #   Phoenix.PubSub.broadcast(JogoDoBicho.PubSub, "user:#{key}:slots", message)
  # end

  @doc """
  Returns the list of slots.

  ## Examples

      iex> list_slots(scope)
      [%Slot{}, ...]

  """
  def list_slots(%Scope{} = scope) do
    Repo.all_by(Slot, user_id: scope.user.id)
  end

  @doc """
  Gets a single slot.

  Raises `Ecto.NoResultsError` if the Slot does not exist.

  ## Examples

      iex> get_slot!(scope, 123)
      %Slot{}

      iex> get_slot!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_slot!(%Scope{} = scope, id) do
    Repo.get_by!(Slot, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a slot.

  ## Examples

      iex> create_slot(scope, %{field: value})
      {:ok, %Slot{}}

      iex> create_slot(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_slot(attrs) do
    %Slot{}
    |> Slot.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a slot.

  ## Examples

      iex> update_slot(scope, slot, %{field: new_value})
      {:ok, %Slot{}}

      iex> update_slot(scope, slot, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_slot(%Slot{} = slot, attrs) do
    slot
    |> Slot.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a slot.

  ## Examples

      iex> delete_slot(scope, slot)
      {:ok, %Slot{}}

      iex> delete_slot(scope, slot)
      {:error, %Ecto.Changeset{}}

  """
  def delete_slot(%Slot{} = slot) do
    Repo.delete(slot)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking slot changes.

  ## Examples

      iex> change_slot(scope, slot)
      %Ecto.Changeset{data: %Slot{}}

  """
  def change_slot(%Slot{} = slot, attrs \\ %{}) do
    Slot.changeset(slot, attrs)
  end

  alias JogoDoBicho.Tournaments.Match
  alias JogoDoBicho.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any match changes.

  The broadcasted messages match the pattern:

    * {:created, %Match{}}
    * {:updated, %Match{}}
    * {:deleted, %Match{}}

  """
  def subscribe_matches(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(JogoDoBicho.PubSub, "user:#{key}:matches")
  end

  defp broadcast_match(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(JogoDoBicho.PubSub, "user:#{key}:matches", message)
  end

  @doc """
  Returns the list of matches.

  ## Examples

      iex> list_matches(scope)
      [%Match{}, ...]

  """
  def list_matches(%Scope{} = scope) do
    Repo.all_by(Match, user_id: scope.user.id)
  end

  @doc """
  Gets a single match.

  Raises `Ecto.NoResultsError` if the Match does not exist.

  ## Examples

      iex> get_match!(scope, 123)
      %Match{}

      iex> get_match!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_match!(%Scope{} = scope, id) do
    Repo.get_by!(Match, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a match.

  ## Examples

      iex> create_match(scope, %{field: value})
      {:ok, %Match{}}

      iex> create_match(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_match(attrs) do
    %Match{}
    |> Match.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a match.

  ## Examples

      iex> update_match(scope, match, %{field: new_value})
      {:ok, %Match{}}

      iex> update_match(scope, match, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_match(%Match{} = match, attrs) do
    match
    |> Match.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a match.

  ## Examples

      iex> delete_match(scope, match)
      {:ok, %Match{}}

      iex> delete_match(scope, match)
      {:error, %Ecto.Changeset{}}

  """
  def delete_match(%Match{} = match) do
    Repo.delete(match)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking match changes.

  ## Examples

      iex> change_match(scope, match)
      %Ecto.Changeset{data: %Match{}}

  """
  def change_match(%Match{} = match, attrs \\ %{}) do
    Match.changeset(match, attrs)
  end

  def list_stages(%Tournament{id: tournament_id}) do
    Stage
    |> where([s], s.tournament_id == ^tournament_id)
    |> order_by([s], s.inserted_at)
    |> preload(matches: [:slot_a, :slot_b])
    |> Repo.all()
  end
end
