defmodule LiveViewStudioWeb.QuoteComponent do # stateless component
  use LiveViewStudioWeb, :live_component

  import Number.Currency

  # used to assign defaults
  def mount(socket) do
    {:ok, assign(socket, hrs_until_expires: 24)}
  end

  # use this callback if we need to derive anything from the passed in assigns
  # (stepping into the lifecycle)
  #def update(assigns, socket) do
    #{:ok, assign(socket, assigns)}
  #end

  def render(assigns) do
    ~L"""
    <div class="text-center p-6 border-4 border-dashed border-indigo-600">
      <h2 class="text-2xl mb-2">
        Our Best Deal:
      </h2>
      <h3 class="text-xl font-semibold text-indigo-600">
        <%= @weight %> pounds of <%= @material %>
        for <%= number_to_currency(@price) %>
      </h3>
      <div class="text-gray-600">
        expires in <%= @hrs_until_expires %> hours
        <!-- (<%= #@minutes %> minutes) -->
      </div>
    </div>
    """
  end
end
