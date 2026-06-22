defmodule JogoDoBicho.MatchesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `JogoDoBicho.Matches` context.
  """

  @doc """
  Generate a match.
  """
  def match_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{

      })

    {:ok, match} = JogoDoBicho.Matches.create_match(scope, attrs)
    match
  end
end
