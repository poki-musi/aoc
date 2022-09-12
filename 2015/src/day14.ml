open Aoc.Base

let parse =
  let open BParser in
  parse_with_lines
  @@ lift3
       (fun v t rest -> (v, t, t + rest))
       (id_str *> string " can fly " *> integer)
       (string " km/s for " *> integer
       <* string " seconds, but then must rest for ")
       (integer <* string " seconds.")

let () =
  let inp = input_file () in

  let reindeers = parse @@ inp in
  let n_reindeers = List.length reindeers in
  let secs = 2503 in

  let tick v move period time = if time mod period < move then v else 0 in

  let part1 =
    reindeers
    |> List.map (fun (v, t, period) ->
           let open Enum in
           0 -- (secs - 1) |> map (tick v t period) |> sum)
    |> List.max
  in

  let part2 =
    let f (dist, points) epoch =
      reindeers
      |> List.iteri (fun i (v, t, period) ->
             dist.(i) <- dist.(i) + tick v t period epoch);
      let max = Array.max dist in
      for i = 0 to n_reindeers - 1 do
        if dist.(i) = max then points.(i) <- points.(i) + 1
      done;
      (dist, points)
    in
    let open Enum in
    0 -- (secs - 1)
    |> fold f
         (Array.init n_reindeers (const 0), Array.init n_reindeers (const 0))
    |> snd |> Array.max
  in
  Fmt.(pr "Part 1: %i\nPart 2: %i\n" part1 part2)
