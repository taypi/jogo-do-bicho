defmodule JogoDoBicho.Repo.Migrations.CreateSlots do
  use Ecto.Migration

  def change do
    create table(:slots, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :source_match_id, :binary_id
      add :type, :string, null: false
      add :source_position, :integer
      add :tournament_id, references(:tournaments, on_delete: :delete_all, type: :binary_id), null: false
      add :team_id, references(:teams, on_delete: :nothing, type: :binary_id)
      add :source_stage_id, references(:stages, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:slots, [:tournament_id])
    create index(:slots, [:team_id])
    create index(:slots, [:source_stage_id])
    create index(:slots, [:source_match_id])
  end
end
