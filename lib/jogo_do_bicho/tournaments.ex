defmodule JogoDoBicho.Tournaments do
  @moduledoc """
  The Tournaments context.
  """

  import Ecto.Query, warn: false
  alias JogoDoBicho.Repo

  alias JogoDoBicho.Tournaments.Tournament

  def list_tournaments do
    Repo.all(Tournament)
  end

  def get_tournament!(id) do
    Repo.get!(Tournament, id)
  end

  def create_tournament(attrs \\ %{}) do
    Repo.insert(Tournament.changeset(attrs))
  end

  def update_tournament(%Tournament{} = tournament, attrs) do
    tournament
    |> Tournament.changeset(attrs)
    |> Repo.update()
  end

  def delete_tournament(%Tournament{} = tournament) do
    Repo.delete(tournament)
  end

  def change_tournament(%Tournament{} = tournament, attrs \\ %{}) do
    Tournament.changeset(tournament, attrs)
  end

  def active_tournaments(date \\ Date.utc_today()) do
  Tournament
  |> where(
    [t],
    t.start_date <= ^date and
      t.end_date >= ^date
  )
  |> Repo.all()
end
end
