open Aoc.Base

module Set' = Set.Make (struct
  type t = int * int

  let compare = Tuple2.compare ~cmp1:Int.compare ~cmp2:Int.compare
end)

let map_to_dir =
  let open Map2D in
  function '^' -> Up | 'v' -> Down | '<' -> Left | '>' -> Right | _ -> Up

let () =
  let dirs =
    input_file ()
    |> String.to_seq
    |> Seq.map map_to_dir
    |> List.of_seq
  in

  let open Set' in
  let add_moves dirs =
    Seq.of_list dirs
    |> Seq.scan Map2D.move (0, 0)
    |> Set'.add_seq
  in

  let init_set =
    empty
    |> add (0, 0) in
  let part1 =
    init_set
    |> add_moves dirs
    |> cardinal
  in
  let part2 =
    let life, robo = uninterleave dirs in
    init_set
    |> add_moves life
    |> add_moves robo
    |> cardinal
  in
  Fmt.(pf stdout "Part one: %i\nPart two: %i" part1 part2)
