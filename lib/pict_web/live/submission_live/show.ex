defmodule PictWeb.SubmissionLive.Show do
  use PictWeb, :live_view

  alias Pict.Prompts
  alias Pict.Games
  alias Pict.Repo

  import Pict.Prompts, only: [expects_drawing?: 1]

  embed_templates("partials/*")

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    submission = Prompts.get_submission!(id)

    {
      :noreply,
      socket
      |> assign(:page_title, page_title(socket.assigns.live_action))
      |> assign(:submission, submission)
      |> assign(:next_submissions, Prompts.other_undone_submissions(submission))
      |> assign(:clue, Prompts.get_clue_for(submission))
    }
  end

  def drawing_url(submission, size \\ :large) do
    Pict.Drawing.url({submission.drawing, submission}, size)
  end

  defp page_title(:show), do: "Show Submission"
  defp page_title(:edit), do: "Edit Submission"

  defp prompt_name(submission) do
    starter = Games.get_game_player!(
      Prompts.get_submission_at(submission.prompt_id, 0).game_player_id
    )
    total = Repo.preload(submission, [:player, prompt: [:submissions]]).prompt.submissions |> Enum.count()
    "#{starter.name} #{submission.order + 1}/#{total}"
  end
end
