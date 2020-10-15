defmodule LiveViewStudioWeb.ServersLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Servers

  @doc """
  Question:
  - where to assign state? In `mount` or `handle_params`?
    - rule of thumb: if we have state that can change as we navigate, based on
    URL query params, then we want to put that in `handle_params()`
    - servers is assigned in `mount` (remains static even when the query params change)
    - selected_server is assigned in `handle_params`
  """
  def mount(_params, _session, socket) do
    servers = Servers.list_servers()

    socket =
      assign(socket,
        servers: servers,
        selected_server: hd(servers)
      )

    {:ok, socket}
  end

  @doc """
  Always invoked after:
  1. mount
  2. after live_patch is used
  """
  def handle_params(%{"id" => id}, _url, socket) do
    server =
      id
      |> String.to_integer()
      |> Servers.get_server!()

    {:noreply, assign(socket, page_title: "What's up #{server.name}?", selected_server: server)}
  end

  def handle_params(_, _uri, socket) do
    {:noreply, socket}
  end

  def render(assigns) do
    ~L"""
    <h1>Servers</h1>
    <div id="servers">
      <div class="sidebar">
        <nav>
          <%= for server <- @servers do %>
            <div>
              <!-- live_patch updates the URL using push-state and also updates the DOM -->
              <%= live_patch(
                link_body(server),
                to: Routes.live_path(@socket, __MODULE__, id: server.id),
                class: (if server == @selected_server, do: "active")) %>
            </div>
          <% end %>
        </nav>
      </div>
      <div class="main">
        <div class="wrapper">
          <div class="card">
            <div class="header">
              <h2><%= @selected_server.name %></h2>
              <span class="<%= @selected_server.status %>">
                <%= @selected_server.status %>
              </span>
            </div>
            <div class="body">
              <div class="row">
                <div class="deploys">
                  <img src="/images/deploy.svg">
                  <span>
                    <%= @selected_server.deploy_count %> deploys
                  </span>
                </div>
                <span>
                  <%= @selected_server.size %> MB
                </span>
                <span>
                  <%= @selected_server.framework %>
                </span>
              </div>
              <h3>Git Repo</h3>
              <div class="repo">
                <%= @selected_server.git_repo %>
              </div>
              <h3>Last Commit</h3>
              <div class="commit">
                <%= @selected_server.last_commit_id %>
              </div>
              <blockquote>
                <%= @selected_server.last_commit_message %>
              </blockquote>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp link_body(server) do
    assigns = %{name: server.name}

    ~L"""
    <img src="/images/server.svg" alt="server">
    <%= @name %>
    """
  end
end
