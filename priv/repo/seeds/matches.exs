{:ok, _} =
  Tournaments.create_match(
    scope,
    %{
      stage_id: groups["C"].id,
      slot_a_id: slot_bra.id,
      slot_b_id: slot_mar.id
    }
  )

{:ok, _} =
  Tournaments.create_match(
    scope,
    %{
      stage_id: groups["C"].id,
      slot_a_id: slot_hai.id,
      slot_b_id: slot_sco.id
    }
  )

{:ok, _} =
  Tournaments.create_match(
    scope,
    %{
      stage_id: groups["C"].id,
      slot_a_id: slot_bra.id,
      slot_b_id: slot_hai.id
    }
  )

{:ok, _} =
  Tournaments.create_match(
    scope,
    %{
      stage_id: groups["C"].id,
      slot_a_id: slot_mar.id,
      slot_b_id: slot_sco.id
    }
  )

{:ok, _} =
  Tournaments.create_match(
    scope,
    %{
      stage_id: groups["C"].id,
      slot_a_id: slot_bra.id,
      slot_b_id: slot_sco.id
    }
  )

{:ok, _} =
  Tournaments.create_match(
    scope,
    %{
      stage_id: groups["C"].id,
      slot_a_id: slot_mar.id,
      slot_b_id: slot_hai.id
    }
  )
