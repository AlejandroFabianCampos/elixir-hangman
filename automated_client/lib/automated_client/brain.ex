defmodule AutomatedClient.Brain do
  alias AutomatedClient.{State}

  def make_move(state = %State{}) do
    state
    |> get_possible_words()
    |> get_best_word()
    |> get_best_guess()
    |> apply_guess()
  end

  def get_possible_words(state = %State{ tally: %{ letters: letters }}) do
    {
      state,
      letters
      |> List.to_string()
      |> String.length
      |> Dictionary.filtered_word_list
    }
  end

  def get_best_word({ state = %State{ tally: %{ letters: letters }}, possible_words }) do
    {
      state,
      possible_words
      |> Enum.find(
        fn word ->
          match_letters(letters, word |> String.codepoints)
          && !MapSet.member?(state.wrong_words, word)
        end
        )
    }
  end

  def get_best_guess({ state = %State{ tally: %{ letters: _letters, used: used }}, best_word }) do
    IO.puts """
      best word: #{best_word}
    """
    {
      state,
      best_word
      |> String.to_charlist()
      |> first_usable_letter(used),
      best_word
    }
  end

  def apply_guess({state = %State{ game_service: game_service }, best_guess, current_word_guess}) do
    {game = %Hangman.Game{}, tally} =
      game_service
      |> Hangman.make_move(List.to_string([best_guess]))

    struct(
      state,
      %{
        game_service: game,
        tally: tally,
        guess: current_word_guess
      }
    )
  end


  defp match_letters([letter], [match]) when letter == match or letter == "_", do: true
  defp match_letters([letter | word_tail], [match | match_tail]) when letter == match or letter == "_", do: match_letters(word_tail, match_tail)
  defp match_letters([letter | _word_tail], [match | _match_tail]) when letter != match, do: false

  defp first_usable_letter(word = [head | _tail], used_letters), do: first_usable_letter(word, used_letters, usable_letter?(head, used_letters))

  defp first_usable_letter([_head, next_letter | tail], used_letters, _usable_letter = false) do
    first_usable_letter([next_letter | tail], used_letters, usable_letter?(next_letter, used_letters))
  end
  defp first_usable_letter([head | _tail], _used_letters, _usable_letter = false), do: head
  defp first_usable_letter([head | _tail], _used_letters, _usable_letter = true), do: head

  defp usable_letter?(letter, used_letters) do
    !MapSet.member?(used_letters, List.to_string([letter]))
  end

end
