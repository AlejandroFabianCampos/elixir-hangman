defmodule Dictionary.WordList do
  @spec word_list :: [binary]
  def word_list do
    "../../assets/words.txt"
    |> Path.expand(__DIR__)
    |> File.read!()
    |> String.split(~r/\n/)
  end

  def random_word(custom_word_list) do
    custom_word_list
    |> Enum.random()
  end

  def filtered_word_list(length_of_word) do
    word_list()
    |> Enum.filter(fn string -> String.length(string) == length_of_word end)
  end


  # ===== Deprecated =====
  @spec random_word :: binary
  def random_word() do
    IO.warn "This is deprecated, switch to using random_word/1"
    word_list()
    |> Enum.random()
  end
end
