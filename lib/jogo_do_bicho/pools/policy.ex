defmodule JogoDoBicho.Pools.Policy do
  import Ecto.Query

  alias JogoDoBicho.Accounts.Scope
  alias JogoDoBicho.Pools.Pool
  alias JogoDoBicho.Pools.PoolMember

  def scope(query \\ Pool, %Scope{} = scope) do
    query
    |> join(:inner, [p], pm in PoolMember, on: pm.pool_id == p.id)
    |> where([_p, pm], pm.user_id == ^scope.user.id)
  end
end
