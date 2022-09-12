open Aoc.Base

let parse =
  let open BParser in
  let ign =
    take_while (function '\n' | '-' | '0' .. '9' -> false | _ -> true)
  in
  let line = ign *> sep_by ign signed_int <* ign in
  parse_with_lines line

let iter_max_comb f =
  let open Enum in
  let max_iter v i f = max v @@ Enum.fold f 0 i in
  max_iter 0 (0 -- 100)
  @@ fun acc x ->
  max_iter acc (0 -- (100 - x))
  @@ fun acc y ->
  max_iter acc (0 -- (100 - x - y))
  @@ fun acc z -> max acc @@ f [| x; y; z; 100 - x - y - z |]

let dot_prod a b =
  Array.combine a b
  |> Array.map (Tuple2.uncurry ( * ))
  |> Array.sum
  |> Int.max 0

let mtx_product mtx arr =
  0 -- 3 |> Enum.map (Array.get mtx %> dot_prod arr) |> Enum.fold ( * ) 1

let () =
  let mtx =
    input_file ()
    |> parse
    |> List.transpose
    |> List.map Array.of_list
    |> Array.of_list
  in

  let part1 = iter_max_comb @@ mtx_product mtx in
  let part2 =
    iter_max_comb
    @@ fun arr ->
    let cond = dot_prod arr mtx.(4) = 500 in
    if cond then mtx_product mtx arr else 0
  in
  Fmt.(pr "Part 1: %i\nPart 2: %i@." part1 part2)
