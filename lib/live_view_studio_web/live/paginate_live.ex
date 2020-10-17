defmodule LiveViewStudioWeb.PaginateLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Donations

  def mount(_params, _session, socket) do
    {:ok, socket, temporary_assigns: [donations: []]}
  end

  # NOTE: always invoked after `mount/3`
  def handle_params(params, _uri, socket) do
    {:noreply,
     assign(
       socket,
       donations: donations(params),
       options: page_opts(params)
     )}
  end

  def handle_event("select-per-page", params, socket) do
    socket = assign(socket, options: page_opts(params))
    path = to_page(nil, page_opts(params), socket)
    {:noreply, push_patch(socket, to: path)}
  end

  defp donations(params) do
    Donations.list_donations(
      paginate: page_opts(params),
      sort: %{sort_by: :item, sort_order: :asc}
    )
  end

  defp expires_class(donation) do
    if Donations.almost_expired?(donation), do: "eat-now", else: "fresh"
  end

  def page_opts(%{"page" => page, "per-page" => per_page}) do
    %{page: String.to_integer(page), per_page: String.to_integer(per_page)}
  end

  def page_opts(%{"per_page" => per_page}) do
    %{page: 1, per_page: String.to_integer(per_page)}
  end

  def page_opts(%{"page" => page}) do
    %{page: String.to_integer(page), per_page: 5}
  end

  # default
  def page_opts(_params), do: %{page: 1, per_page: 5}

  defp to_page(nil, %{page: page, per_page: per_page}, socket) do
    Routes.live_path(socket, __MODULE__, page: page, per_page: per_page)
  end

  defp to_page(:next, %{page: page, per_page: per_page}, socket) do
    Routes.live_path(socket, __MODULE__, page: page + 1, per_page: per_page)
  end

  defp to_page(:prev, %{page: page, per_page: per_page}, socket) do
    Routes.live_path(socket, __MODULE__, page: page - 1, per_page: per_page)
  end
end
