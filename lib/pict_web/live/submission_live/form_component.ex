defmodule PictWeb.SubmissionLive.FormComponent do
  use PictWeb, :live_component

  require Integer

  alias Pict.Prompts
  alias Pict.Prompts.Submission

  @impl true
  def mount(socket) do
    {:ok,
      socket
      |> assign(:uploaded_files, [])
      |> allow_upload(:drawing, accept: ~w(.jpg .jpeg .png))
    }
  end

  def expects_drawing?(%Submission{order: order}) do
    Integer.is_odd(order)
  end

  @impl true
  def update(%{submission: submission} = assigns, socket) do
    changeset = Prompts.change_submission(submission)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"submission" => submission_params}, socket) do
    changeset =
      socket.assigns.submission
      |> Prompts.change_submission(submission_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"submission" => submission_params}, socket) do
    save_submission(socket, socket.assigns.action, submission_params)
  end

  defp save_submission(socket, :edit, submission_params) do
    case Prompts.update_submission(socket.assigns.submission, submission_params) do
      {:ok, _submission} ->
        {:noreply,
         socket
         |> put_flash(:info, "Submission updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_submission(socket, :new, submission_params) do
    case Prompts.create_submission(submission_params) do
      {:ok, _submission} ->
        {:noreply,
         socket
         |> put_flash(:info, "Submission created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
