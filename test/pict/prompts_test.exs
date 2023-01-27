defmodule Pict.PromptsTest do
  use Pict.DataCase

  alias Pict.Prompts

  describe "prompts" do
    alias Pict.Prompts.Prompt

    import Pict.PromptsFixtures

    @invalid_attrs %{}

    test "list_prompts/0 returns all prompts" do
      prompt = prompt_fixture()
      assert Prompts.list_prompts() == [prompt]
    end

    test "get_prompt!/1 returns the prompt with given id" do
      prompt = prompt_fixture()
      assert Prompts.get_prompt!(prompt.id) == prompt
    end

    test "create_prompt/1 with valid data creates a prompt" do
      valid_attrs = %{}

      assert {:ok, %Prompt{} = prompt} = Prompts.create_prompt(valid_attrs)
    end

    test "create_prompt/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Prompts.create_prompt(@invalid_attrs)
    end

    test "update_prompt/2 with valid data updates the prompt" do
      prompt = prompt_fixture()
      update_attrs = %{}

      assert {:ok, %Prompt{} = prompt} = Prompts.update_prompt(prompt, update_attrs)
    end

    test "update_prompt/2 with invalid data returns error changeset" do
      prompt = prompt_fixture()
      assert {:error, %Ecto.Changeset{}} = Prompts.update_prompt(prompt, @invalid_attrs)
      assert prompt == Prompts.get_prompt!(prompt.id)
    end

    test "delete_prompt/1 deletes the prompt" do
      prompt = prompt_fixture()
      assert {:ok, %Prompt{}} = Prompts.delete_prompt(prompt)
      assert_raise Ecto.NoResultsError, fn -> Prompts.get_prompt!(prompt.id) end
    end

    test "change_prompt/1 returns a prompt changeset" do
      prompt = prompt_fixture()
      assert %Ecto.Changeset{} = Prompts.change_prompt(prompt)
    end
  end

  describe "submissions" do
    alias Pict.Prompts.Submission

    import Pict.PromptsFixtures

    @invalid_attrs %{completed: nil, order: nil, text: nil}

    test "list_submissions/0 returns all submissions" do
      submission = submission_fixture()
      assert Prompts.list_submissions() == [submission]
    end

    test "get_submission!/1 returns the submission with given id" do
      submission = submission_fixture()
      assert Prompts.get_submission!(submission.id) == submission
    end

    test "create_submission/1 with valid data creates a submission" do
      valid_attrs = %{completed: true, order: 42, text: "some text"}

      assert {:ok, %Submission{} = submission} = Prompts.create_submission(valid_attrs)
      assert submission.completed == true
      assert submission.order == 42
      assert submission.text == "some text"
    end

    test "create_submission/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Prompts.create_submission(@invalid_attrs)
    end

    test "update_submission/2 with valid data updates the submission" do
      submission = submission_fixture()
      update_attrs = %{completed: false, order: 43, text: "some updated text"}

      assert {:ok, %Submission{} = submission} = Prompts.update_submission(submission, update_attrs)
      assert submission.completed == false
      assert submission.order == 43
      assert submission.text == "some updated text"
    end

    test "update_submission/2 with invalid data returns error changeset" do
      submission = submission_fixture()
      assert {:error, %Ecto.Changeset{}} = Prompts.update_submission(submission, @invalid_attrs)
      assert submission == Prompts.get_submission!(submission.id)
    end

    test "delete_submission/1 deletes the submission" do
      submission = submission_fixture()
      assert {:ok, %Submission{}} = Prompts.delete_submission(submission)
      assert_raise Ecto.NoResultsError, fn -> Prompts.get_submission!(submission.id) end
    end

    test "change_submission/1 returns a submission changeset" do
      submission = submission_fixture()
      assert %Ecto.Changeset{} = Prompts.change_submission(submission)
    end
  end

  describe "submissions" do
    alias Pict.Prompts.Submission

    import Pict.PromptsFixtures

    @invalid_attrs %{}

    test "list_submissions/0 returns all submissions" do
      submission = submission_fixture()
      assert Prompts.list_submissions() == [submission]
    end

    test "get_submission!/1 returns the submission with given id" do
      submission = submission_fixture()
      assert Prompts.get_submission!(submission.id) == submission
    end

    test "create_submission/1 with valid data creates a submission" do
      valid_attrs = %{}

      assert {:ok, %Submission{} = submission} = Prompts.create_submission(valid_attrs)
    end

    test "create_submission/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Prompts.create_submission(@invalid_attrs)
    end

    test "update_submission/2 with valid data updates the submission" do
      submission = submission_fixture()
      update_attrs = %{}

      assert {:ok, %Submission{} = submission} = Prompts.update_submission(submission, update_attrs)
    end

    test "update_submission/2 with invalid data returns error changeset" do
      submission = submission_fixture()
      assert {:error, %Ecto.Changeset{}} = Prompts.update_submission(submission, @invalid_attrs)
      assert submission == Prompts.get_submission!(submission.id)
    end

    test "delete_submission/1 deletes the submission" do
      submission = submission_fixture()
      assert {:ok, %Submission{}} = Prompts.delete_submission(submission)
      assert_raise Ecto.NoResultsError, fn -> Prompts.get_submission!(submission.id) end
    end

    test "change_submission/1 returns a submission changeset" do
      submission = submission_fixture()
      assert %Ecto.Changeset{} = Prompts.change_submission(submission)
    end
  end
end
