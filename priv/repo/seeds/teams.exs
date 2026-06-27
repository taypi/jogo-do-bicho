teams = [
  {"Mexico","MEX"},
  {"South Africa","RSA"},
  {"South Korea","KOR"},
  {"Czechia","CZE"},

  {"Canada","CAN"},
  {"Bosnia and Herzegovina","BIH"},
  {"Qatar","QAT"},
  {"Switzerland","SUI"},

  {"Brazil","BRA"},
  {"Morocco","MAR"},
  {"Haiti","HTI"},
  {"Scotland","SCO"},

  {"United States","USA"},
  {"Paraguay","PAR"},
  {"Australia","AUS"},
  {"Turkey","TUR"},

  {"Germany","GER"},
  {"Curacao","CUW"},
  {"Ivory Coast","CIV"},
  {"Ecuador","ECU"},

  {"Netherlands","NED"},
  {"Japan","JPN"},
  {"Sweden","SWE"},
  {"Tunisia","TUN"},

  {"Belgium","BEL"},
  {"Egypt","EGY"},
  {"Iran","IRI"},
  {"New Zealand","NZL"},

  {"Spain","ESP"},
  {"Cape Verde","CPV"},
  {"Saudi Arabia","KSA"},
  {"Uruguay","URU"},

  {"France","FRA"},
  {"Senegal","SEN"},
  {"Iraq","IRQ"},
  {"Norway","NOR"},

  {"Argentina","ARG"},
  {"Algeria","DZA"},
  {"Austria","AUT"},
  {"Jordan","JOR"},

  {"Portugal","POR"},
  {"DR Congo","COD"},
  {"Uzbekistan","UZB"},
  {"Colombia","COL"},

  {"England","ENG"},
  {"Croatia","CRO"},
  {"Ghana","GHA"},
  {"Panama","PAN"}
]

teams =
  teams
  |> Enum.map(fn {name, code} ->

    {:ok, team} =
      Teams.create_team(
        scope,
        %{
          name: name,
          code: code
        }
      )

    {code, team}

  end)
  |> Map.new()
