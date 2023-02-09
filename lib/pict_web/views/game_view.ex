defmodule PictWeb.GameView do
  use PictWeb, :view

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

  defp display_name(%Submission{game_player: %GamePlayer{name: name, player: %Account{email: email}}}) do
    name || email
  end

  def submissions_count(%Prompt{submissions: submissions}) do
    length(submissions)
  end

  def completed_count(%Prompt{submissions: submissions}) do
    Enum.count(submissions, fn s -> s.completed end)
  end
end
