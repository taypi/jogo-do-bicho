defmodule JogoDoBicho.Pools.Services.ValidateScope do
  alias JogoDoBicho.Pools.Pool
  alias JogoDoBicho.Accounts.Scope

  def call(%Scope{} = scope, %Pool{} = pool) do
    if Pool.owner?(pool, scope.user.id) do
      :ok
    else
      {:error, :not_found}
    end
  end
end
