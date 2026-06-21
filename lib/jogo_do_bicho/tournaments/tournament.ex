defmodule JogoDoBicho.Tournaments.Tournament do
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "tournaments" do
    field :name, :string
    field :start_date, :date
    field :end_date, :date

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(tournament \\ %__MODULE__{}, attrs) do
    tournament
    |> cast(attrs, [:name, :start_date, :end_date])
    |> validate_required([:name, :start_date, :end_date])
    |> unique_constraint(:name)
    |> validate_date_range()
  end

  defp validate_date_range(changeset) do
    start_date = get_field(changeset, :start_date)
    end_date = get_field(changeset, :end_date)

    case Date.compare(end_date, start_date) do
      :lt ->
        add_error(
          changeset,
          :end_date,
          "must be on or after start date"
        )

      _ ->
        changeset
    end
  end
end
