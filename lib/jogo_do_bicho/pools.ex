defmodule JogoDoBicho.Pools do
  @moduledoc """
  The Pools context.
  """

  import Ecto.Query, warn: false
  alias JogoDoBicho.Repo

  alias JogoDoBicho.Pools.Pool
  alias JogoDoBicho.Accounts.Scope
  alias JogoDoBicho.Pools.PoolMember
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
    Repo.transaction(fn ->
      {:ok, pool} =
        attrs
        |> Pool.changeset(scope)
        |> Repo.insert()

      PoolMember.changeset(%{
        pool_id: pool.id,
        user_id: scope.user.id
      })
      |> Repo.insert!()

      pool
    end)
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

  def join_pool(%Scope{} = scope, invite_token) do
    Repo.transaction(fn ->
      pool = Repo.get_by!(Pool, invite_token: invite_token)

      PoolMember.changeset(%{
        pool_id: pool.id,
        user_id: scope.user.id
      })
      |> Repo.insert!()

      pool
    end)
  end

  def get_pool_by_invite_token!(invite_token) do
    Repo.get_by!(Pool, invite_token: invite_token)
  end

  def list_user_pools(%Scope{} = scope) do
    Pool
    |> join(:inner, [p], pm in PoolMember, on: pm.pool_id == p.id)
    |> where([_p, pm], pm.user_id == ^scope.user.id)
    |> Repo.all()
  end

  def list_pool_members(%Pool{} = pool) do
    PoolMember
    |> where([pm], pm.pool_id == ^pool.id)
    |> preload(:user)
    |> Repo.all()
  end

  @doc """
  Subscribes to scoped notifications about any pool_member changes.

  The broadcasted messages match the pattern:

    * {:created, %PoolMember{}}
    * {:updated, %PoolMember{}}
    * {:deleted, %PoolMember{}}

  """
  def subscribe_pool_members(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(JogoDoBicho.PubSub, "user:#{key}:pool_members")
  end

  defp broadcast_pool_member(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(JogoDoBicho.PubSub, "user:#{key}:pool_members", message)
  end

  @doc """
  Returns the list of pool_members.

  ## Examples

      iex> list_pool_members(scope)
      [%PoolMember{}, ...]

  """
  def list_pool_members(%Scope{} = scope) do
    Repo.all_by(PoolMember, user_id: scope.user.id)
  end

  @doc """
  Gets a single pool_member.

  Raises `Ecto.NoResultsError` if the Pool member does not exist.

  ## Examples

      iex> get_pool_member!(scope, 123)
      %PoolMember{}

      iex> get_pool_member!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_pool_member!(%Scope{} = scope, id) do
    Repo.get_by!(PoolMember, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a pool_member.

  ## Examples

      iex> create_pool_member(scope, %{field: value})
      {:ok, %PoolMember{}}

      iex> create_pool_member(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_pool_member(%Scope{} = scope, attrs) do
    with {:ok, pool_member = %PoolMember{}} <-
           %PoolMember{}
           |> PoolMember.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast_pool_member(scope, {:created, pool_member})
      {:ok, pool_member}
    end
  end

  @doc """
  Updates a pool_member.

  ## Examples

      iex> update_pool_member(scope, pool_member, %{field: new_value})
      {:ok, %PoolMember{}}

      iex> update_pool_member(scope, pool_member, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_pool_member(%Scope{} = scope, %PoolMember{} = pool_member, attrs) do
    true = pool_member.user_id == scope.user.id

    with {:ok, pool_member = %PoolMember{}} <-
           pool_member
           |> PoolMember.changeset(attrs, scope)
           |> Repo.update() do
      broadcast_pool_member(scope, {:updated, pool_member})
      {:ok, pool_member}
    end
  end

  @doc """
  Deletes a pool_member.

  ## Examples

      iex> delete_pool_member(scope, pool_member)
      {:ok, %PoolMember{}}

      iex> delete_pool_member(scope, pool_member)
      {:error, %Ecto.Changeset{}}

  """
  def delete_pool_member(%Scope{} = scope, %PoolMember{} = pool_member) do
    true = pool_member.user_id == scope.user.id

    with {:ok, pool_member = %PoolMember{}} <-
           Repo.delete(pool_member) do
      broadcast_pool_member(scope, {:deleted, pool_member})
      {:ok, pool_member}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking pool_member changes.

  ## Examples

      iex> change_pool_member(scope, pool_member)
      %Ecto.Changeset{data: %PoolMember{}}

  """
  def change_pool_member(%Scope{} = scope, %PoolMember{} = pool_member, attrs \\ %{}) do
    true = pool_member.user_id == scope.user.id

    PoolMember.changeset(pool_member, attrs, scope)
  end
end
