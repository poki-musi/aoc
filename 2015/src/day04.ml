open Aoc.Base

let find_zeros n key =
  let chk_prefix = String.(starts_with_stdlib ~prefix:(init n @@ const '0')) in
  let open Seq in
  ints 1
  |> find
       (let open Digest in
       Fmt.(str "%s%i" key) >> string >> to_hex >> chk_prefix >> not)
  |> Option.get

let () =
  let key = "ckczppom" in
  let p1 = timebench @@ fun () -> find_zeros 5 key in
  let p2 = timebench @@ fun () -> find_zeros 6 key in
  Fmt.(pr "Part one: %i\nPart two: %i" p1 p2)
