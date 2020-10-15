defmodule LiveViewStudioWeb.PaginateLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Donations

  def mount(params, _session, socket) do
    donations =
      Donations.list_donations(
        paginate: page_opts(params),
        sort: %{sort_by: :item, sort_order: :asc}
      )

    socket = assign(socket, donations: donations, options: page_opts(params))

    {:ok, socket, temporary_assigns: [donations: []]}
  end

  defp page_opts(%{"page" => page, "per_page" => per_page}) do
    %{page: String.to_integer(page), per_page: String.to_integer(per_page)}
  end

  defp page_opts(_params), do: %{page: 1, per_page: 5}

  defp expires_class(donation) do
    if Donations.almost_expired?(donation), do: "eat-now", else: "fresh"
  end
end
