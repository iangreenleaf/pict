defmodule PictWeb.Emails.UserEmail do
  import Swoosh.Email
  alias Pict.Prompts

  defp default_from(mail) do
    from_addr = System.get_env("PHX_EMAIL_FROM") || "pict@example.com"
    from(mail, {"Telephone Pictionary", from_addr})
  end

  defp render_with_layout(email, heex) do
    html_body(
      email,
      render_component(PictWeb.EmailHTML.layout(%{email: email, inner_content: heex}))
    )
  end

  defp render_component(heex) do
    heex |> Phoenix.HTML.Safe.to_iodata() |> IO.chardata_to_string()
  end

  def game_ready(game) do
    new()
    |> to(game.owner)
    |> default_from()
    |> subject("Your Telephone Pictionary game is ready: #{game.name}")
    |> render_with_layout(PictWeb.EmailHTML.game_ready(%{game: game}))
  end

  def submission_ready(%{submission: submission, starter_name: starter_name, total: total}) do
    prompt_name = "#{starter_name} #{submission.order + 1}/#{total}"
    new()
    |> to(submission.player)
    |> default_from()
    |> subject("#{submission_ready_title(submission)}: #{prompt_name}")
    |> render_with_layout(PictWeb.EmailHTML.submission_ready(
      %{submission: submission, owner_name: starter_name}
    ))
  end

  defp submission_ready_title(submission) do
    if Prompts.expects_drawing?(submission) do
      "Time to draw in Telephone Pictionary"
    else
      "Time to guess in Telephone Pictionary"
    end
  end

  def submission_reminder(%{submission: submission, starter_name: starter_name, total: total}) do
    prompt_name = "#{starter_name} #{submission.order + 1}/#{total}"
    new()
    |> to(submission.player)
    |> default_from()
    |> subject("Your turn is waiting for you in Telephone Pictionary: #{prompt_name}")
    |> render_with_layout(PictWeb.EmailHTML.submission_reminder(
      %{submission: submission, owner_name: starter_name, message: reminder_message()}
    ))
  end

  defp reminder_message do
    Enum.random([
      "Fuck you doin?",
      "You're late and everyone has noticed. How embarrassing!",
      "Did you lose your pencil?",
      "Clock's ticking, pal!",
      "You're not trying to draw \"heat death of the universe\".",
      "Must go faster!"
    ])
  end

  def prompt_ready(submission, owner) do
    new()
    |> to(submission.player)
    |> default_from()
    |> subject("You've been invited to play Telephone Pictionary")
    |> render_with_layout(PictWeb.EmailHTML.prompt_ready(
      %{submission: submission, owner: owner}
    ))
  end
end
