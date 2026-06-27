defmodule JogoDoBicho.Tournaments.Stage do
  use Ecto.Schema
  import Ecto.Changeset

  alias JogoDoBicho.Tournaments.Match
  alias JogoDoBicho.Tournaments.Tournament

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "stages" do
    field :name, :string
    field :type, Ecto.Enum, values: [
      :group,
      :round_of_32,
      :round_of_16,
      :quarterfinal,
      :semifinal,
      :third_place,
      :final
    ]

    has_many :matches, Match
    belongs_to :tournament, Tournament

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(stage \\ %__MODULE__{}, attrs) do
    stage
    |> cast(attrs, [:name, :type, :tournament_id])
    |> validate_required([:name, :type, :tournament_id])
  end
end
