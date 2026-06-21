defmodule JogoDoBicho.Repo.Migrations.CreatePoolMembers do
  use Ecto.Migration

  def change do
    create table(:pool_members, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :pool_id, references(:pools, type: :binary_id, on_delete: :delete_all), null: false
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:pool_members, [:pool_id])
    create index(:pool_members, [:user_id])

    create unique_index(:pool_members, [:pool_id, :user_id])
  end
end
