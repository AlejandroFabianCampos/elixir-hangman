defmodule Dictionary do
  alias Dictionary.WordList

  defdelegate start(), to: WordList, as: :word_list
  defdelegate random_word(custom_word_list), to: WordList
  defdelegate filtered_word_list(length_of_word), to: WordList

  # ==== Deprecated ====
  defdelegate word_list(), to: WordList
  defdelegate random_word(), to: WordList

end
