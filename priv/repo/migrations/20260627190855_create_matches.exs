defmodule JogoDoBicho.Repo.Migrations.CreateMatches do
  use Ecto.Migration

  def change do
    create table(:matches, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :kickoff_at, :utc_datetime
      add :score_a, :integer
      add :score_b, :integer
      add :stage_id, references(:stages, on_delete: :delete_all, type: :binary_id), null: false
      add :slot_a_id, references(:slots, on_delete: :nothing, type: :binary_id), null: false
      add :slot_b_id, references(:slots, on_delete: :nothing, type: :binary_id), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:matches, [:stage_id])
    create index(:matches, [:slot_a_id])
    create index(:matches, [:slot_b_id])
  end
end
