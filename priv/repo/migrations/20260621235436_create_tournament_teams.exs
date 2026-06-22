defmodule JogoDoBicho.Repo.Migrations.CreateTournamentTeams do
  use Ecto.Migration

  def change do
    create table(:tournament_teams, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :tournament_id, references(:tournaments, on_delete: :delete_all, type: :binary_id)
      add :team_id, references(:teams, on_delete: :delete_all, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:tournament_teams, [:tournament_id])
    create index(:tournament_teams, [:team_id])

    create unique_index(:tournament_teams, [:tournament_id, :team_id])
  end
end
