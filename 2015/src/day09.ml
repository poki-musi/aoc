open Aoc.Base

let parser =
  let open BParser in
  parse_with_lines
  @@ lift3 Tuple3.make
       (id_str <* string " to ")
       (id_str <* string " = ")
       integer

let add_link env o d dist =
  match Hashtbl.find_option env o with
  | Some tbl ->
      Hashtbl.add tbl d dist
  | None ->
      let tbl = Hashtbl.create 16 in
      Hashtbl.add env o tbl;
      Hashtbl.add tbl d dist

let () =
  let lst = parser @@ input_file () in

  let map_cities, cities =
    let hsh = Hashtbl.create 16 in
    lst
    |> List.iter (fun (o, d, dist) ->
           add_link hsh o d dist;
           add_link hsh d o dist);
    (hsh, Hashtbl.keys hsh |> List.of_enum)
  in

  let calculate_route =
    let rec aux acc = function
      | x :: (y :: _ as ys) ->
          let acc' = acc + Hashtbl.(map_cities |> flip find x |> flip find y) in
          aux acc' ys
      | _ ->
          acc
    in
    aux 0
  in

  let part1, part2 =
    let open LazyList in
    cities
    |> permutations
    |> map calculate_route
    |> fold_left
         (fun acc x -> Tuple2.map Int.(min x) Int.(max x) acc)
         (Int.max_num, Int.min_num)
  in

  Fmt.(pr "Part one: %i\nPart two: %i\n" part1 part2)
