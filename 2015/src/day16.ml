open Aoc.Base

let parse =
  let open BParser in
  parse_with_lines
  @@ skip_while (( <> ) ':')
     *> char ':'
     *> (sep_by (char ',')
         @@ lift2 Tuple2.make (char ' ' *> id_str <* string ": ") integer
        >>| Hashtbl.of_list)

let () =
  let sues = parse @@ input_file () in
  let real_match =
    Hashtbl.of_list
      [
        ("children", 3);
        ("cats", 7);
        ("samoyeds", 2);
        ("pomeranians", 3);
        ("akitas", 0);
        ("vizslas", 0);
        ("goldfish", 5);
        ("trees", 3);
        ("cars", 2);
        ("perfumes", 1);
      ]
  in

  let find_match f =
    let f _ sue = Hashtbl.keys sue |> Enum.for_all @@ f sue in
    sues |> List.findi f |> fst |> succ
  in

  let part1 =
    find_match @@ fun sue key -> Hashtbl.(find real_match key = find sue key)
  in

  let part2 =
    find_match
    @@ fun sue key ->
    let f =
      match key with
      | "trees" | "cats" ->
          ( < )
      | "pomeranians" | "goldfish" ->
          ( > )
      | _ ->
          ( = )
    in
    Hashtbl.(f (find real_match key) (find sue key))
  in
  Fmt.(pr "Part one: %i\nPart two: %i" part1 part2)
