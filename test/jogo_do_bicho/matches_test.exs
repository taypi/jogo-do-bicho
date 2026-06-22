defmodule JogoDoBicho.MatchesTest do
  use JogoDoBicho.DataCase

  alias JogoDoBicho.Matches

  describe "matches" do
    alias JogoDoBicho.Matches.Match

    import JogoDoBicho.AccountsFixtures, only: [user_scope_fixture: 0]
    import JogoDoBicho.MatchesFixtures

    @invalid_attrs %{}

    test "list_matches/1 returns all scoped matches" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      match = match_fixture(scope)
      other_match = match_fixture(other_scope)
      assert Matches.list_matches(scope) == [match]
      assert Matches.list_matches(other_scope) == [other_match]
    end

    test "get_match!/2 returns the match with given id" do
      scope = user_scope_fixture()
      match = match_fixture(scope)
      other_scope = user_scope_fixture()
      assert Matches.get_match!(scope, match.id) == match
      assert_raise Ecto.NoResultsError, fn -> Matches.get_match!(other_scope, match.id) end
    end

    test "create_match/2 with valid data creates a match" do
      valid_attrs = %{}
      scope = user_scope_fixture()

      assert {:ok, %Match{} = match} = Matches.create_match(scope, valid_attrs)
      assert match.user_id == scope.user.id
    end

    test "create_match/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Matches.create_match(scope, @invalid_attrs)
    end

    test "update_match/3 with valid data updates the match" do
      scope = user_scope_fixture()
      match = match_fixture(scope)
      update_attrs = %{}

      assert {:ok, %Match{} = match} = Matches.update_match(scope, match, update_attrs)
    end

    test "update_match/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      match = match_fixture(scope)

      assert_raise MatchError, fn ->
        Matches.update_match(other_scope, match, %{})
      end
    end

    test "update_match/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      match = match_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Matches.update_match(scope, match, @invalid_attrs)
      assert match == Matches.get_match!(scope, match.id)
    end

    test "delete_match/2 deletes the match" do
      scope = user_scope_fixture()
      match = match_fixture(scope)
      assert {:ok, %Match{}} = Matches.delete_match(scope, match)
      assert_raise Ecto.NoResultsError, fn -> Matches.get_match!(scope, match.id) end
    end

    test "delete_match/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      match = match_fixture(scope)
      assert_raise MatchError, fn -> Matches.delete_match(other_scope, match) end
    end

    test "change_match/2 returns a match changeset" do
      scope = user_scope_fixture()
      match = match_fixture(scope)
      assert %Ecto.Changeset{} = Matches.change_match(scope, match)
    end
  end
end
