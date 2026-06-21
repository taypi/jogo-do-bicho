defmodule JogoDoBicho.TeamsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `JogoDoBicho.Teams` context.
  """

  @doc """
  Generate a team.
  """
  def team_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        code: "some code",
        name: "some name"
      })

    {:ok, team} = JogoDoBicho.Teams.create_team(scope, attrs)
    team
  end
end
