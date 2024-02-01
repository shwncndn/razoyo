defmodule Order do
  @derive Jason.Encoder
  defstruct [:type, :id, :sub_total, :tax, :total, :customer_id, lines: []]

    def build(order_string) do
      [type, id, sub_total, tax, total, customer_id] =
        String.split(order_string, ",")

      %Order{
        type: type,
        id: id,
        sub_total: String.to_float(sub_total),
        tax: String.to_float(tax),
        total: String.to_float(total),
        customer_id: customer_id
      }
    end
  end
