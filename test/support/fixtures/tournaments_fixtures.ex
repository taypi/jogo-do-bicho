defmodule JogoDoBicho.TournamentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `JogoDoBicho.Tournaments` context.
  """

  @doc """
  Generate a tournament.
  """
  def tournament_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        end_date: ~D[2026-06-20],
        name: "some  name",
        start_date: ~D[2026-06-20]
      })

    {:ok, tournament} = JogoDoBicho.Tournaments.create_tournament(scope, attrs)
    tournament
  end

  @doc """
  Generate a tournament_team.
  """
  def tournament_team_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{

      })

    {:ok, tournament_team} = JogoDoBicho.Tournaments.create_tournament_team(scope, attrs)
    tournament_team
  end

  @doc """
  Generate a stage.
  """
  def stage_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        name: "some name",
        type: "some type"
      })

    {:ok, stage} = JogoDoBicho.Tournaments.create_stage(scope, attrs)
    stage
  end

  @doc """
  Generate a slot.
  """
  def slot_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        kind: "some kind",
        source_match_id: "7488a646-e31f-11e4-aace-600308960662",
        source_position: 42
      })

    {:ok, slot} = JogoDoBicho.Tournaments.create_slot(scope, attrs)
    slot
  end

  @doc """
  Generate a match.
  """
  def match_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        kickoff_at: ~U[2026-06-26 19:08:00Z],
        score_a: 42,
        score_b: 42
      })

    {:ok, match} = JogoDoBicho.Tournaments.create_match(scope, attrs)
    match
  end
end
