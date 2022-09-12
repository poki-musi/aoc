open Aoc.Base

type json_t =
  | JList of json_t list
  | JObj of (string * json_t) list
  | JString of string
  | JNum of int

let json_of_string =
  let open BParser in
  let parser =
    fix (fun json_p ->
        let int_p =
          lift2 (fun sign num -> JNum (if sign then -num else num))
            (option false (char '-' *> return true))
            integer
        in
        let str_p =
          lift (fun x -> JString x)
            quote_str
        in
        let array_p =
          lift (fun x -> JList x) @@
            char '[' *> sep_by (char ',') json_p <* char ']'
        in
        let obj_p =
          let[@warning "-8"] pair_p =
            lift2 (fun (JString x) y -> (x, y))
              str_p json_p
          in
          lift (fun x -> JObj x) @@
            char '{' *> sep_by (char ',') pair_p <* char '}'
        in
        int_p <|> str_p <|> array_p <|> obj_p)
  in
  parse_with (parser <* char '\n')

let () =
  let rec solve f obj =
    match obj with
    | JNum i -> i
    | JList lst -> List.(map (solve f) lst |> sum)
    | JObj lst when f lst -> List.(map (snd %> fun x -> solve f x) lst |> sum)
    | _ -> 0
  in

  let inp = json_of_string @@ input_file () in
  let solve = flip solve inp in

  let part1 = solve @@ const true in
  let part2 =
    let f (a, b) = a <> "red" && match b with JString s -> s <> "red" | _ -> true in
    solve @@ List.for_all f
  in

  Fmt.(pr "Part one: %i\nPart two: %i" part1 part2)
