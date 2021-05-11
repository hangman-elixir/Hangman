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

  test "state isn't changed for :won or :lost game" do
    for state <- [:won, :lost] do
      game = Game.new_game() |> Map.put(:game_state, state)
      assert {^game, _} = Game.make_move(game, "x")
    end
  end

  test "first occurrences of letter is not already used" do
    game = Game.new_game()
    {game, _tally} = Game.make_move(game, "x")
    assert game.game_state != :already_used
  end

  test "second occurrences of letter is already used" do
    game = Game.new_game()
    {game, _tally} = Game.make_move(game, "x")
    assert game.game_state != :already_used
    {game, _tally} = Game.make_move(game, "x")
    assert game.game_state == :already_used
  end

  test "a good guess is recognized" do
    game = Game.new_game("foo")
    {game, _tally} = Game.make_move(game, "f")
    assert game.game_state == :good_guess
    assert game.turns_left == 7
  end

  test "a guessed word is :won game" do
    game = Game.new_game("foo")
    {game, _tally} = Game.make_move(game, "f")
    assert game.game_state == :good_guess
    assert game.turns_left == 7
    {game, _tally} = Game.make_move(game, "o")
    assert game.game_state == :won
    assert game.turns_left == 7
  end
end
