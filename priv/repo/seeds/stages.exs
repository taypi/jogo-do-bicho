group_names =
  ~w(A B C D E F G H I J K L)

groups =
  group_names
  |> Enum.map(fn group ->

    {:ok, stage} =
      Tournaments.create_stage(
        scope,
        %{
          tournament_id: world_cup.id,
          name: "Group #{group}",
          type: :group
        }
      )

    {group, stage}

  end)
  |> Map.new()

{:ok, r32} =
  Tournaments.create_stage(scope,%{
    tournament_id: world_cup.id,
    name: "Round of 32",
    type: :knockout
  })

{:ok, r16} =
  Tournaments.create_stage(scope,%{
    tournament_id: world_cup.id,
    name: "Round of 16",
    type: :knockout
  })

{:ok, qf} =
  Tournaments.create_stage(scope,%{
    tournament_id: world_cup.id,
    name: "Quarterfinals",
    type: :knockout
  })

{:ok, sf} =
  Tournaments.create_stage(scope,%{
    tournament_id: world_cup.id,
    name: "Semifinals",
    type: :knockout
  })

{:ok, final} =
  Tournaments.create_stage(scope,%{
    tournament_id: world_cup.id,
    name: "Final",
    type: :knockout
  })
