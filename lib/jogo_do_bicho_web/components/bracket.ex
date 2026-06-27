defmodule JogoDoBichoWeb.Bracket do
  use Phoenix.Component

  alias JogoDoBicho.Tournaments.Resolver

  attr :stages, :list, required: true

  def bracket(assigns) do
    ~H"""
    <div class="space-y-8">
      <%= for stage <- @stages do %>
        <div>
          <h2 class="text-lg font-semibold mb-4">
            {stage.name}
          </h2>

          <div class="space-y-4">
            <%= for match <- stage.matches do %>
              <.match match={match} />
            <% end %>
          </div>
        </div>
      <% end %>
    </div>
    """
  end

  attr :match, :map, required: true

  def match(assigns) do
    ~H"""
    <div class="border rounded p-4 w-64">

      <div class="flex justify-between">
        <span>
          {Resolver.slot_name(@match.slot_a)}
        </span>

        <span>
          {@match.score_a || "-"}
        </span>
      </div>

      <div class="flex justify-between">
        <span>
          {Resolver.slot_name(@match.slot_b)}
        </span>

        <span>
          {@match.score_b || "-"}
        </span>
      </div>

    </div>
    """
  end
end
