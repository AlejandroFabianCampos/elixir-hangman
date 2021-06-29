defmodule Dictionary do
  alias Dictionary.WordList

  defdelegate filtered_word_list(length_of_word), to: WordList

  # ==== Deprecated ====
  defdelegate word_list(), to: WordList
  defdelegate random_word(), to: WordList

end
