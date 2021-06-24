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
    new_game =
      Map.put(game, :used, MapSet.put(game.used, guess))
      |> score_guess(Enum.member?(game.letters, guess))
    {
      new_game,
      tally(new_game)
    }
  end

  def score_guess(game, _good_guess = true) do
    new_state = MapSet.new(game.letters)
    |> MapSet.subset?(game.used)
    |> maybe_won()
    Map.put(game, :game_state, new_state)
  end

  def score_guess(game = %Hangman.Game{turns_left: 1}, _not_good_guess) do
    Map.put(game, :game_state, :lost)
  end

  def score_guess(game= %Hangman.Game{turns_left: turns_left}, _not_good_guess) do
    %{
      game |
      turns_left: (turns_left - 1),
      game_state: :bad_guess
    }
  end

  def tally(game) do
    %{
      game_state: game.game_state,
      turns_left: game.turns_left,
      letters: game.letters |> reveal_guessed(game.used)
    }
  end

  def reveal_guessed(letters, used) do
    letters
    |> Enum.map(fn letter -> reveal_letter(letter, MapSet.member?(used, letter)) end)
  end

  def reveal_letter(letter, _in_word = true), do: letter
  def reveal_letter(_letter, _not_in_word), do: "_"

  def maybe_won(true), do: :won
  def maybe_won(_), do: :good_guess
end
