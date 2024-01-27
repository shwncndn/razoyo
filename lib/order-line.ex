defmodule OrderLine do
  @enforce_keys [
    :type,
    :position,
    :name,
    :price,
    :quantity,
    :row_total
  ]
  defstruct @enforce_keys

  def export(var) do
    var
    |> IO.inspect(label: "BEFORE")
    |> parse()
    |> IO.inspect(label: "AFTER")
  end

  def parse(lines) do
    Enum.map(lines, fn line ->
      line
      |> String.trim()
      |> parse_line()
    end)
  end

  defp parse_line(line) do
    [type, position, name, price, quantity] = String.split(line, ",")

    position = String.to_integer(position)
    price = String.to_float(price)
    quantity = String.to_integer(quantity)

    %OrderLine{
      type: String.trim(type, "\""),
      position: position,
      name: String.trim(name, "\""),
      price: price,
      quantity: quantity,
      row_total: price * quantity
    } |> IO.inspect(label: "ORDER LINE STRUCT")
  end
end
