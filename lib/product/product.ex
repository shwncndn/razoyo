defmodule Product do
  @moduledoc """
  Product module
  """
  defstruct [
    :type,
    :sku,
    :name,
    :brand,
    :price,
    :currency
  ]

  def export(products) do
    products
    |> parse()
    |> write()
    |> IO.inspect(label: "PRODUCT")
  end

  def parse(lines) do
    Enum.map(lines, &parse_product/1)
  end

  def write(products) do
    products
    |> Stream.map(&[&1.type, &1.sku, &1.name, &1.brand, &1.price, &1.currency])
    |> CSV.encode()
    |> Enum.into(File.stream!("test.csv"))
  end

  defp parse_product(line) do
    [type, sku, name, brand, price, currency] = String.split(line, ",")

    currency =
      currency
      |> String.trim("\\")
      |> String.trim("\"")
      |> String.trim("\n")

    %Product{
      type: String.trim(type, "\""),
      sku: String.trim(sku, "\""),
      name: String.trim(name, "\""),
      brand: String.trim(brand, "\""),
      price: String.to_float(price),
      currency: String.trim(currency, "\"")
    }
  end
end
