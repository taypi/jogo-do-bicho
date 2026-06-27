team_slot = fn team ->

  {:ok, slot} =
    Tournaments.create_slot(
      scope,
      %{
        tournament_id: world_cup.id,
        type: :team,
        team_id: team.id
      }
    )

  slot

end
