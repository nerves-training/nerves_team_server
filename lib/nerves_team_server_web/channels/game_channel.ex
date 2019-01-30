defmodule NervesTeamServerWeb.GameChannel do
  use NervesTeamServerWeb, :channel

  alias NervesTeamGame.Lobby

  def join("game:lobby", payload, socket) do
    if authorized?(payload) do
      {:ok, player} = Lobby.add_player()
      {:ok, assign(socket, :player, player)}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("player:ready", %{"ready" => ready?}, socket) do
    {:ok, _player} =
      Lobby.ready_player(socket.assigns.player.id, ready?)
    {:reply, :ok, socket}
  end

  # Pass messages from game server to the client
  def handle_info({event, payload}, socket) do
    push(socket, event, payload)
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
