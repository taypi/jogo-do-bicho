defmodule JogoDoBicho.Tournaments.Resolver do
  alias JogoDoBicho.Repo

  alias JogoDoBicho.Tournaments.Match
  alias JogoDoBicho.Tournaments.Slot
  alias JogoDoBicho.Teams.Team

  def resolve_slot(%Slot{type: :team} = slot) do
    Repo.preload(slot, :team).team
  end

  def resolve_slot(%Slot{
        type: :group_position,
        source_stage_id: stage_id,
        source_position: position
      }) do
    standings(stage_id)
    |> Enum.at(position - 1)
  end

  def resolve_slot(%Slot{
        type: :match_winner,
        source_match_id: match_id
      }) do
    match = Repo.get!(Match, match_id)

    winner(match)
  end

  defp standings(_), do: []

  defp winner(match) do
    cond do
      match.score_a > match.score_b ->
        match.slot_a

      match.score_b > match.score_a ->
        match.slot_b

      true ->
        nil
    end
  end

  defp finished?(match) do
    match.score_a != nil && match.score_b != nil
  end
end
