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
end
