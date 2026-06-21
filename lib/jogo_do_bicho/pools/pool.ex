defmodule JogoDoBicho.Pools.Pool do
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias JogoDoBicho.Accounts.Scope
  alias JogoDoBicho.Accounts.User
  alias JogoDoBicho.Pools.PoolMember
  alias JogoDoBicho.Tournaments.Tournament

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "pools" do
    field :name, :string
    field :invite_token, :string

    belongs_to :owner, User
    belongs_to :tournament, Tournament

    has_many :pool_members, PoolMember
    many_to_many :members, User, join_through: PoolMember

    timestamps(type: :utc_datetime)
  end

  def scope(query \\ __MODULE__, %Scope{} = scope) do
    query
    |> join(:inner, [p], pm in PoolMember, on: pm.pool_id == p.id)
    |> where([_p, pm], pm.user_id == ^scope.user.id)
  end

  def changeset(pool \\ %__MODULE__{}, attrs, %Scope{} = scope) do
    pool
    |> cast(attrs, [:name, :tournament_id])
    |> put_change(:owner_id, scope.user.id)
    |> put_change(:invite_token, generate_invite_token())
    |> validate_required([:name, :tournament_id])
    |> validate_name()
    |> unique_constraint(:invite_token)
  end

  def update_changeset(%__MODULE__{} = pool, attrs) do
    pool
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> validate_name()
  end

  defp generate_invite_token do
    16
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64(padding: false)
  end

  defp validate_name(changes), do: validate_length(changes, :name, min: 3, max: 255)
end
