defmodule LiveViewStudioWeb.SalesDashboardLive do
  use LiveViewStudioWeb, :live_view

  import LiveViewStudio.Sales, only: [new_orders: 0, sales_amount: 0, satisfaction: 0]

  def mount(_params, _session, socket) do
    if connected?(socket), do: :timer.send_interval(1_000, self(), :tick)
    {:ok, assign_stats(socket)}
  end

  def render(assigns) do
    ~L"""
    <h1>Sales Dashboard</h1>
    <div id="dashboard">
      <div class="stats">
        <div class="stat">
          <span class="value">
            <%= @new_orders %>
          </span>
          <span class="name">
            New Orders
          </span>
        </div>
        <div class="stat">
          <span class="value">
            $<%= @sales_amount %>
          </span>
          <span class="name">
            Sales Amount
          </span>
        </div>
        <div class="stat">
          <span class="value">
            <%= @satisfaction %>%
          </span>
          <span class="name">
            Satisfaction
          </span>
        </div>
      </div>

      <button phx-click="refresh">
        <img src="images/refresh.svg">
        Refresh
      </button>
    </div>
    """
  end

  def handle_info(:tick, socket) do
    {:noreply, assign_stats(socket)}
  end

  def handle_event("refresh", _params, socket) do
    {:noreply, assign_stats(socket)}
  end

  defp assign_stats(socket) do
    assign(
      socket,
      new_orders: new_orders(),
      sales_amount: sales_amount(),
      satisfaction: satisfaction()
    )
  end
end
