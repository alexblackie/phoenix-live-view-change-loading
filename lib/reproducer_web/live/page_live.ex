require Logger

defmodule ReproducerWeb.PageLive do
  use ReproducerWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(query: "", results: %{}, uploaded_files: [])
      |> allow_upload(:testfile, accept: :any, progress: &handle_upload/3, auto_upload: true)

    {:ok, socket}
  end

  @impl true
  def handle_event("suggest", %{"q" => query}, socket) do
    {:noreply, assign(socket, results: search(query), query: query)}
  end

  @impl true
  def handle_event("save", _params, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("noop", _params, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("search", %{"q" => query}, socket) do
    case search(query) do
      %{^query => vsn} ->
        {:noreply, redirect(socket, external: "https://hexdocs.pm/#{query}/#{vsn}")}

      _ ->
        {:noreply,
         socket
         |> put_flash(:error, "No dependencies found matching \"#{query}\"")
         |> assign(results: %{}, query: query)}
    end
  end

  defp search(query) do
    if not ReproducerWeb.Endpoint.config(:code_reloader) do
      raise "action disabled when not in development"
    end

    for {app, desc, vsn} <- Application.started_applications(),
        app = to_string(app),
        String.starts_with?(app, query) and not List.starts_with?(desc, ~c"ERTS"),
        into: %{},
        do: {app, vsn}
  end

  defp handle_upload(:testfile, entry, socket) do
    if entry.done? do
      uploaded_file =
        consume_uploaded_entry(socket, entry, fn %{path: path} ->
          Logger.debug("Consumed #{entry.client_name}")
          path
        end)

      {:noreply, update(socket, :uploaded_files, &(&1 ++ [uploaded_file]))}
    else
      Logger.debug("Waiting for #{entry.client_name}")
      {:noreply, socket}
    end
  end
end
