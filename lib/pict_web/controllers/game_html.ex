defmodule PictWeb.GameHTML do
  use PictWeb, :html
  embed_templates "../templates/game/*"

  alias Pict.Prompts.Prompt
  alias Pict.Prompts.Submission
  alias Pict.Games.GamePlayer
  alias Pict.Accounts.Account

  def prompt_display_name(%Prompt{submissions: submissions}) do
    prompt_owner(submissions)
    |> display_name()
  end

  defp prompt_owner(submissions) do
    List.first(submissions)
  end

  defp display_name(%Submission{game_player: game_player}), do: display_name(game_player)

  defp display_name(%GamePlayer{name: name, player: %Account{email: email}}) do
    name || email
  end

  def rotated_submissions(%Prompt{} = prompt, player_index) do
    case player_index[List.first(prompt.submissions).game_player_id] do
      0 -> prompt.submissions
      offset ->
        Enum.slice(prompt.submissions, (-offset)..-1) ++ Enum.slice(prompt.submissions, 0..(-offset-1))
    end
  end

  def current_active_submission(%Prompt{submissions: submissions}) do
    Enum.find(submissions, fn sub -> !sub.completed end)
  end

  def submission_css(submission, active_submission_for_prompt)
  def submission_css(s, s), do: "bg-amber-300"
  def submission_css(%{completed: true}, _), do: "bg-emerald-400"
  def submission_css(%{completed: false}, _), do: "bg-rose-400"

  def submissions_count(%Prompt{submissions: submissions}) do
    length(submissions)
  end

  def completed_count(%Prompt{submissions: submissions}) do
    Enum.count(submissions, fn s -> s.completed end)
  end
end
