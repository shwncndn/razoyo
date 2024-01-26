defmodule OrderLine do
  @derive Jason.Encoder
  @enforce_keys [
    :type,
    :position,
    :name,
    :price,
    :quantity,
    :row_total
  ]
  defstruct @enforce_keys

  def parse(lines) do
     Enum.map(lines, &parse_line/1)
  end

  defp parse_line(line) do
    [type, position, name, price, quantity] = String.split(line, ",")

    position = String.to_integer(position)
    price = String.to_float(price)
    quantity = String.to_integer(quantity)


    %OrderLine{
      type: type,
      position: position,
      name: name,
      price: price,
      quantity: quantity,
      row_total: price * quantity
    }
  end
end
