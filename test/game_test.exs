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
      assert ^game = Game.make_move(game, "x")
    end
  end

  test "first occurrences of letter is not already used" do
    game = Game.new_game()
    game = Game.make_move(game, "x")
    assert game.game_state != :already_used
  end

  test "second occurrences of letter is already used" do
    game = Game.new_game()
    game = Game.make_move(game, "x")
    assert game.game_state != :already_used
    game = Game.make_move(game, "x")
    assert game.game_state == :already_used
  end

  test "a good guess is recognized" do
    game = Game.new_game("foo")
    game = Game.make_move(game, "f")
    assert game.game_state == :good_guess
    assert game.turns_left == 7
  end

  test "bad guess is recognized" do
    game = Game.new_game("foo")
    game = Game.make_move(game, "x")
    assert game.game_state == :bad_guess
    assert game.turns_left == 6
  end

  test "won game is recognized" do
    game = Game.new_game("wibble")

    moves = [
      {"w", :good_guess},
      {"i", :good_guess},
      {"b", :good_guess},
      {"l", :good_guess},
      {"e", :won}
    ]

    _game =
      Enum.reduce(moves, game, fn {guess, state} = _move, acc ->
        new_game = Game.make_move(acc, guess)
        assert new_game.game_state == state
        new_game
      end)
  end

  test "lost game is recognized" do
    game = Game.new_game("wibble")

    moves = [
      {"a", :bad_guess},
      {"c", :bad_guess},
      {"b", :good_guess},
      {"d", :bad_guess},
      {"f", :bad_guess},
      {"h", :bad_guess},
      {"q", :bad_guess},
      {"x", :lost}
    ]

    _game =
      Enum.reduce(moves, game, fn {guess, state} = _move, acc ->
        new_game = Game.make_move(acc, guess)
        assert new_game.game_state == state
        new_game
      end)
  end
end
