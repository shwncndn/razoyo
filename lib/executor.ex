defmodule Razoyo.Executor do
  @moduledoc """

  """
  def extract(filepath) do
    contents = File.stream!(filepath) |> IO.inspect(label: "BEFORE GROUP BY")
    grouped_lines = Enum.group_by(contents, &get_line_type/1)

    |> IO.inspect(label: "AFTER GROUP BY")

    Enum.each(grouped_lines, fn {type, lines} ->
      type = String.trim(type, "\"")
      module = module_name(type)

      apply(module, :export, [lines])
    end)
  end
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
      |> parse()
      |> IO.inspect(label: "ORDERS POST PARSE")
      |> Enum.map(fn order ->
        %{
          "id" => order.id,
          "head" => %{
            "subtotal" => order.subtotal,
            "tax" => order.tax,
            "total" => order.total,
            "customer" => order.customer_id
          },
          "lines" => order.lines
        }
      end)
      |> IO.inspect(label: "ORDER PRE JSON")
      |> Jason.encode!()
      |> File.write!("orders.json", orders)
      |> IO.inspect(label: "ORDER")
    end

    def parse(order_lines) do
      lines = Enum.filter(order_lines, &String.starts_with?(&1, "\"order-line\"")) |> IO.inspect(label: "1st ORDER IN PARSE FUNC")
      orders = Enum.filter(order_lines, &String.starts_with?(&1, "\"order\"")) |> IO.inspect(label: "ORDER-LINE IN PARSE FUNC")

      orders
      |> IO.inspect(label: "2nd ORDER IN PARSE FUNC")
      |> Enum.map(&parse_order/1)
      |> Enum.map(&link_lines(&1, lines))
    end

    defp parse_order(line) do
      [_, type, id, subtotal, tax, total, customer_id] = String.split(line, ",")

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

    defp link_lines(order, lines) do
      order_lines = Enum.map(lines, &parse_order_line/1)

      Map.put(order, :lines, order_lines)
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

  defp get_line_type(line) do
    [type | _] = String.split(line, ",")
    type
  end
  defp module_name("customer"), do: Customer
  defp module_name("product"), do: Product
  defp module_name("order"), do: Order
  defp module_name("order-line"), do: OrderLine


end
