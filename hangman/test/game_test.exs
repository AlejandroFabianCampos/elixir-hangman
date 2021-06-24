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
end
