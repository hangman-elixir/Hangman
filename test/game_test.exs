defmodule GameTest do
  use ExUnit.Case

  alias Hangman.Game, as: Game

  test "new_game returns structure" do
    game = Game.new_game()
    assert(game.turns_left == 7)
    assert(game.game_state == :initializing)
    assert(length(game.letters) > 0)
    assert(Enum.all?(game.letters, fn x -> x >= "a" && x <= "z" && String.length(x) == 1 end))
  end
end
