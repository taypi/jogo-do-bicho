defmodule JogoDoBicho.TournamentsTest do
  use JogoDoBicho.DataCase

  alias JogoDoBicho.Tournaments

  describe "tournaments" do
    alias JogoDoBicho.Tournaments.Tournament

    import JogoDoBicho.AccountsFixtures, only: [user_scope_fixture: 0]
    import JogoDoBicho.TournamentsFixtures

    @invalid_attrs %{" name": nil, " start_date": nil, " end_date": nil}

    test "list_tournaments/1 returns all scoped tournaments" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      tournament = tournament_fixture(scope)
      other_tournament = tournament_fixture(other_scope)
      assert Tournaments.list_tournaments(scope) == [tournament]
      assert Tournaments.list_tournaments(other_scope) == [other_tournament]
    end

    test "get_tournament!/2 returns the tournament with given id" do
      scope = user_scope_fixture()
      tournament = tournament_fixture(scope)
      other_scope = user_scope_fixture()
      assert Tournaments.get_tournament!(scope, tournament.id) == tournament

      assert_raise Ecto.NoResultsError, fn ->
        Tournaments.get_tournament!(other_scope, tournament.id)
      end
    end

    test "create_tournament/2 with valid data creates a tournament" do
      valid_attrs = %{
        " name": "some  name",
        " start_date": ~D[2026-06-20],
        " end_date": ~D[2026-06-20]
      }

      scope = user_scope_fixture()

      assert {:ok, %Tournament{} = tournament} = Tournaments.create_tournament(scope, valid_attrs)
      assert tournament.name == "some  name"
      assert tournament.start_date == ~D[2026-06-20]
      assert tournament.end_date == ~D[2026-06-20]
      assert tournament.user_id == scope.user.id
    end

    test "create_tournament/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Tournaments.create_tournament(scope, @invalid_attrs)
    end

    test "update_tournament/3 with valid data updates the tournament" do
      scope = user_scope_fixture()
      tournament = tournament_fixture(scope)

      update_attrs = %{
        " name": "some updated  name",
        " start_date": ~D[2026-06-21],
        " end_date": ~D[2026-06-21]
      }

      assert {:ok, %Tournament{} = tournament} =
               Tournaments.update_tournament(scope, tournament, update_attrs)

      assert tournament.name == "some updated  name"
      assert tournament.start_date == ~D[2026-06-21]
      assert tournament.end_date == ~D[2026-06-21]
    end

    test "update_tournament/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      tournament = tournament_fixture(scope)

      assert_raise MatchError, fn ->
        Tournaments.update_tournament(other_scope, tournament, %{})
      end
    end

    test "update_tournament/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      tournament = tournament_fixture(scope)

      assert {:error, %Ecto.Changeset{}} =
               Tournaments.update_tournament(scope, tournament, @invalid_attrs)

      assert tournament == Tournaments.get_tournament!(scope, tournament.id)
    end

    test "delete_tournament/2 deletes the tournament" do
      scope = user_scope_fixture()
      tournament = tournament_fixture(scope)
      assert {:ok, %Tournament{}} = Tournaments.delete_tournament(scope, tournament)

      assert_raise Ecto.NoResultsError, fn ->
        Tournaments.get_tournament!(scope, tournament.id)
      end
    end

    test "delete_tournament/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      tournament = tournament_fixture(scope)
      assert_raise MatchError, fn -> Tournaments.delete_tournament(other_scope, tournament) end
    end

    test "change_tournament/2 returns a tournament changeset" do
      scope = user_scope_fixture()
      tournament = tournament_fixture(scope)
      assert %Ecto.Changeset{} = Tournaments.change_tournament(scope, tournament)
    end
  end
end
