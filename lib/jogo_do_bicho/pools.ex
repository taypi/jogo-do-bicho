defmodule JogoDoBicho.Pools do
  @moduledoc """
  The Pools context.
  """

  import Ecto.Query, warn: false
  alias JogoDoBicho.Repo

  alias JogoDoBicho.Pools.Pool
  alias JogoDoBicho.Accounts.Scope

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
end
