open Aoc.Base

let[@ocamlformat "disable"] parse =
  let open BParser in parse_with_lines (
    let pair_p =
      lift2 Tuple2.make
        integer
        (char ',' *> integer)
    in
    lift3 Tuple3.make
      (string "turn on" <|> string "turn off" <|> string "toggle")
      (char ' ' *> pair_p)
      (string " through " *> pair_p)
  )

let apply_commands ~on ~off ~toggle ~fmap ~mtx_init code =
  let open Infix.Seq in
  let mtx = Array.init 1_000_000 (Fun.const mtx_init) in
  code
  |> List.iter (fun (op, (x, x'), (y, y')) ->
         let f =
           match[@warning "-8"] op with
           | "turn on" ->
               on
           | "turn off" ->
               off
           | "toggle" ->
               toggle
         in
         for i = x to x' do
           let i = i * 1000 in
           for j = y to y' do
             mtx.(i + j) <- f mtx.(i + j)
           done
         done);
  Seq.fold_left ( + ) 0 (Array.to_seq mtx <&> fmap)

let () =
  let code = parse @@ input_file () in

  let part1 =
    apply_commands ~on:(const true) ~off:(const false) ~toggle:not
      ~fmap:Bool.to_int ~mtx_init:false code
  in

  let part2 =
    apply_commands ~on:(( + ) 1)
      ~off:Int.(pred >> max 0)
      ~toggle:(( + ) 2) ~fmap:Fun.id ~mtx_init:0 code
  in
  Fmt.(pr "Part one: %i\nPart two: %i" part1 part2)
