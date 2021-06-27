defmodule AutomatedClient.Coordinator do
  alias AutomatedClient.{Brain, State}

  def continue(%State{ tally: %{ game_state: game_state }}) when game_state in [:won, :lost] do
    IO.puts """
      Game ended! You #{game_state}
    """
  end

  def continue(
    state =
      %State{
        game_service: %{ game_state: game_state},
        guess: wrong_word_guess,
        wrong_words: current_banned_words
      }
    ) when game_state in [:bad_guess, :already_used] do
    IO.puts """
      Wrong word guess
    """
    struct(state, %{
      wrong_words: MapSet.put(current_banned_words, wrong_word_guess)})
    |> Brain.make_move()
    |> iterate_cycle()
  end

  def continue(state = %State{}) do
    state
    |> Brain.make_move()
    |> iterate_cycle()
  end

  defp iterate_cycle(state = %State{}) do
    IO.puts """
      Executing game cycle!
      Current game state: #{state.tally.game_state}
      Wrong intents left: #{state.tally.turns_left}
      Current letters guessed: #{state.tally.letters |> List.to_string}
      Letters already used: #{state.tally.used |> MapSet.to_list |> List.to_string}
      Banned words already found incorrect: #{state.wrong_words |> MapSet.to_list() |> Enum.join(" ")}
      \n
    """
    continue(state)
  end

  def start() do
    Hangman.new_game()
    |> initialize_state()
    |> continue()
  end

  defp initialize_state(game) do
    %State{
      game_service: game,
      tally: Hangman.tally(game),
      guess: ""
    }
  end

end
