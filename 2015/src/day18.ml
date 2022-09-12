open Aoc.Base

let parse =
  let open BParser in
  parse_with_lines
    (many (char '#' >>| const true <|> (char '.' >>| const false))
    >>| fun lst -> Array.of_list @@ (false :: lst) @ [ false ])
  >> (fun lst ->
       (Array.init 102 (const false) :: lst) @ [ Array.init 102 (const false) ])
  >> Array.of_list

let num_neighbours mtx i j =
  Array.fold_left
    (fun acc x -> acc + Bool.to_int x)
    0
    [|
      mtx.(i - 1).(j - 1);
      mtx.(i).(j - 1);
      mtx.(i + 1).(j - 1);
      mtx.(i - 1).(j);
      mtx.(i + 1).(j);
      mtx.(i - 1).(j + 1);
      mtx.(i).(j + 1);
      mtx.(i + 1).(j + 1);
    |]

let game_of_life mtx it post_f =
  let orig = ref @@ Array.map Array.copy mtx in
  let dest = ref @@ Array.make_matrix 102 102 false in

  for _epoch = 1 to it do
    post_f !orig;
    let dest' = !dest in
    let orig' = !orig in

    for i = 1 to 100 do
      for j = 1 to 100 do
        dest'.(i).(j) <-
          (match (orig'.(i).(j), num_neighbours orig' i j) with
          | true, (2 | 3) | false, 3 ->
              true
          | _ ->
              false)
      done
    done;

    Ref.swap dest orig
  done;
  post_f !orig;
  !orig

let () =
  let mtx = parse @@ input_file () in
  let calc mtx =
    let open Infix.Enum in
    mtx |> Array.enum >>= Array.enum |> Enum.map Bool.to_int |> Enum.sum
  in
  timebench
  @@ fun () ->
  let part1 = calc @@ game_of_life mtx 100 ignore in
  let part2 =
    calc
    @@ game_of_life mtx 100 (fun mtx ->
           mtx.(1).(1) <- true;
           mtx.(1).(100) <- true;
           mtx.(100).(1) <- true;
           mtx.(100).(100) <- true)
  in
  Fmt.(pr "Part 1: %i\nPart 2: %i@." part1 part2)
