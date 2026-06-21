defmodule JogoDoBicho.Pools do
  @moduledoc """
  The Pools context.
  """

  import Ecto.Query, warn: false

  alias JogoDoBicho.Pools.Services.DeletePool
  alias JogoDoBicho.Repo
  alias JogoDoBicho.Pools.Pool
  alias JogoDoBicho.Pools.PoolMember
  alias JogoDoBicho.Pools.Services.CreatePool
  alias JogoDoBicho.Pools.Services.UpdatePool
  alias JogoDoBicho.Accounts.Scope

  alias Phoenix.PubSub

  def list_pools(%Scope{} = scope) do
    scope
    |> Pool.scope()
    |> Repo.all()
  end

  def get_pool!(%Scope{} = scope, id) do
    scope
    |> Pool.scope()
    |> Repo.get!(id)
  end

  def get_pool_by_invite_token!(%Scope{} = scope, invite_token) do
    scope
    |> Pool.scope()
    |> Repo.get_by!(invite_token: invite_token)
  end

  def change_pool(%Scope{} = scope, %Pool{} = pool, attrs \\ %{}) do
    Pool.changeset(pool, attrs, scope)
  end

  def create_pool(%Scope{} = scope, attrs) do
    with {:ok, pool} <- CreatePool.call(scope, attrs) do
      broadcast_all(scope, pool, {:created, pool})

      {:ok, pool}
    end
  end

  def update_pool(%Scope{} = scope, %Pool{} = pool, attrs) do
    with {:ok, pool} <- UpdatePool.call(scope, pool, attrs) do
      broadcast_all(scope, pool, {:updated, pool})

      {:ok, pool}
    end
  end

  def delete_pool(%Scope{} = scope, %Pool{} = pool) do
    with {:ok, pool} <- DeletePool.call(scope, pool) do
      broadcast_all(scope, pool, {:deleted, pool})

      {:ok, pool}
    end
  end

  def join_pool(%Scope{} = scope, invite_token) do
    pool = Repo.get_by!(Pool, invite_token: invite_token)

    with {:ok, _} <- Repo.insert(PoolMember.changeset(%{pool_id: pool.id, user_id: scope.user.id})) do
      {:ok, pool}
    end
  end

  def subscribe_pools(%Scope{} = scope) do
    PubSub.subscribe(JogoDoBicho.PubSub, user_topic(scope))
  end

  def subscribe_pool(%Pool{} = pool) do
    PubSub.subscribe(JogoDoBicho.PubSub, pool_topic(pool))
  end

  defp broadcast_pool(%Pool{} = pool, message) do
    PubSub.broadcast(JogoDoBicho.PubSub, pool_topic(pool), message)
  end

  defp broadcast_user(%Scope{} = scope, message) do
    PubSub.broadcast(JogoDoBicho.PubSub, user_topic(scope), message)
  end

  defp broadcast_all(%Scope{} = scope, %Pool{} = pool, message) do
    broadcast_pool(pool, message)
    broadcast_user(scope, message)
  end

  defp pool_topic(%Pool{} = pool), do: "pool:#{pool.id}"
  defp user_topic(%Scope{} = scope), do: "user:#{scope.user.id}"
end
