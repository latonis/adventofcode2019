defmodule FuelFinder do
  def find_mass(x) do
    Integer.floor_div(x, 3) - 2
  end

  def find_fuel(x) do
    required_fule = find_mass(x)
    if required_fule > 0, do: required_fule + find_fuel(required_fule), else: 0
  end
end

# -- part one
File.stream!("input")
|> Stream.map(&String.trim/1)
|> Stream.map(&String.to_integer/1)
|> Stream.map(&FuelFinder.find_mass/1)
|> Enum.sum()
|> IO.inspect()

# -- part two
File.stream!("input")
|> Stream.map(&String.trim/1)
|> Stream.map(&String.to_integer/1)
|> Stream.map(&FuelFinder.find_fuel/1)
|> Enum.sum()
|> IO.inspect()
