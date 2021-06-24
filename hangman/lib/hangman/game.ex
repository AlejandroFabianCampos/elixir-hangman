defmodule Hangman.Game do
  defstruct(
    turns_left: 7,
    game_state: :initializing,
    letters: [],
    used: MapSet.new()
  )

  def new_game() do
    %Hangman.Game{
      letters: Dictionary.random_word() |> String.codepoints()
    }
  end

  def make_move(game = %Hangman.Game{game_state: state}, _guess) when state in [:won, :lost],
    do: {game, tally(game)}

  def make_move(game, guess) do
    accept_move(game, guess, MapSet.member?(game.used, guess))
  end

  def accept_move(game, _guess, _allready_guessed = true) do
    game = Map.put(game, :game_state, :already_used)
    { game, tally(game) }
  end

  def accept_move(game, guess, _allready_guessed) do
    game = Map.put(game, :used, MapSet.put(game.used, guess))
    { game, tally(game) }
  end

  def tally(_game) do
    :placeholder
  end
end
