defmodule Product do
  
  defstruct [
  :type,
  :sku,
  :name,
  :brand,
  :price,
  :currency
]
def parse(lines) do
  Enum.map(lines, &parse_line/1)
end

defp parse_line(line) do
  [type, sku, name, brand, price, currency] = String.split(line, ",")

  price = String.to_float(price)

  %Product{
    type: type,
    sku: sku,
    name: name,
    brand: brand,
    price: price,
    currency: currency
  }
end

end
