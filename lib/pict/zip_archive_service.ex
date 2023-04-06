defmodule Pict.ZipArchiveService do
  alias Pict.Prompts

  def create(game) do
    {:ok, path} = Briefly.create()
    {:ok, zip_path} = :zip.create(path, files_for_download(game))
    zip_path
  end

  defp files_for_download(game) do
    Prompts.get_prompts_for_download(game.admin_id)
    |> Enum.flat_map(&submissions_for_download/1)
  end

  defp submissions_for_download(prompt) do
    prompt_complete = Enum.all?(prompt.submissions, fn s -> s.completed end)
    owner = prompt.owner
    prompt_name = if prompt_complete, do: owner.name, else: "#{owner.name} (Incomplete)"
    for submission <- prompt.submissions, submission.completed do
      zip_file_entry(submission, Path.join(prompt_name, "#{owner.name} #{submission.order}"))
    end
  end

  defp zip_file_entry(submission = %{drawing: nil, text: text}, basename) do
    {to_charlist(basename <> ".txt"), text}
  end

  defp zip_file_entry(submission = %{drawing: drawing}, basename) do
    dir = Application.fetch_env!(:pict, :uploads_path)
    filename = Waffle.Definition.Versioning.resolve_file_name(
      Pict.Drawing, :original, {drawing, submission}
    )
    case File.read(Path.expand(filename, dir)) do
      {:ok, data} ->
        {to_charlist(basename <> Path.extname(filename)), data}
    end
  end
end
