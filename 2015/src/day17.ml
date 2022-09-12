open Aoc.Base

let parse =
  let open BParser in
  parse_with_lines integer

let () =
  let cups = parse @@ input_file () in
  let liters = 150 in
  let hsh = Hashtbl.create 12 in

  let rec solve acc n = function
    | _ when acc = liters ->
        Hashtbl.modify_def 0 n succ hsh
    | x :: xs when acc < liters ->
        solve acc n xs;
        solve (acc + x) (n + 1) xs
    | _ ->
        ()
  in
  solve 0 0 cups;

  let open Hashtbl in
  let part1 = values hsh |> Enum.sum in
  let part2 = find hsh (keys hsh |> Enum.fold min @@ List.length cups) in
  Fmt.(pr "Part 1: %i\nPart 2: %i@." part1 part2)
