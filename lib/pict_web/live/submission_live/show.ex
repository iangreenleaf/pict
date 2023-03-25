defmodule PictWeb.SubmissionLive.Show do
  use PictWeb, :live_view

  alias Pict.Prompts

  import Pict.Prompts, only: [expects_drawing?: 1]

  embed_templates("partials/*")

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    submission = Prompts.get_submission!(id)
    %{starter_name: starter_name, total: total} = Prompts.get_submission_name_details(submission)

    {
      :noreply,
      socket
      |> assign(:page_title, page_title(socket.assigns.live_action))
      |> assign(:submission, submission)
      |> assign(:name, submission_name(submission, starter_name, total))
      |> assign(:next_submissions, Prompts.other_undone_submissions(submission))
      |> assign(:clue, Prompts.get_clue_for(submission))
    }
  end

  def render(%{submission: %{game_player: %{name: nil }}} = assigns) do
    player_name(assigns)
  end

  def render(%{live_action: :edit} = assigns) do
    edit(assigns)
  end

  def render(assigns) do
    submission(assigns)
  end

  def drawing_url(submission, size \\ :large) do
    Pict.Drawing.url({submission.drawing, submission}, size)
  end

  defp submission_name(submission, starter_name, total), do:
    "#{starter_name} #{submission.order + 1}/#{total}"

  defp page_title(:show), do: "Show Submission"
  defp page_title(:edit), do: "Edit Submission"

  def prompt_link_text(submission) do
    "#{prompt_action(submission)}: #{prompt_name(submission)}"
  end

  def prompt_action(submission) do
    if expects_drawing?(submission), do: 'Draw', else: 'Guess'
  end

  defp prompt_name(%{starter_name: name, order: order, total: total}) do
    "#{name} #{order + 1}/#{total}"
  end
end
