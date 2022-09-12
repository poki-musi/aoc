include Aoc.Base

let () =
  let moves =
    input_file ()
    |> String.to_seq
    |> Seq.scan
         (fun acc -> function '(' -> acc + 1 | ')' -> acc + -1 | _ -> 0)
         0
    |> List.of_seq
  in

  let part1 = List.last moves in
  let part2 = moves |> List.findi (const ( > ) 0) |> fst in
  Fmt.(pr "Part one: %i\nPart two: %i" part1 part2)
