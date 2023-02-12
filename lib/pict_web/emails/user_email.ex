defmodule PictWeb.Emails.UserEmail do
  use Phoenix.Swoosh, view: PictWeb.EmailView, layout: {PictWeb.LayoutView, :email}

  defp default_from(mail) do
    from_addr = System.get_env("PHX_EMAIL_FROM") || "pict@example.com"
    from(mail, {"Telephone Pictionary", from_addr})
  end

  def game_ready(game) do
    new()
    |> to(game.owner)
    |> default_from()
    |> subject("Your Telephone Pictionary game is ready: #{game.name}")
    |> render_body("game_ready.html", %{game: game})
  end

  def submission_ready(%{submission: submission, starter: starter, total: total}) do
    prompt_name = "#{starter.name} #{submission.order + 1}/#{total}"
    new()
    |> to(submission.player)
    |> default_from()
    |> subject("Take your turn in Telephone Pictionary (#{prompt_name})")
    |> render_body("submission_ready.html", %{submission: submission, owner_name: starter.name})
  end

  def prompt_ready(submission, owner) do
    new()
    |> to(submission.player)
    |> default_from()
    |> subject("You've been invited to play Telephone Pictionary")
    |> render_body("prompt_ready.html", %{submission: submission, owner: owner})
  end
end
