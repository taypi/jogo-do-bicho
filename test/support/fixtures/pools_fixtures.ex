defmodule JogoDoBicho.PoolsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `JogoDoBicho.Pools` context.
  """

  @doc """
  Generate a pool.
  """
  def pool_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        name: "some name"
      })

    {:ok, pool} = JogoDoBicho.Pools.create_pool(scope, attrs)
    pool
  end
end
