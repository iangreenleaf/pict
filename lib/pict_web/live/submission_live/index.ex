defmodule PictWeb.SubmissionLive.Index do
  use PictWeb, :live_view

  alias Pict.Prompts
  alias Pict.Prompts.Submission

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :submissions, list_submissions())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Submission")
    |> assign(:submission, Prompts.get_submission!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Submission")
    |> assign(:submission, %Submission{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Submissions")
    |> assign(:submission, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    submission = Prompts.get_submission!(id)
    {:ok, _} = Prompts.delete_submission(submission)

    {:noreply, assign(socket, :submissions, list_submissions())}
  end

  defp list_submissions do
    Prompts.list_submissions()
  end
end
