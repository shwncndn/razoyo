defmodule Order do
  @enforce_keys [
    :type,
    :id,
    :subtotal,
    :tax,
    :total,
    :customer_id
  ]
  defstruct @enforce_keys

  def export(var) do
    var
    |> parse()
  end


  defp parse(order_lines) do
    orders = Enum.filter(order_lines, &String.starts_with?(&1, "order"))
    lines = Enum.filter(order_lines, &String.starts_with?(&1, "order-line"))

    orders = Enum.map(orders, &parse_order/1)

    orders
    |> Enum.map(&link_lines(&1, lines))
  end

  defp parse_order(line) do
    [_, type, id, subtotal, tax, total, customer_id] = String.split(line, ",")

    subtotal = String.to_float(subtotal)
    tax = String.to_float(tax)
    total = String.to_float(total)

    %Order{
      type: type,
      id: id,
      subtotal: subtotal,
      tax: tax,
      total: total,
      customer_id: customer_id
    }
  end

  defp link_lines(order, lines) do
    %{order | order_lines: Enum.map(lines, &parse_order_line/1)}
  end

  defp parse_order_line(line) do
    [type, position, name, price, quantity] = String.split(line, ",")

    position = String.to_integer(position)
    price = String.to_float(price)
    quantity = String.to_integer(quantity)

    %{
      type: type,
      position: position,
      name: name,
      price: price,
      quantity: quantity,
      row_total: price * quantity
    }
  end
end
