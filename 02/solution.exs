instructions =
  File.stream!("input")
  |> Stream.take(1)
  |> Enum.at(0)
  |> String.split(",")
  |> Stream.map(&String.trim/1)
  |> Stream.map(&String.to_integer/1)
  |> Enum.with_index()
  |> Stream.map(fn {val, idx} -> {idx, val} end)
  |> Map.new()

Map.keys(instructions)
|> Enum.sort()
|> Enum.reduce_while(
  {instructions, 0},
  fn _, {current_map, index} ->
    IO.inspect(index)
    IO.inspect(current_map)
    val = Map.get(current_map, index)

    case val do
      # Opcode 1 adds together numbers read from two positions and stores the result in a third position
      1 ->
        loc_a = Map.get(current_map, index + 1)
        loc_b = Map.get(current_map, index + 2)
        val_a = Map.get(current_map, loc_a)
        val_b = Map.get(current_map, loc_b)
        loc = Map.get(current_map, index + 3)
        {:cont, {Map.put(current_map, loc, val_a + val_b), index + 4}}

      # Opcode 2 works exactly like opcode 1, except it multiplies the two inputs instead of adding them.
      2 ->
        loc_a = Map.get(current_map, index + 1)
        loc_b = Map.get(current_map, index + 2)
        val_a = Map.get(current_map, loc_a)
        val_b = Map.get(current_map, loc_b)
        loc = Map.get(current_map, index + 3)
        {:cont, {Map.put(current_map, loc, val_a * val_b), index + 4}}

      # 99 means that the program is finished and should immediately halt
      99 ->
        IO.puts("Halting...Value at pos 0: #{Map.get(current_map, 0)}")
        {:halt, {current_map, index}}

      _ ->
        {:cont, {current_map, index}}
    end
  end
)
