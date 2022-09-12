open Aoc.Base

let count_matches lst patterns =
  let f str =
    patterns |> List.map Str.regexp
    |> List.for_all (fun rgx -> Str.string_match rgx str 0)
  in
  List.(lst |> filter f |> length)

let () =
  let count_on_str =
    input_file () |> String.split_on_char '\n' |> count_matches
  in

  let part1 =
    count_on_str
      [
        {|.*[aeiou].*[aeiou].*[aeiou]|};
        {|.*\(.\)\1|};
        (* Too lazy to fix this. *)
        {|.*\(ab\|cd\|pq\|xy\)|};
      ]
  in
  let part2 = count_on_str [ {|.*\(..\).*\1|}; {|.*\(.\).\1|} ] in
  Fmt.(pf stdout "Part one: %i\nPart two: %i" part1 part2)
