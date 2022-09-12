open Aoc.Base

let () =
  let inp = input_file () in
  let nums =
    inp
    |> String.to_seq
    |> Seq.map (fun x -> int_of_char x - int_of_char '0')
    |> Array.of_seq
    |> ref
  in

  let simplify seq =
    let rec aux acc =
      let open Seq in
      function
      | Some (a, tail) ->
          let len = take_while (Int.equal a) tail |> length in
          let tail = drop len tail in
          aux (cons a @@ cons (len + 1) @@ acc) (uncons tail)
      | None ->
          acc
    in
    aux Seq.nil Seq.(uncons seq)
  in

  let epoch () =
    nums := !nums |> Array.to_seq |> simplify |> Array.of_seq;
    Array.rev_in_place !nums
  in

  let part1 =
    timebench
    @@ fun _ ->
    for _ = 1 to 40 do
      epoch ()
    done;

    Array.length !nums
  in

  let part2 =
    timebench
    @@ fun _ ->
    for _ = 41 to 50 do
      epoch ()
    done;

    Array.length !nums
  in

  Fmt.(pr "Part one: %i\nPart two: %i" part1 part2)
