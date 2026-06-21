alias JogoDoBicho.Repo
alias JogoDoBicho.Tournaments.Tournament

for attrs <- [
      %{
        name: "World Cup 2026",
        start_date: ~D[2026-06-11],
        end_date: ~D[2026-07-19]
      },
      %{
        name: "Euro 2028",
        start_date: ~D[2028-06-09],
        end_date: ~D[2028-07-09]
      }
    ] do
  %Tournament{}
  |> Tournament.changeset(attrs)
  |> Repo.insert(
    on_conflict: :nothing,
    conflict_target: :name
  )
end
