defmodule Customer do
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
    var
    |> parse()
  end

  def parse(lines) do
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
      type: type,
      id: id,
      name: name,
      email: email,
      age: age,
      gender: gender
    }
  end
end
