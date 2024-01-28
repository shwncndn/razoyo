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

  def export(var) do
    parsed_lines = parse(var)

    parsed_lines

    |> Enum.map(&Map.from_struct/1)
    |> Enum.map(&MapToXml.from_map/1)
    |> IO.inspect(label: "AFTER MAP TO XML")
    |> remove_roots()
    |> IO.inspect(label: "REMOVED ROOTS")
    |> Enum.into(File.stream!("customers.xml"))



    # |> validate_xml()
  end

  defp remove_roots(xml_docs) do
  for doc <- xml_docs do
    String.replace(doc, ~r/^<\?.*?\?>/s, "")
  end


  end

  defp parse(lines) do
    Enum.map(lines, fn line ->
      line
      |> String.trim()
      |> parse_line()
    end)
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
    |> IO.inspect(label: "CUSTOMER STRUCT")
  end

  # def remove_multiple_roots(xml_list) do
  #   xml = Enum.join(xml_docs)
  #   xml = """

  #   """
  # end
end
