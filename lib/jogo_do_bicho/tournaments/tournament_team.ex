defmodule JogoDoBicho.Tournaments.TournamentTeam do
  use Ecto.Schema
  import Ecto.Changeset

  alias JogoDoBicho.Teams.Team

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "tournament_teams" do
    field :tournament_id, :binary_id

    belongs_to :team, Team

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(tournament_team \\ %__MODULE__{}, attrs) do
    tournament_team
    |> cast(attrs, [])
    |> validate_required([])
  end
end
