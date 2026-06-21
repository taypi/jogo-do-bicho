defmodule JogoDoBicho.Repo.Migrations.CreatePools do
  use Ecto.Migration

  def change do
    create table(:pools, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :name, :string, null: false
      add :invite_token, :string, null: false

      add :owner_id, references(:users, type: :binary_id, on_delete: :nothing), null: false
      add :tournament_id, references(:tournaments, type: :binary_id, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:pools, [:invite_token])
    create index(:pools, [:owner_id])
    create index(:pools, [:tournament_id])
  end
end
