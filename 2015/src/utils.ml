include Batteries

let with_open path f =
  let fh = open_in path in
  let res = f fh in
  close_in fh;
  res

let input_file () = with_open Sys.argv.(1) IO.read_all
