defmodule PictWeb.SubmissionView do
  use PictWeb, :view
  alias Pict.Prompts.Submission
  require Integer

  def expects_drawing?(%Submission{order: order}) do
    Integer.is_odd(order)
  end

  def drawing_url(submission) do
    Pict.Drawing.url({submission.drawing, nil}, :large)
  end
end
