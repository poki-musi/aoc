include Aoc.Base

let[@warning "-8"] parse =
  let open BParser in
  parse_with_lines
  @@ let* [ a; b; c ] =
       lift3
         (fun a b c -> List.sort Int.compare [ a; b; c ])
         integer
         (char 'x' *> integer)
         (char 'x' *> integer)
     in
     return (a, b, c)

let () =
  let open Infix.List in
  let boxes = parse @@ input_file () in
  let calc_material f = boxes <&> f |> List.sum in

  let part1 =
    calc_material (fun (l, w, h) -> l + (2 * ((l * w) + (w * h) + (l * h))))
  in
  let part2 = calc_material (fun (l, w, h) -> (2 * (l + w)) + (l * w * h)) in

  Fmt.(pf stdout "Part one: %i\nPart two: %i\n" part1 part2)
