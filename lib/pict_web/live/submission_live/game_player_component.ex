defmodule PictWeb.SubmissionLive.GamePlayerComponent do
  use PictWeb, :live_component

  alias Pict.Games

  @impl true
  def update(%{game_player: game_player} = assigns, socket) do
    changeset = Games.change_game_player(game_player)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"game_player" => game_player_params}, socket) do
    changeset =
      socket.assigns.game_player
      |> Games.change_game_player(game_player_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"game_player" => game_player_params}, socket) do
    save_game_player(socket, game_player_params)
  end

  defp save_game_player(socket, game_player_params) do
    case Games.update_game_player(socket.assigns.game_player, game_player_params) do
      {:ok, _game_player} ->
        {:noreply,
         socket
         |> put_flash(:info, "Player updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
