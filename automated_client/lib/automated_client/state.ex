defmodule AutomatedClient.State do
  defstruct(
    game_service: nil,
    tally: nil,
    guess: "",
    wrong_words: MapSet.new()
  )
end
