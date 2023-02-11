defmodule PictWeb.Emails.UserEmail do
  use Phoenix.Swoosh, view: PictWeb.EmailView, layout: {PictWeb.LayoutView, :email}

  defp default_from(mail) do
    host = System.get_env("PHX_HOST") || "example.com"
    from(mail, {"Telephone Pictionary", "pict@#{host}"})
  end

  def game_ready(game) do
    new()
    |> to(game.owner)
    |> default_from()
    |> subject("Your Telephone Pictionary game is ready: #{game.name}")
    |> render_body("game_ready.html", %{game: game})
  end

  def submission_ready(submission) do
    new()
    |> to(submission.player)
    |> default_from()
    |> subject("Take your turn in Telephone Pictionary")
    |> render_body("submission_ready.html", %{submission: submission})
  end

  def prompt_ready(submission, owner) do
    new()
    |> to(submission.player)
    |> default_from()
    |> subject("You've been invited to play Telephone Pictionary")
    |> render_body("prompt_ready.html", %{submission: submission, owner: owner})
  end
end
