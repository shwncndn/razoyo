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

  def export(orders) do
    orders
    |> IO.inspect(label: "ORDERS COMING IN FROM EXECUTOR")
    |> String.trim("\"")
    |> parse()
    |> IO.inspect(label: "ORDERS POST PARSE")
    |> Jason.encode!()
    |> File.write!("orders.json")
    |> IO.inspect(label: "ORDER")
  end

  def parse(lines) do
    Enum.map(lines, fn line ->
      line
      |> String.trim()
      |> parse_line()
    end)
  end

  defp parse_line(line) do
    [type, id, subtotal, tax, total, customer_id] = String.split(line, ",")

    subtotal = String.to_float(subtotal)
    tax = String.to_float(tax)
    total = String.to_float(total)

    %Order{
      type: String.trim(type, "\""),
      id: String.trim(id, "\""),
      subtotal: subtotal,
      tax: tax,
      total: total,
      customer_id: String.trim(customer_id, "\"")
    }
  end


    def link_lines(orders, lines) do
      Enum.map(orders, fn order ->
        order_lines =
          lines
          |> Enum.filter(fn line ->
            line.order_id == order.id
          end)

        Map.put(order, :order_lines, order_lines)
      end)
    end

  def parse_order_line(line) do
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
