defmodule JogoDoBicho.PoolsTest do
  use JogoDoBicho.DataCase

  alias JogoDoBicho.Pools

  describe "pools" do
    alias JogoDoBicho.Pools.Pool

    import JogoDoBicho.AccountsFixtures, only: [user_scope_fixture: 0]
    import JogoDoBicho.PoolsFixtures

    @invalid_attrs %{name: nil}

    test "list_pools/1 returns all scoped pools" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      pool = pool_fixture(scope)
      other_pool = pool_fixture(other_scope)
      assert Pools.list_pools(scope) == [pool]
      assert Pools.list_pools(other_scope) == [other_pool]
    end

    test "get_pool!/2 returns the pool with given id" do
      scope = user_scope_fixture()
      pool = pool_fixture(scope)
      other_scope = user_scope_fixture()
      assert Pools.get_pool!(scope, pool.id) == pool
      assert_raise Ecto.NoResultsError, fn -> Pools.get_pool!(other_scope, pool.id) end
    end

    test "create_pool/2 with valid data creates a pool" do
      valid_attrs = %{name: "some name"}
      scope = user_scope_fixture()

      assert {:ok, %Pool{} = pool} = Pools.create_pool(scope, valid_attrs)
      assert pool.name == "some name"
      assert pool.user_id == scope.user.id
    end

    test "create_pool/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Pools.create_pool(scope, @invalid_attrs)
    end

    test "update_pool/3 with valid data updates the pool" do
      scope = user_scope_fixture()
      pool = pool_fixture(scope)
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Pool{} = pool} = Pools.update_pool(scope, pool, update_attrs)
      assert pool.name == "some updated name"
    end

    test "update_pool/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      pool = pool_fixture(scope)

      assert_raise MatchError, fn ->
        Pools.update_pool(other_scope, pool, %{})
      end
    end

    test "update_pool/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      pool = pool_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Pools.update_pool(scope, pool, @invalid_attrs)
      assert pool == Pools.get_pool!(scope, pool.id)
    end

    test "delete_pool/2 deletes the pool" do
      scope = user_scope_fixture()
      pool = pool_fixture(scope)
      assert {:ok, %Pool{}} = Pools.delete_pool(scope, pool)
      assert_raise Ecto.NoResultsError, fn -> Pools.get_pool!(scope, pool.id) end
    end

    test "delete_pool/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      pool = pool_fixture(scope)
      assert_raise MatchError, fn -> Pools.delete_pool(other_scope, pool) end
    end

    test "change_pool/2 returns a pool changeset" do
      scope = user_scope_fixture()
      pool = pool_fixture(scope)
      assert %Ecto.Changeset{} = Pools.change_pool(scope, pool)
    end
  end
end
