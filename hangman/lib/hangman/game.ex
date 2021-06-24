defmodule Hangman.Game do
  defstruct(
    turns_left: 7,
    game_state: :initializing,
    letters: [],
    used: MapSet.new()
  )

  def new_game(word) do
    %Hangman.Game{
      letters: word |> String.codepoints()
    }
  end

  def new_game() do
    new_game(Dictionary.random_word)
  end

  def make_move(game = %Hangman.Game{game_state: state}, _guess) when state in [:won, :lost],
    do: {game, tally(game)}

  def make_move(game, guess) do
    accept_move(game, guess, MapSet.member?(game.used, guess))
  end

  def accept_move(game, _guess, _allready_guessed = true) do
    { Map.put(game, :game_state, :already_used), tally(game) }
  end

  def accept_move(game, guess, _allready_guessed) do
    {
      Map.put(game, :used, MapSet.put(game.used, guess))
      |> score_guess(Enum.member?(game.letters, guess)),
      tally(game)
    }
  end

  def score_guess(game, _good_guess = true) do
    new_state = MapSet.new(game.letters)
    |> MapSet.subset?(game.used)
    |> maybe_won()
    Map.put(game, :game_state, new_state)
  end

  def score_guess(game, _not_good_guess) do
    game
  end

  def tally(_game) do
    :placeholder
  end

  def maybe_won(true), do: :won
  def maybe_won(_), do: :good_guess
end
