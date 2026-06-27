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

  describe "pool_members" do
    alias JogoDoBicho.Pools.PoolMember

    import JogoDoBicho.AccountsFixtures, only: [user_scope_fixture: 0]
    import JogoDoBicho.PoolsFixtures

    @invalid_attrs %{}

    test "list_pool_members/1 returns all scoped pool_members" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      pool_member = pool_member_fixture(scope)
      other_pool_member = pool_member_fixture(other_scope)
      assert Pools.list_pool_members(scope) == [pool_member]
      assert Pools.list_pool_members(other_scope) == [other_pool_member]
    end

    test "get_pool_member!/2 returns the pool_member with given id" do
      scope = user_scope_fixture()
      pool_member = pool_member_fixture(scope)
      other_scope = user_scope_fixture()
      assert Pools.get_pool_member!(scope, pool_member.id) == pool_member

      assert_raise Ecto.NoResultsError, fn ->
        Pools.get_pool_member!(other_scope, pool_member.id)
      end
    end

    test "create_pool_member/2 with valid data creates a pool_member" do
      valid_attrs = %{}
      scope = user_scope_fixture()

      assert {:ok, %PoolMember{} = pool_member} = Pools.create_pool_member(scope, valid_attrs)
      assert pool_member.user_id == scope.user.id
    end

    test "create_pool_member/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Pools.create_pool_member(scope, @invalid_attrs)
    end

    test "update_pool_member/3 with valid data updates the pool_member" do
      scope = user_scope_fixture()
      pool_member = pool_member_fixture(scope)
      update_attrs = %{}

      assert {:ok, %PoolMember{} = pool_member} =
               Pools.update_pool_member(scope, pool_member, update_attrs)
    end

    test "update_pool_member/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      pool_member = pool_member_fixture(scope)

      assert_raise MatchError, fn ->
        Pools.update_pool_member(other_scope, pool_member, %{})
      end
    end

    test "update_pool_member/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      pool_member = pool_member_fixture(scope)

      assert {:error, %Ecto.Changeset{}} =
               Pools.update_pool_member(scope, pool_member, @invalid_attrs)

      assert pool_member == Pools.get_pool_member!(scope, pool_member.id)
    end

    test "delete_pool_member/2 deletes the pool_member" do
      scope = user_scope_fixture()
      pool_member = pool_member_fixture(scope)
      assert {:ok, %PoolMember{}} = Pools.delete_pool_member(scope, pool_member)
      assert_raise Ecto.NoResultsError, fn -> Pools.get_pool_member!(scope, pool_member.id) end
    end

    test "delete_pool_member/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      pool_member = pool_member_fixture(scope)
      assert_raise MatchError, fn -> Pools.delete_pool_member(other_scope, pool_member) end
    end

    test "change_pool_member/2 returns a pool_member changeset" do
      scope = user_scope_fixture()
      pool_member = pool_member_fixture(scope)
      assert %Ecto.Changeset{} = Pools.change_pool_member(scope, pool_member)
    end
  end
end
