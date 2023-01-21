defmodule PictWeb.Emails.UserEmail do
  use Phoenix.Swoosh, view: PictWeb.EmailView, layout: {PictWeb.LayoutView, :email}

  def submission_ready(submission) do
    new()
    |> to(submission.player)
    |> from({"Telephone Pictionary", "pict@example.com"})
    |> subject("Take your turn in Telephone Pictionary")
    |> render_body("submission_ready.html", %{submission: submission})
  end
end
