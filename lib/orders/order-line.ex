defmodule OrderLine do
  @moduledoc """
  Order line
  """
  @enforce_keys [
    :position,
    :name,
    :price,
    :quantity,
    :row_total
  ]
  defstruct @enforce_keys

  def build(line_string) do
    [position, name, price, quantity] =
      String.split(line_string, ",")

    row_total = String.to_float(price) * String.to_integer(quantity)

    %OrderLine{
      position: String.to_integer(position),
      name: name,
      price: String.to_float(price),
      quantity: String.to_integer(quantity),
      row_total: row_total
    }
  end
end




#   def export(var) do
#     var
#     |> parse()
#   end

#   def parse(lines) do
#     Enum.map(lines, fn line ->
#       line
#       |> String.trim()
#       |> parse_line()
#     end)
#   end

#   defp parse_line(line) do
#     [type, position, name, price, quantity] = String.split(line, ",")

#     position = String.to_integer(position)
#     price = String.to_float(price)
#     quantity = String.to_integer(quantity)

#     %OrderLine{
#       type: String.trim(type, "\""),
#       position: position,
#       name: String.trim(name, "\""),
#       price: price,
#       quantity: quantity,
#       row_total: price * quantity
#     }
#     |> IO.inspect(label: "ORDER LINE STRUCT")
#   end
# end
