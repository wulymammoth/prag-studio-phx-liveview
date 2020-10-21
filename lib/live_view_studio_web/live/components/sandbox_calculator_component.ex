# stateful component
defmodule LiveViewStudioWeb.SandboxCalculatorComponent do
  use LiveViewStudioWeb, :live_component

  alias LiveViewStudio.SandboxCalculator

  def mount(socket) do
    {:ok, assign(socket, length: nil, width: nil, depth: nil, weight: 0)}
  end

  def render(assigns) do
    # <!-- @myself allows us to target which component (in this case not the parent) w/ the "calculate" change event -->
    ~L"""
    <form phx-change="calculate" phx-target="<%= @myself %>" phx-submit="get-quote">
      <div class="field">
        <label for="length">Length:</label>
        <input type="number" name="length" value="<%= @length %>" />
        <span class="unit">feet</span>
      </div>
      <div class="field">
        <label for="length">Width:</label>
        <input type="number" name="width" value="<%= @width %>" />
        <span class="unit">feet</span>
      </div>
      <div class="field">
        <label for="length">Depth:</label>
        <input type="number" name="depth" value="<%= @depth %>" />
        <span class="unit">inches</span>
      </div>
      <div class="weight">
        You need <%= @weight %> pounds
      </div>
      <button type="submit">
        Get Quote
      </button>
    </form>
    """
  end

  def handle_event("calculate", %{"length" => length, "width" => width, "depth" => depth}, socket) do
    weight = SandboxCalculator.calculate_weight(length, width, depth)
    {:noreply, assign(socket, length: length, width: width, depth: depth, weight: weight)}
  end

  def handle_event("get-quote", _params, socket = %{assigns: %{weight: weight}}) do
    price = SandboxCalculator.calculate_price(weight)
    send(self(), {:totals, weight, price})
    {:noreply, socket}
  end
end
