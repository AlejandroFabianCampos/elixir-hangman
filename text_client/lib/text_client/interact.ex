defmodule TextClient.Interact do
  alias TextClient.{Player, State}

  # We extract current machine_name as by default this will expect
  # a local Hangman node
  { :ok, machine_name } = :inet.gethostname()

  @hangman_server :'hangman@#{machine_name}'

  def start() do
    new_game()
    |> setup_state()
    |> Player.play()
  end

  defp setup_state(game) do
    %State{
      game_service: game,
      tally: Hangman.tally(game),
    }
  end

  defp new_game() do
    :rpc.call(@hangman_server,
      Hangman,
      :new_game,
      []
    )
  end
end
