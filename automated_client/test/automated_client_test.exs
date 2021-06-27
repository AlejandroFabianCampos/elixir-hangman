defmodule AutomatedClientTest do
  use ExUnit.Case
  doctest AutomatedClient

  test "greets the world" do
    assert AutomatedClient.hello() == :world
  end
end
