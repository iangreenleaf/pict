defmodule PictWeb.SubmissionLive.Show do
  use PictWeb, :live_view

  alias Pict.Prompts

  import Pict.Prompts, only: [expects_drawing?: 1]

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
      |> assign(:clue, Prompts.get_clue_for(submission))
    }
  end

  def entered(assigns) do
    ~H"""
    <%= if expects_drawing?(@submission) do %>
      <%= img_tag drawing_url(@submission) %>
    <% else %>
      <%= @submission.text %>
    <% end %>
    """
  end

  def drawing_url(submission) do
    Pict.Drawing.url({submission.drawing, submission}, :large)
  end

  defp page_title(:show), do: "Show Submission"
  defp page_title(:edit), do: "Edit Submission"
end
