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
end
