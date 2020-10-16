defmodule LiveViewStudioWeb.PaginateLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Donations

  def mount(params, _session, socket) do
    {:ok, socket, temporary_assigns: [donations: []]}
  end

  # NOTE: always invoked after `mout/3`
  def handle_params(params, _uri, socket) do
    {:noreply,
     assign(
       socket,
       donations: donations(params),
       options: page_opts(params)
     )}
  end

  defp donations(params) do
    Donations.list_donations(
      paginate: page_opts(params),
      sort: %{sort_by: :item, sort_order: :asc}
    )
  end

  defp page_opts(%{"page" => page, "per_page" => per_page}) do
    %{page: String.to_integer(page), per_page: String.to_integer(per_page)}
  end

  defp page_opts(_params), do: %{page: 1, per_page: 5}

  defp expires_class(donation) do
    if Donations.almost_expired?(donation), do: "eat-now", else: "fresh"
  end

  defp to_page(direction, _opts = %{page: page, per_page: per_page}, socket) do
    Routes.live_path(
      socket,
      __MODULE__,
      page: (if direction == :prev, do: page - 1, else: page + 1),
      per_page: per_page
    )
  end
end
