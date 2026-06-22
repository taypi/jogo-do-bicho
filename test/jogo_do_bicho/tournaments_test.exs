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

  describe "tournament_teams" do
    alias JogoDoBicho.Tournaments.TournamentTeam

    import JogoDoBicho.AccountsFixtures, only: [user_scope_fixture: 0]
    import JogoDoBicho.TournamentsFixtures

    @invalid_attrs %{}

    test "list_tournament_teams/1 returns all scoped tournament_teams" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      tournament_team = tournament_team_fixture(scope)
      other_tournament_team = tournament_team_fixture(other_scope)
      assert Tournaments.list_tournament_teams(scope) == [tournament_team]
      assert Tournaments.list_tournament_teams(other_scope) == [other_tournament_team]
    end

    test "get_tournament_team!/2 returns the tournament_team with given id" do
      scope = user_scope_fixture()
      tournament_team = tournament_team_fixture(scope)
      other_scope = user_scope_fixture()
      assert Tournaments.get_tournament_team!(scope, tournament_team.id) == tournament_team
      assert_raise Ecto.NoResultsError, fn -> Tournaments.get_tournament_team!(other_scope, tournament_team.id) end
    end

    test "create_tournament_team/2 with valid data creates a tournament_team" do
      valid_attrs = %{}
      scope = user_scope_fixture()

      assert {:ok, %TournamentTeam{} = tournament_team} = Tournaments.create_tournament_team(scope, valid_attrs)
      assert tournament_team.user_id == scope.user.id
    end

    test "create_tournament_team/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Tournaments.create_tournament_team(scope, @invalid_attrs)
    end

    test "update_tournament_team/3 with valid data updates the tournament_team" do
      scope = user_scope_fixture()
      tournament_team = tournament_team_fixture(scope)
      update_attrs = %{}

      assert {:ok, %TournamentTeam{} = tournament_team} = Tournaments.update_tournament_team(scope, tournament_team, update_attrs)
    end

    test "update_tournament_team/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      tournament_team = tournament_team_fixture(scope)

      assert_raise MatchError, fn ->
        Tournaments.update_tournament_team(other_scope, tournament_team, %{})
      end
    end

    test "update_tournament_team/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      tournament_team = tournament_team_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Tournaments.update_tournament_team(scope, tournament_team, @invalid_attrs)
      assert tournament_team == Tournaments.get_tournament_team!(scope, tournament_team.id)
    end

    test "delete_tournament_team/2 deletes the tournament_team" do
      scope = user_scope_fixture()
      tournament_team = tournament_team_fixture(scope)
      assert {:ok, %TournamentTeam{}} = Tournaments.delete_tournament_team(scope, tournament_team)
      assert_raise Ecto.NoResultsError, fn -> Tournaments.get_tournament_team!(scope, tournament_team.id) end
    end

    test "delete_tournament_team/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      tournament_team = tournament_team_fixture(scope)
      assert_raise MatchError, fn -> Tournaments.delete_tournament_team(other_scope, tournament_team) end
    end

    test "change_tournament_team/2 returns a tournament_team changeset" do
      scope = user_scope_fixture()
      tournament_team = tournament_team_fixture(scope)
      assert %Ecto.Changeset{} = Tournaments.change_tournament_team(scope, tournament_team)
    end
  end

  describe "stages" do
    alias JogoDoBicho.Tournaments.Stage

    import JogoDoBicho.AccountsFixtures, only: [user_scope_fixture: 0]
    import JogoDoBicho.TournamentsFixtures

    @invalid_attrs %{name: nil, type: nil}

    test "list_stages/1 returns all scoped stages" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      stage = stage_fixture(scope)
      other_stage = stage_fixture(other_scope)
      assert Tournaments.list_stages(scope) == [stage]
      assert Tournaments.list_stages(other_scope) == [other_stage]
    end

    test "get_stage!/2 returns the stage with given id" do
      scope = user_scope_fixture()
      stage = stage_fixture(scope)
      other_scope = user_scope_fixture()
      assert Tournaments.get_stage!(scope, stage.id) == stage
      assert_raise Ecto.NoResultsError, fn -> Tournaments.get_stage!(other_scope, stage.id) end
    end

    test "create_stage/2 with valid data creates a stage" do
      valid_attrs = %{name: "some name", type: "some type"}
      scope = user_scope_fixture()

      assert {:ok, %Stage{} = stage} = Tournaments.create_stage(scope, valid_attrs)
      assert stage.name == "some name"
      assert stage.type == "some type"
      assert stage.user_id == scope.user.id
    end

    test "create_stage/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Tournaments.create_stage(scope, @invalid_attrs)
    end

    test "update_stage/3 with valid data updates the stage" do
      scope = user_scope_fixture()
      stage = stage_fixture(scope)
      update_attrs = %{name: "some updated name", type: "some updated type"}

      assert {:ok, %Stage{} = stage} = Tournaments.update_stage(scope, stage, update_attrs)
      assert stage.name == "some updated name"
      assert stage.type == "some updated type"
    end

    test "update_stage/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      stage = stage_fixture(scope)

      assert_raise MatchError, fn ->
        Tournaments.update_stage(other_scope, stage, %{})
      end
    end

    test "update_stage/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      stage = stage_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Tournaments.update_stage(scope, stage, @invalid_attrs)
      assert stage == Tournaments.get_stage!(scope, stage.id)
    end

    test "delete_stage/2 deletes the stage" do
      scope = user_scope_fixture()
      stage = stage_fixture(scope)
      assert {:ok, %Stage{}} = Tournaments.delete_stage(scope, stage)
      assert_raise Ecto.NoResultsError, fn -> Tournaments.get_stage!(scope, stage.id) end
    end

    test "delete_stage/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      stage = stage_fixture(scope)
      assert_raise MatchError, fn -> Tournaments.delete_stage(other_scope, stage) end
    end

    test "change_stage/2 returns a stage changeset" do
      scope = user_scope_fixture()
      stage = stage_fixture(scope)
      assert %Ecto.Changeset{} = Tournaments.change_stage(scope, stage)
    end
  end
end
