open Aoc.Base

(* let parse = *)
(*   let open BParser in *)
(*   parse_with_lines *)
(*     (lift2 (flip >> Tuple2.make) *)
(*        (take_while (fun x -> Char.is_uppercase x || Char.is_lowercase x) *)
(*        <* string " => ") *)
(*        (many1 ())) *)
(*   >> Hashtbl.of_list *)

let () =
  let maps = parse @@ input_file () in
  ()
