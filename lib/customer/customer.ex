defmodule Customer do
  @moduledoc """
  Customer struct module
  """

  @enforce_keys [
    :type,
    :id,
    :name,
    :email,
    :age,
    :gender
  ]

  defstruct @enforce_keys

  def export(customers) do
    customers
    |> parse()
    |> build_xml()
    |> (&File.write!("customers.xml", &1)).()
  end

  defp parse(lines) do
    Enum.map(lines, fn line ->
      line
      |> String.trim()
      |> parse_line()
    end)
  end

  defp build_xml(customers) do
    EEx.eval_file("xml.eex", assigns: [customers: customers], trim: true)
  end

  defp parse_line(line) do
    [type, id, name, email, age, gender] = String.split(line, ",")

    age = if age == "", do: nil, else: String.to_integer(age)
    gender = String.to_integer(gender)

    %Customer{
      type: String.trim(type, "\""),
      id: String.trim(id, "\""),
      name: String.trim(name, "\""),
      email: String.trim(email, "\""),
      age: age,
      gender: gender
    }
    |> IO.inspect(label: "CUSTOMER STRUCT PARSE RESULT")
  end
end
