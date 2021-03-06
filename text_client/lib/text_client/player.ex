defmodule TextClient.Player do
  alias TextClient.{Mover, State, Summary, Prompter}

  # won, lost, good guess, bad guess, already used, initializing
  def play(%State{tally: %{ game_state: :won, full_word: full_word }}) do
    exit_with_message("You WON!! The word was: #{full_word}")
  end

  def play(%State{tally: %{ game_state: :lost, full_word: full_word }}) do
    exit_with_message("You lost :(. The word was: #{full_word}")
  end

  def play(game = %State{tally: %{ game_state: :good_guess }}) do
    continue_with_message(game, "Good guess!")
  end

  def play(game = %State{tally: %{ game_state: :bad_guess }}) do
    continue_with_message(game, "Err, wrong")
  end

  def play(game = %State{tally: %{ game_state: :already_used }}) do
    continue_with_message(game, "You've already used that letter")
  end

  def play(game) do
    continue(game)
  end

  def continue_with_message(game, msg) do
    IO.puts(msg)
    continue(game)
  end

  def continue(game) do
    game
    |> Summary.display()
    |> Prompter.accept_move()
    |> Mover.move()
    |> play()
  end

  def display(game) do
    game
  end

  def prompt(game) do
    game
  end

  def make_move(game) do
    game
  end

  defp exit_with_message(msg) do
    IO.puts(msg)
    exit(:normal)
  end
end
