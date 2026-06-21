defmodule JogoDoBicho.Pools.Services.UpdatePool do
  alias JogoDoBicho.Pools.Services.ValidateScope
  alias JogoDoBicho.Repo
  alias JogoDoBicho.Pools.Pool
  alias JogoDoBicho.Accounts.Scope

  def call(%Scope{} = scope, %Pool{} = pool, attrs) do
    with :ok <- ValidateScope.call(scope, pool) do
      pool
      |> Pool.update_changeset(attrs)
      |> Repo.update()
    end
  end
end
