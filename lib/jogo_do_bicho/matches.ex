defmodule JogoDoBicho.Matches do
  @moduledoc """
  The Matches context.
  """

  import Ecto.Query, warn: false
  alias JogoDoBicho.Repo

  alias JogoDoBicho.Matches.Match
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
  def create_match(%Scope{} = scope, attrs) do
    with {:ok, match = %Match{}} <-
           %Match{}
           |> Match.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast_match(scope, {:created, match})
      {:ok, match}
    end
  end

  @doc """
  Updates a match.

  ## Examples

      iex> update_match(scope, match, %{field: new_value})
      {:ok, %Match{}}

      iex> update_match(scope, match, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_match(%Scope{} = scope, %Match{} = match, attrs) do
    true = match.user_id == scope.user.id

    with {:ok, match = %Match{}} <-
           match
           |> Match.changeset(attrs, scope)
           |> Repo.update() do
      broadcast_match(scope, {:updated, match})
      {:ok, match}
    end
  end

  @doc """
  Deletes a match.

  ## Examples

      iex> delete_match(scope, match)
      {:ok, %Match{}}

      iex> delete_match(scope, match)
      {:error, %Ecto.Changeset{}}

  """
  def delete_match(%Scope{} = scope, %Match{} = match) do
    true = match.user_id == scope.user.id

    with {:ok, match = %Match{}} <-
           Repo.delete(match) do
      broadcast_match(scope, {:deleted, match})
      {:ok, match}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking match changes.

  ## Examples

      iex> change_match(scope, match)
      %Ecto.Changeset{data: %Match{}}

  """
  def change_match(%Scope{} = scope, %Match{} = match, attrs \\ %{}) do
    true = match.user_id == scope.user.id

    Match.changeset(match, attrs, scope)
  end
end
