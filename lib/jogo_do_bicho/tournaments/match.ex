defmodule JogoDoBicho.Tournaments.Match do
  use Ecto.Schema
  import Ecto.Changeset

  alias JogoDoBicho.Tournaments.{Stage, Slot}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "matches" do
    field :kickoff_at, :utc_datetime
    field :score_a, :integer
    field :score_b, :integer

    belongs_to :stage, Stage
    belongs_to :slot_a, Slot
    belongs_to :slot_b, Slot

    timestamps(type: :utc_datetime)
  end

  def changeset(match \\ %__MODULE__{}, attrs) do
    match
    |> cast(attrs, [
      :stage_id,
      :slot_a_id,
      :slot_b_id,
      :kickoff_at,
      :score_a,
      :score_b
    ])
    |> validate_required([
      :stage_id,
      :slot_a_id,
      :slot_b_id
    ])
    |> validate_number(:score_a, greater_than_or_equal_to: 0)
    |> validate_number(:score_b, greater_than_or_equal_to: 0)
    |> validate_different_slots()
    |> foreign_key_constraint(:stage_id)
    |> foreign_key_constraint(:slot_a_id)
    |> foreign_key_constraint(:slot_b_id)
  end

  defp validate_different_slots(changeset) do
    if get_field(changeset, :slot_a_id) ==
         get_field(changeset, :slot_b_id) do
      add_error(changeset, :slot_b_id, "must be different")
    else
      changeset
    end
  end
end
