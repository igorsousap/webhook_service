defmodule Producer.ProducerController do
  use Producer, :controller
  alias ProducerMessage

  plug :accepts, ~w(json ...)

  @spec send_message(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def send_message(conn, params) do
    message_build = build_params(params)

    case ProducerMessage.producer_message(message_build) do
      {:error, :unknow_reason} ->
        render(conn, :index, %{erro: :unknow_reason})

      {:error, body} ->
        render(conn, :index, %{error: body})

      {:ok, :message_send} ->
        render(conn, :index, %{message: :sucess_send})
    end
  end

  defp build_params(params) do
    %{
      event_type: params["event_type"],
      client: params["client"],
      currencie_from: params["currencie_from"],
      currencie_to: params["currencie_to"],
      value_to_convert: params["value_to_convert"],
      schedule_at: params["schedule_at"]
    }
  end
end
