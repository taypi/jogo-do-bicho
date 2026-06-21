defmodule JogoDoBicho.Pools.Services.ValidateScope do
  alias JogoDoBicho.Pools.Pool
  alias JogoDoBicho.Accounts.Scope

  def call(%Scope{} = scope, %Pool{} = pool) do
    if pool.owner_id == scope.user.id do
      :ok
    else
      {:error, :not_found}
    end
  end
end
