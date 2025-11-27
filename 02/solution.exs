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

get_vals = fn map, index ->
  loc_a = Map.get(map, index + 1)
  loc_b = Map.get(map, index + 2)
  val_a = Map.get(map, loc_a)
  val_b = Map.get(map, loc_b)
  loc = Map.get(map, index + 3)
  {val_a, val_b, loc}
end

program = fn val_1, val_2, instructions ->
  instructions = Map.put(instructions, 1, val_1)
  instructions = Map.put(instructions, 2, val_2)

  Map.keys(instructions)
  |> Enum.sort()
  |> Enum.reduce_while(
    {instructions, 0},
    fn _, {current_map, index} ->
      val = Map.get(current_map, index)

      case val do
        # Opcode 1 adds together numbers read from two positions and stores the result in a third position
        1 ->
          {val_a, val_b, loc} = get_vals.(current_map, index)
          {:cont, {Map.put(current_map, loc, val_a + val_b), index + 4}}

        # Opcode 2 works exactly like opcode 1, except it multiplies the two inputs instead of adding them.
        2 ->
          {val_a, val_b, loc} = get_vals.(current_map, index)
          {:cont, {Map.put(current_map, loc, val_a * val_b), index + 4}}

        # 99 means that the program is finished and should immediately halt
        99 ->
          res = Map.get(current_map, 0)

          # part 2
          if res == 19_690_720 do
            IO.puts("Desired calculation: #{100 * val_1 + val_2}")
          end

          {:halt, {current_map, index}}

        _ ->
          {:cont, {current_map, index}}
      end
    end
  )
end

Enum.each(0..99, fn a -> Enum.each(0..99, fn b -> program.(a, b, instructions) end) end)
