defmodule JogoDoBicho.Pools.Pool do
  use Ecto.Schema

  import Ecto.Changeset

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

  def changeset(pool \\ %__MODULE__{}, attrs) do
    pool
    |> cast(attrs, [
      :name,
      :invite_token,
      :owner_id,
      :tournament_id
    ])
    |> validate_required([
      :name,
      :owner_id,
      :tournament_id
    ])
    |> validate_length(:name,
      min: 3,
      max: 255
    )
    |> maybe_put_invite_token()
    |> unique_constraint(:invite_token)
  end

  defp maybe_put_invite_token(changeset) do
    case get_field(changeset, :invite_token) do
      nil ->
        put_change(
          changeset,
          :invite_token,
          generate_invite_token()
        )

      _ ->
        changeset
    end
  end

  defp generate_invite_token do
    16
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64(padding: false)
  end
end
