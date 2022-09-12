open Aoc.Base

let parser esc_count hex_count line_count =
  let open BParser in
  let chr =
    choice
      [
        string "\\\"" >>| Fun.const esc_count;
        string "\\\\" >>| Fun.const esc_count;
        string "\\x" *> any_char *> any_char >>| Fun.const hex_count;
        not_char '"' >>| Fun.const 1;
      ]
  in
  let line =
    lift (List.sum >> ( + ) line_count) (char '"' *> many chr <* char '"')
  in
  parse_with (sep_by (char '\n') line >>| List.sum)

let eval str esc_count hex_count line_count =
  let mem = parser esc_count hex_count line_count str in
  let len = String.to_seq str |> Seq.(filter (( <> ) '\n') %> length) in
  len - mem

let () =
  let eval = eval @@ input_file () in
  let part1 = eval 1 1 0 in
  let part2 = -eval 4 5 6 in
  Fmt.(pr "Part one: %i\nPart two: %i" part1 part2)
