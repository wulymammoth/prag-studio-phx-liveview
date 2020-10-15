defmodule LiveViewStudioWeb.FilterLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Boats

  def mount(_params, _session, socket) do
    assigns = assign(socket, boats: Boats.list_boats(), type: "", prices: [])
    # NOTE: does the socket process need to carry around all the boats all the
    # time? NO employ `temporary_assigns` to reset a key to a particular value
    # AFTER render/1 is invoked if we know that the data comes from DB or some
    # other cache on every call, there's no need for the socket to maintain all
    # this data in memory
    {:ok, assigns, temporary_assigns: [boats: []]}
  end

  def render(assigns) do
    ~L"""
    <h1>Daily Boat Rentals</h1>
    <div id="filter">
      <form phx-change="filter">
        <div class="filters">
          <select name="type">
            <%= options_for_select(type_options(), @type) %>
          </select>
          <div class="prices">
            <input type="hidden" name="prices[]" value="" />
            <%= for price <- ["$", "$$", "$$$"]  do %>
              <%= price_checkbox(price: price, checked: price in @prices) %>
            <% end %>
          </div>
        </div>
      </form>

      <div class="boats">
        <%= for boat <- @boats do %>
          <div class="card">
            <img src="<%= boat.image %>">
            <div class="content">
              <div class="model">
                <%= boat.model %>
              </div>
              <div class="details">
                <span class="price">
                  <%= boat.price %>
                </span>
                <span class="type">
                  <%= boat.type %>
                </span>
              </div>
            </div>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  def handle_event("filter", %{"prices" => prices, "type" => type}, socket) do
    params = [prices: prices, type: type]
    socket = assign(socket, params ++ [boats: Boats.list_boats(params)])
    {:noreply, socket}
  end

  defp price_checkbox(assigns) do
    assigns = Enum.into(assigns, %{})

    ~L"""
    <input type="checkbox"
           id="<%= @price %>"
           name="prices[]"
           value="<%= @price %>"
           <%= if @checked, do: "checked" %> />
    <label for="<%= @price %>"><%= @price %></label>
    """
  end

  defp type_options do
    ["All types": "", Fishing: "fishing", Sporting: "sporting", Sailing: "sailing"]
  end
end
