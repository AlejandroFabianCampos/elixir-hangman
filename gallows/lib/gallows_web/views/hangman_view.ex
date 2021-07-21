defmodule GallowsWeb.HangmanView do
  use GallowsWeb, :view

  def guess_renderer(character_list) do
    character_list
    |> Enum.join(" ")
  end
end
