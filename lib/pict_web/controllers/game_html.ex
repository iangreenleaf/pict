defmodule PictWeb.GameHTML do
  use PictWeb, :html
  embed_templates "../templates/game/*"

  alias Pict.Prompts
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

  def submission_css(submission, active_submission_for_prompt, prompt, stats)
  def submission_css(s, s, _, _), do: "bg-amber-300"
  def submission_css(%{completed: true}, _, _, _), do: "bg-emerald-400"
  def submission_css(%{completed: false}, _, prompt, stats) do
    remaining_color(prompt, stats)
  end

  def submissions_count(%Prompt{submissions: submissions}) do
    length(submissions)
  end

  def completed_count(%Prompt{submissions: submissions}) do
    Enum.count(submissions, fn s -> s.completed end)
  end

  def remaining_color(prompt, %{ max_remaining: l, median_remaining: median }) do
    remaining = Prompts.submissions_remaining(prompt)
    delta = remaining - median
    # Nine possible colors in total, 4 each side of median
    c = 4
    adj_delta = delta / ( l / c )
    # Do it this way so we make all CSS explicit for Tailwind
    idx = 4 + round(adj_delta)
    ~W[
      bg-rose-50
      bg-rose-100
      bg-rose-200
      bg-rose-300
      bg-rose-400
      bg-rose-500
      bg-rose-600
      bg-rose-700
      bg-rose-800
    ]
    |> Enum.at(idx)
  end
end
