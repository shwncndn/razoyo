defmodule Razoyo.Executor do
  @moduledoc """
  Execution module for file conversion and export
  """
  def extract(filepath) do
    contents = File.stream!(filepath)

    contents
    |> Enum.group_by(&line_type/1)
    |> Enum.each(fn {type, lines} ->
      type = String.trim(type, "\"")
      module = module_name(type)

      apply(module, :export, [lines])
    end)
  end

  defp line_type(line) do
    [type | _] = String.split(line, ",")
    type
  end

  defp module_name("customer"), do: Customer
  defp module_name("product"), do: Product
  defp module_name("order"), do: Order
  defp module_name("order-line"), do: OrderLine
end
