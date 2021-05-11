defmodule Hangman.Game do
  defstruct(
    turns_left: 7,
    game_state: :initializing,
    lettrs: []
  )

  def new_game() do
    %Hangman.Game{lettrs: Dictionary.random_word() |> String.codepoints()}
  end
end
