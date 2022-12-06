defmodule Pict.PromptsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pict.Prompts` context.
  """

  @doc """
  Generate a prompt.
  """
  def prompt_fixture(attrs \\ %{}) do
    {:ok, prompt} =
      attrs
      |> Enum.into(%{

      })
      |> Pict.Prompts.create_prompt()

    prompt
  end

  @doc """
  Generate a submission.
  """
  def submission_fixture(attrs \\ %{}) do
    {:ok, submission} =
      attrs
      |> Enum.into(%{
        completed: true,
        order: 42,
        text: "some text"
      })
      |> Pict.Prompts.create_submission()

    submission
  end
end
