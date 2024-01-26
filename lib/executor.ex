defmodule Razoyo.Executor do
  @moduledoc """

  """
  def extract(filepath) do
    {:ok, contents} = File.read(filepath)

      lines = String.split(contents, "\n", trim: true)

      grouped_lines = Enum.group_by(lines, &get_line_type/1)

      Enum.each(grouped_lines, fn {type, lines} ->
        type = String.trim(type, "\"")
        module = module_name(type)


        apply(module, :parse, [lines])
      end)
    end

    defp get_line_type(line) do
     [type | _] = String.split(line, ",")
     type
    end

    defp module_name("customer"), do: Customer
    defp module_name("product"), do: Product
    defp module_name("order"), do: Order
    defp module_name("order-line"), do: OrderLine

# defp extract_data([type, id, name, email, age, gender]) when is_binary(name) and is_binary(email) do
#   %{type: type, id: id, name: name, email: email, age: age, gender: gender}
# end

# defp extract_data([type, sku, name, brand, price, currency]) do
#   %{type: type, sku: sku, name: name, brand: brand, price: price, currency: currency}
# end

# defp extract_data([type, id, line_items, subtotal, tax, total, cust_id]) do
#   %{type: type, id: id, line_items: line_items, subtotal: subtotal, tax: tax, total: total, customer_id: cust_id}
# end

# defp extract_data([type, line_num, desc, price, qty]) do
#   %{
#    type: type,
#    line_num: line_num,
#    desc: desc,
#    price: price,
#    qty: qty
#   }
# end

end
