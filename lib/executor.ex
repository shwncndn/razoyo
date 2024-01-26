defmodule Razoyo.Executor do
  @moduledoc """

  """
  def extract(filepath) do
    contents = File.stream!(filepath)

    grouped_lines = Enum.group_by(contents, &get_line_type/1)

    Enum.each(grouped_lines, fn {type, lines} ->
      type = String.trim(type, "\"")
      module = module_name(type)

      apply(module, :export, [lines])
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


end
