defmodule JogoDoBicho.Tournaments.Slot do
  use Ecto.Schema
  import Ecto.Changeset

  alias JogoDoBicho.Teams.Team
  alias JogoDoBicho.Tournaments.Match
  alias JogoDoBicho.Tournaments.Stage
  alias JogoDoBicho.Tournaments.Tournament

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "slots" do
    field :source_position, :integer
    field :source_match_id, Ecto.UUID
    field :ranking_index, :integer
    field :eligible_groups, {:array, :string}
    field :type, Ecto.Enum, values: [:team, :group_position, :match_winner, :match_loser, :best_third]

    belongs_to :tournament, Tournament
    belongs_to :team, Team
    belongs_to :source_stage, Stage

    has_many :matches_as_a, Match, foreign_key: :slot_a_id

    has_many :matches_as_b, Match, foreign_key: :slot_b_id

    timestamps(type: :utc_datetime)
  end

  def changeset(slot \\ %__MODULE__{}, attrs) do
    slot
    |> cast(attrs, [
      :type,
      :source_position,
      :source_match_id,
      :ranking_index,
      :eligible_groups,
      :tournament_id,
      :team_id,
      :source_stage_id
    ])
    |> foreign_key_constraint(:tournament_id)
    |> foreign_key_constraint(:team_id)
    |> foreign_key_constraint(:source_stage_id)
    |> validate_required([:type, :tournament_id])
    |> validate_type_constraints()
  end

  defp validate_type_constraints(changeset) do
    case get_field(changeset, :type) do
      :team ->
        validate_required(changeset, [:team_id])

      :group_position ->
        validate_required(changeset, [:source_stage_id, :source_position])

      :best_third ->
        validate_required(changeset, [:ranking_index])

      :match_winner ->
        validate_required(changeset, [:source_match_id])

      :match_loser ->
        validate_required(changeset, [:source_match_id])

      _ ->
        changeset
    end
  end
end
