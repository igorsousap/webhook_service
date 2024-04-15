defmodule Broadway do
  require Logger
  alias Converter
  alias ProducerMessage.Sender.SenderMessage

  def broadway_message(
        %{
          currencie_from: currencie_from,
          currencie_to: currencie_to,
          value_to_convert: value_to_convert
        } = params
      ) do
    valued_converted = Converter.converter_table(currencie_from, currencie_to, value_to_convert)
    params = Map.put(params, :message_id, Ecto.UUID.autogenerate())

    case valued_converted do
      {:error, :unsuported_code} ->
        {:error, :unsuported_code}

      _ ->
        build_broadway_message(valued_converted, params)
        |> SenderMessage.send_message()
    end
  end

  defp build_broadway_message(value_converted, %{value_to_convert: value_to_convert} = params)
       when is_integer(value_to_convert) do
    params
    |> Map.put(:value_to_convert, Integer.to_string(params.value_to_convert))
    |> Map.merge(value_converted)
  end

  defp build_broadway_message(value_converted, %{value_to_convert: value_to_convert} = params)
       when is_float(value_to_convert) do
    params
    |> Map.put(:value_to_convert, Float.to_string(params.value_to_convert))
    |> Map.merge(value_converted)
  end
end