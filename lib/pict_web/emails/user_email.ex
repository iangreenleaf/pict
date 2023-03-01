defmodule PictWeb.Emails.UserEmail do
  import Swoosh.Email

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

  def submission_ready(%{submission: submission, starter: starter, total: total}) do
    prompt_name = "#{starter.name} #{submission.order + 1}/#{total}"
    new()
    |> to(submission.player)
    |> default_from()
    |> subject("Take your turn in Telephone Pictionary (#{prompt_name})")
    |> render_with_layout(PictWeb.EmailHTML.submission_ready(
      %{submission: submission, owner_name: starter.name}
    ))
  end

  def submission_reminder(%{submission: submission, starter: starter, total: total}) do
    prompt_name = "#{starter.name} #{submission.order + 1}/#{total}"
    new()
    |> to(submission.player)
    |> default_from()
    |> subject("Your turn is waiting for you in Telephone Pictionary: (#{prompt_name})")
    |> render_with_layout(PictWeb.EmailHTML.submission_reminder(
      %{submission: submission, owner_name: starter.name}
    ))
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
