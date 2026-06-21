defmodule JogoDoBicho.Pools.PoolMember do
  use Ecto.Schema

  import Ecto.Changeset

  alias JogoDoBicho.Accounts.User
  alias JogoDoBicho.Pools.Pool

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "pool_members" do
    belongs_to :pool, Pool
    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  def changeset(pool_member \\ %__MODULE__{}, attrs) do
    pool_member
    |> cast(attrs, [:pool_id, :user_id])
    |> validate_required([:pool_id, :user_id])
    |> unique_constraint([:pool_id, :user_id])
  end
end
