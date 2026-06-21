defmodule JogoDoBicho.Tournaments do
  @moduledoc """
  The Tournaments context.
  """

  import Ecto.Query, warn: false
  alias JogoDoBicho.Repo

  alias JogoDoBicho.Tournaments.Tournament
  alias JogoDoBicho.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any tournament changes.

  The broadcasted messages match the pattern:

    * {:created, %Tournament{}}
    * {:updated, %Tournament{}}
    * {:deleted, %Tournament{}}

  """
  def subscribe_tournaments(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(JogoDoBicho.PubSub, "user:#{key}:tournaments")
  end

  defp broadcast_tournament(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(JogoDoBicho.PubSub, "user:#{key}:tournaments", message)
  end

  @doc """
  Returns the list of tournaments.

  ## Examples

      iex> list_tournaments(scope)
      [%Tournament{}, ...]

  """
  def list_tournaments(%Scope{} = scope) do
    Repo.all_by(Tournament, user_id: scope.user.id)
  end

  @doc """
  Gets a single tournament.

  Raises `Ecto.NoResultsError` if the Tournament does not exist.

  ## Examples

      iex> get_tournament!(scope, 123)
      %Tournament{}

      iex> get_tournament!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_tournament!(%Scope{} = scope, id) do
    Repo.get_by!(Tournament, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a tournament.

  ## Examples

      iex> create_tournament(scope, %{field: value})
      {:ok, %Tournament{}}

      iex> create_tournament(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tournament(%Scope{} = scope, attrs) do
    with {:ok, tournament = %Tournament{}} <-
           %Tournament{}
           |> Tournament.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast_tournament(scope, {:created, tournament})
      {:ok, tournament}
    end
  end

  @doc """
  Updates a tournament.

  ## Examples

      iex> update_tournament(scope, tournament, %{field: new_value})
      {:ok, %Tournament{}}

      iex> update_tournament(scope, tournament, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tournament(%Scope{} = scope, %Tournament{} = tournament, attrs) do
    true = tournament.user_id == scope.user.id

    with {:ok, tournament = %Tournament{}} <-
           tournament
           |> Tournament.changeset(attrs, scope)
           |> Repo.update() do
      broadcast_tournament(scope, {:updated, tournament})
      {:ok, tournament}
    end
  end

  @doc """
  Deletes a tournament.

  ## Examples

      iex> delete_tournament(scope, tournament)
      {:ok, %Tournament{}}

      iex> delete_tournament(scope, tournament)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tournament(%Scope{} = scope, %Tournament{} = tournament) do
    true = tournament.user_id == scope.user.id

    with {:ok, tournament = %Tournament{}} <-
           Repo.delete(tournament) do
      broadcast_tournament(scope, {:deleted, tournament})
      {:ok, tournament}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tournament changes.

  ## Examples

      iex> change_tournament(scope, tournament)
      %Ecto.Changeset{data: %Tournament{}}

  """
  def change_tournament(%Scope{} = scope, %Tournament{} = tournament, attrs \\ %{}) do
    true = tournament.user_id == scope.user.id

    Tournament.changeset(tournament, attrs, scope)
  end
end
