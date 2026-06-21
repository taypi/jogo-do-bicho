defmodule JogoDoBicho.Pools.Services.DeletePool do
  alias JogoDoBicho.Pools.Services.ValidateScope
  alias JogoDoBicho.Repo
  alias JogoDoBicho.Pools.Pool
  alias JogoDoBicho.Accounts.Scope

  def call(%Scope{} = scope, %Pool{} = pool) do
    with :ok <- ValidateScope.call(scope, pool) do
      Repo.delete(pool)
    end
  end
end
