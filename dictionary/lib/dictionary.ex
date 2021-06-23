defmodule Dictionary do
  @spec word_list :: [binary]
  def word_list do
    "../assets/words.txt"
    |> Path.expand(__DIR__)
    |> File.read!()
    |> String.split(~r/\n/)
  end

  @spec random_word :: binary
  def random_word do
    word_list()
    |> Enum.random()
  end
end
