defmodule JogoDoBicho.Pools do
  @moduledoc """
  The Pools context.
  """

  import Ecto.Query, warn: false
  alias JogoDoBicho.Repo

  alias JogoDoBicho.Pools.Pool
  alias JogoDoBicho.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any pool changes.

  The broadcasted messages match the pattern:

    * {:created, %Pool{}}
    * {:updated, %Pool{}}
    * {:deleted, %Pool{}}

  """
  def subscribe_pools(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(JogoDoBicho.PubSub, "user:#{key}:pools")
  end

  defp broadcast_pool(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(JogoDoBicho.PubSub, "user:#{key}:pools", message)
  end

  @doc """
  Returns the list of pools.

  ## Examples

      iex> list_pools(scope)
      [%Pool{}, ...]

  """
  def list_pools(%Scope{} = scope) do
    Repo.all_by(Pool, user_id: scope.user.id)
  end

  @doc """
  Gets a single pool.

  Raises `Ecto.NoResultsError` if the Pool does not exist.

  ## Examples

      iex> get_pool!(scope, 123)
      %Pool{}

      iex> get_pool!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_pool!(%Scope{} = scope, id) do
    Repo.get_by!(Pool, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a pool.

  ## Examples

      iex> create_pool(scope, %{field: value})
      {:ok, %Pool{}}

      iex> create_pool(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_pool(%Scope{} = scope, attrs) do
    with {:ok, pool = %Pool{}} <-
           %Pool{}
           |> Pool.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast_pool(scope, {:created, pool})
      {:ok, pool}
    end
  end

  @doc """
  Updates a pool.

  ## Examples

      iex> update_pool(scope, pool, %{field: new_value})
      {:ok, %Pool{}}

      iex> update_pool(scope, pool, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_pool(%Scope{} = scope, %Pool{} = pool, attrs) do
    true = pool.user_id == scope.user.id

    with {:ok, pool = %Pool{}} <-
           pool
           |> Pool.changeset(attrs, scope)
           |> Repo.update() do
      broadcast_pool(scope, {:updated, pool})
      {:ok, pool}
    end
  end

  @doc """
  Deletes a pool.

  ## Examples

      iex> delete_pool(scope, pool)
      {:ok, %Pool{}}

      iex> delete_pool(scope, pool)
      {:error, %Ecto.Changeset{}}

  """
  def delete_pool(%Scope{} = scope, %Pool{} = pool) do
    true = pool.user_id == scope.user.id

    with {:ok, pool = %Pool{}} <-
           Repo.delete(pool) do
      broadcast_pool(scope, {:deleted, pool})
      {:ok, pool}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking pool changes.

  ## Examples

      iex> change_pool(scope, pool)
      %Ecto.Changeset{data: %Pool{}}

  """
  def change_pool(%Scope{} = scope, %Pool{} = pool, attrs \\ %{}) do
    true = pool.user_id == scope.user.id

    Pool.changeset(pool, attrs, scope)
  end
end
