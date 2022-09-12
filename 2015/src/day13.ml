open Aoc.Base

let parse data =
  let open BParser in
  let line =
    lift3 Tuple3.make
      (id_str <* string " would ")
      (let* sign =
         string "lose" >>| const true <|> (string "gain" >>| const false)
       in
       let* x = char ' ' *> integer in
       return @@ if sign then -x else x)
      (string " happiness units by sitting next to " *> id_str <* char '.')
  in

  let data = parse_with_lines line data in

  let tbl = Hashtbl.create 16 in
  flip List.iter data (fun (orig, happiness, dest) ->
      let open Hashtbl in
      let v = happiness + (find_option tbl (orig, dest) |> Option.default 0) in
      add tbl (orig, dest) v;
      add tbl (dest, orig) v);
  let keys = Hashtbl.keys tbl |> Enum.map snd |> List.of_enum |> List.unique in
  (tbl, keys)

let () =
  let inp = input_file () in

  let tbl, people = parse @@ inp in
  let calc_happ tbl people =
    let rec aux acc tbl =
      let open Hashtbl in
      function
      | l :: (r :: _ as xs) -> aux (acc + find tbl (l, r)) tbl xs | _ -> acc
    in
    let tot_happ tbl lst = aux 0 tbl List.(last people :: lst) in
    let open LazyList in
    permutations people |> map (tot_happ tbl) |> fold_left Int.max Int.min_num
  in

  let part1 = calc_happ tbl people in

  let part2 =
    people
    |> List.iter (fun k ->
           Hashtbl.add tbl (k, "") 0;
           Hashtbl.add tbl ("", k) 0);
    calc_happ tbl ("" :: people)
  in

  Fmt.(pr "Part 1: %i\nPart 2: %i" part1 part2)
