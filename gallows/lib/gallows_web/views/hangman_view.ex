defmodule GallowsWeb.HangmanView do
  use GallowsWeb, :view

  @responses %{
    :won => { :success, "You Won!" },
    :lost => { :danger, "You Lost!" },
    :good_guess => { :success, "Good guess!" },
    :bad_guess => { :warning, "Bad guess!" },
    :already_used => { :info, "You already guessed that" },
    :invalid_guess => { :info, "Invalid guess" },
  }

  def game_over?(%{ game_state: game_state }) do
    game_state in [:won, :lost]
  end

  def new_game_button(conn) do
    button("New Game", to: Routes.hangman_path(conn, :create_game))
  end

  def guess_renderer(character_list) do
    character_list
    |> Enum.join(" ")
  end

  def game_state(state) do
    @responses[state]
    |> alert()
  end

  defp alert(nil), do: ""
  defp alert({class, message}) do
    """
    <div class="alert alert-#{class}">
      #{message}
    </div>
    """
    |> raw()
  end
end
