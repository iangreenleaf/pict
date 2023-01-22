defmodule PictWeb.Emails.UserEmail do
  use Phoenix.Swoosh, view: PictWeb.EmailView, layout: {PictWeb.LayoutView, :email}

  def submission_ready(submission) do
    new()
    |> to(submission.player)
    |> from({"Telephone Pictionary", "pict@example.com"})
    |> subject("Take your turn in Telephone Pictionary")
    |> render_body("submission_ready.html", %{submission: submission})
  end

  def prompt_ready(submission, owner) do
    new()
    |> to(submission.player)
    |> from({"Telephone Pictionary", "pict@example.com"})
    |> subject("You've been invited to play Telephone Pictionary")
    |> render_body("prompt_ready.html", %{submission: submission, owner: owner})
  end
end
