defmodule AutomatedClient do
  alias AutomatedClient.Coordinator

  defdelegate start, to: Coordinator

end
