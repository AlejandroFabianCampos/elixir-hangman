defmodule GameTest do
  use ExUnit.Case
  alias Hangman.Game

  test "new_game returns structure" do
    game = Game.new_game()

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
  end

  test "game.letters are lowercase ASCII letters (a-z)" do
    game = Game.new_game()

    Enum.each(game.letters, fn letter -> assert letter =~ ~r/[a-z]/ end)
  end

  test "state isn't changed for :won or :lost game" do
    for state <- [:won, :lost] do
      game = Game.new_game() |> Map.put(:game_state, state)
      assert {^game, _} = Game.make_move(game, "x")
    end
  end

  test "first occurence of letter is not already used" do
    game = Game.new_game()
    { game, _tally } = Game.make_move(game, "x")
    assert game.game_state != :already_used
  end

  test "used letter isn't allowed a second time" do
    test_letter = "x"
    game = Game.new_game()
    {game, _tally } = Game.make_move(game, test_letter)
    assert game.game_state != :already_used
    assert test_letter in game.used
    {game, _tally } = Game.make_move(game, test_letter)
    assert game.game_state == :already_used
  end

  test "a good guess is recognized" do
    game = Game.new_game("wibble")
    {game, _tally} = Game.make_move(game, "w")
    assert game.game_state == :good_guess
    assert game.turns_left == 7
  end



  test "a guessed word is a won game" do
    moves = [
      {"w", :good_guess},
      {"i", :good_guess},
      {"b", :good_guess},
      {"l", :good_guess},
      {"e", :won}
    ]

    game = Game.new_game("wibble")

    Enum.reduce(
      moves,
      game,
      fn ({guess, expected_state}, game) ->
        { game, _tally } = Game.make_move(game, guess)
        assert game.game_state == expected_state
        assert game.turns_left == 7
        game
      end
    )
  end

  test "bad guess is recognized" do
    game = Game.new_game("wibble")
    { game, _tally} = Game.make_move(game, "f")
    assert game.turns_left == 6
    assert game.game_state == :bad_guess
  end

  test "new lost game" do
    moves = [
      {"a", :bad_guess, 6},
      {"b", :bad_guess, 5},
      {"c", :bad_guess, 4},
      {"d", :bad_guess, 3},
      {"e", :bad_guess, 2},
      {"f", :bad_guess, 1},
      {"g", :lost, 1},
    ]

    game = Game.new_game("w")

    Enum.reduce(
      moves,
      game,
      fn ({guess, expected_state, expected_turns_left}, game) ->
        { game, _tally } = Game.make_move(game, guess)
        assert game.game_state == expected_state
        assert game.turns_left == expected_turns_left
        game
      end
    )
  end
end
