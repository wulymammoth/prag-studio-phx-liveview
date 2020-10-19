defmodule LiveViewStudioWeb.VolunteersLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.{Volunteers, Volunteers.Volunteer}

  def mount(_params, _session, socket) do
    volunteers = Volunteers.list_volunteers()

    changeset = Volunteers.change_volunteer(%Volunteer{})

    socket =
      assign(socket,
        volunteers: volunteers,
        changeset: changeset
      )

    # NOTE: the temporary assigns helps us free up memory once the view is
    # rendered by not keeping the volunteers in memory in our genserver
    {:ok, socket, temporary_assigns: [volunteers: []]}
  end

  def handle_event("save", %{"volunteer" => params}, socket) do
    case Volunteers.create_volunteer(params) do
      {:ok, volunteer} ->
        socket =
          socket
          |> update(:volunteers, &[volunteer | &1])
          |> assign(changeset: Volunteers.change_volunteer(%Volunteer{}))

        {:noreply, socket}

      {:error, changeset = %Ecto.Changeset{}} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
