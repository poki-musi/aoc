open Aoc.Base

let rec inc_aux i bytes =
  let open Bytes in
  if i = 0
  then (
    let bytes = extend bytes 1 0 in
    set bytes 0 'a';
    bytes)
  else
    let c = get bytes i |> int_of_char in
    if c = int_of_char 'z'
    then (
      set bytes i 'a';
      inc_aux (i - 1) bytes)
    else (
      set bytes i (c + 1 |> char_of_int);
      bytes)

let inc_bytes bytes = inc_aux (Bytes.length bytes - 1) bytes

let next_passwd keyword =
  let key = Bytes.of_string keyword |> inc_bytes |> ref in
  while
    (* No i, o, or l *)
    Bytes.to_seq !key
    |> Seq.for_all (function 'i' | 'o' | 'l' -> false | _ -> true)
    |> not
    (* abc patterns *)
    || Seq.(
         let seq = Bytes.to_seq !key |> Seq.map int_of_char in
         let[@warning "-8"] (Some (_, seq')) = Seq.uncons seq in
         let[@warning "-8"] (Some (_, seq'')) = Seq.uncons seq' in
         zip seq (zip seq' seq'')
         |> filter (fun (a, (b, c)) -> a + 1 = b && b + 1 = c)
         |> is_empty)
    (* Find two separate pairs of same char. *)
    || not
         Str.(
           string_match (regexp {|.*\(.\)\1.*\(.\)\2|}) (String.of_bytes !key) 0)
  do
    key := inc_bytes !key
  done;
  Bytes.to_string !key

let () =
  let keyword =
    let inp = input_file () in
    String.(sub inp 0 (length inp - 1))
  in

  let part1 = next_passwd keyword in
  let part2 = next_passwd part1 in
  Fmt.(pr "Part one: %s\nPart two: %s" part1 part2)
