defmodule JogoDoBicho.Repo.Migrations.CreateStages do
  use Ecto.Migration

  def change do
    create table(:stages, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :type, :string, null: false
      add :tournament_id, references(:tournaments, on_delete: :delete_all, type: :binary_id), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:stages, [:tournament_id])
  end
end
