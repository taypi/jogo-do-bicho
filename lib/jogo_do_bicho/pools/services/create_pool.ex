defmodule JogoDoBicho.Pools.Services.CreatePool do
  alias JogoDoBicho.Repo
  alias JogoDoBicho.Pools.Pool
  alias JogoDoBicho.Pools.PoolMember
  alias JogoDoBicho.Accounts.Scope

  def call(%Scope{} = scope, attrs) do
    Repo.transaction(fn ->
      with {:ok, pool} <- do_create_pool(scope, attrs),
        {:ok, _pool_member} <- do_create_pool_member(scope, pool) do

        pool
      end
    end)
  end

  defp do_create_pool(%Scope{} = scope, attrs) do
    attrs
    |> Pool.changeset(scope)
    |> Repo.insert()
  end

  defp do_create_pool_member(%Scope{} = scope, %Pool{} = pool) do
    Repo.insert(PoolMember.changeset(%{
      pool_id: pool.id,
      user_id: scope.user.id
    }))
  end
end
