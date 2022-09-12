open Aoc.Base

type var =
  | VInt of Int64.t
  | VString of string

type inst_op =
  | SignalOp of var
  | BinOp of var * string * var
  | ShiftOp of var * string * int
  | NotOp of var

let parse =
  let open BParser in
  let line =
    let id =
      choice
        [
          (id_str >>| fun x -> VString x);
          (integer >>| fun x -> VInt (Int64.of_int x));
        ]
    in

    let signal_op = id >>| fun x -> SignalOp x in

    let bin_op =
      lift3
        (fun l op r -> BinOp (l, op, r))
        id
        (char ' ' *> (string "AND" <|> string "OR") <* char ' ')
        id
    in

    let shift_op =
      lift3
        (fun l op num -> ShiftOp (l, op, num))
        id
        (char ' ' *> (string "LSHIFT" <|> string "RSHIFT") <* char ' ')
        integer
    in

    let not_op = string "NOT " *> id >>| fun x -> NotOp x in

    lift2 Tuple2.make
      (bin_op <|> not_op <|> shift_op <|> signal_op)
      (string " -> " *> id_str)
  in
  parse_with_lines line

let rec solve wires cache key =
  match Hashtbl.find_option cache key with
  | Some v ->
      v
  | _ ->
      let solve_var' = solve_var wires cache in
      let res =
        match Hashtbl.find wires key with
        | SignalOp var ->
            solve_var' var
        | BinOp (a, "AND", b) ->
            Int64.logand (solve_var' a) (solve_var' b)
        | BinOp (a, "OR", b) ->
            Int64.logor (solve_var' a) (solve_var' b)
        | ShiftOp (a, "RSHIFT", b) ->
            Int64.shift_right_logical (solve_var' a) b
        | ShiftOp (a, "LSHIFT", b) ->
            Int64.shift_left (solve_var' a) b
        | NotOp a ->
            Int64.lognot (solve_var' a)
        | _ ->
            failwith "unreachable"
      in
      Hashtbl.add cache key res;
      res

and solve_var wires cache = function
  | VInt i ->
      i
  | VString k ->
      solve wires cache k

let () =
  let code = parse @@ input_file () in
  let wires =
    let env = Hashtbl.create 16 in
    List.iter Tuple2.(swap >> (uncurry @@ Hashtbl.add env)) code;
    env
  in

  let solve' = solve wires in

  let part1 = solve' (Hashtbl.create 16) "a" in
  let part2 =
    let cache = Hashtbl.create 16 in
    Hashtbl.add cache "b" part1;
    solve' cache "a"
  in
  Fmt.(pr "Part 1: %a\nPart 2: %a\n" int64 part1 int64 part2)
