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

  @doc """
  Generate a pool_member.
  """
  def pool_member_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{})

    {:ok, pool_member} = JogoDoBicho.Pools.create_pool_member(scope, attrs)
    pool_member
  end
end
