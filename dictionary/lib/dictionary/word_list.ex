defmodule Dictionary.WordList do

  @me __MODULE__

  def start_link() do
    Agent.start_link(&word_list/0, name: @me)
  end

  @spec word_list :: [binary]
  def word_list do
    "../../assets/words.txt"
    |> Path.expand(__DIR__)
    |> File.read!()
    |> String.split(~r/\n/)
  end

  def filtered_word_list(length_of_word) do
    word_list()
    |> Enum.filter(fn string -> String.length(string) == length_of_word end)
  end

  @spec random_word :: binary
  def random_word() do
    Agent.get(@me, &Enum.random/1)
  end
end
