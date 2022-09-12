include Batteries

let with_open path f =
  let fh = open_in path in
  let res = f fh in
  close_in fh;
  res

let input_file () = with_open Sys.argv.(1) IO.read_all |> String.strip

let timebench f =
  let t = Sys.time () in
  let res = f () in
  let t' = Sys.time () in
  let t'' = t' -. t in
  Fmt.(pr "Time: %f ms\n" (t'' *. 1000.0));
  res

let uninterleave (lst : 'a list) =
  let rec aux (l : 'a list) (r : 'a list) = function
    | x :: y :: xs ->
        aux (x :: l) (y :: r) xs
    | _ ->
        (List.rev l, List.rev r)
  in
  aux [] [] lst

module BParser = struct
  include Angstrom

  let parse_with p = parse_string ~consume:Consume.All p %> Result.get_ok

  let ( <%> ) pa pb =
    let+ a = pa
    and+ b = pb in
    (a, b)

  let lines ?(sep = string "\n") p = sep_by sep p

  let integer =
    int_of_string <$> take_while1 (function '0' .. '9' -> true | _ -> false)

  let signed_int =
    lift2
      (fun sign x -> if sign then -x else x)
      (option false (char '-' >>| const true))
      integer

  let quote_str = char '"' *> take_while (( <> ) '"') <* char '"'

  let id_str =
    take_while1 (function 'a' .. 'z' | 'A' .. 'Z' -> true | _ -> false)

  let parse_with_lines p = parse_with @@ lines p
end

module Map2D = struct
  type dir =
    | Up
    | Down
    | Left
    | Right

  let move (x, y) = function
    | Up ->
        (x, y - 1)
    | Down ->
        (x, y + 1)
    | Left ->
        (x - 1, y)
    | Right ->
        (x + 1, y)
end

let ( >> ) f g x = x |> f |> g

let ( >>> ) f g x y =
  let v = f x y in
  g v

let ( ||> ) (x, y) f = f x y
let ( |||> ) (x, y, z) f = f x y z

module Infix = struct
  module type S = sig
    type 'a t

    val map : ('a -> 'b) -> 'a t -> 'b t
    val flatten : 'a t t -> 'a t
  end

  module Make (M : S) = struct
    let ( <&> ) d f = M.map f d
    let ( >>= ) m f = M.map f m |> M.flatten
    let ( let* ) = ( >>= )
    let ( let+ ) = ( <&> )

    let ( <@> ) d f =
      let* x = d in
      let+ g = f in
      g x

    let ( @> ) d v = d <&> fun _ -> v
    let ( let@ ) = ( <@> )
  end

  module List = Make (struct
    type 'a t = 'a List.t

    let map = List.map
    let flatten = List.flatten
  end)

  module Seq = Make (struct
    type 'a t = 'a Seq.t

    let map = Seq.map
    let flatten = Seq.flatten
  end)

  module Enum = Make (struct
    type 'a t = 'a Enum.t

    let map = Enum.map
    let flatten = Enum.flatten
  end)
end

let rec apply_n f a n = if n > 0 then apply_n f (f a) (pred n) else a
let rec apply_while c f x = if c x then apply_while c f (f x) else x
let rec bind_while f x = match f x with Some v -> bind_while f v | None -> x
