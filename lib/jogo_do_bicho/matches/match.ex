defmodule JogoDoBicho.Matches.Match do
  use Ecto.Schema
  import Ecto.Changeset

  alias JogoDoBicho.Teams.Team

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "matches" do
    belongs_to :tournament, Tournament

    belongs_to :team_a, Team
    belongs_to :team_b, Team

    field :kickoff_at, :utc_datetime

    field :team_a_score, :integer
    field :ateam_b_score, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(match \\ %__MODULE__{}, attrs) do
    match
    |> cast(attrs, [])
    |> validate_required([])
  end
end
