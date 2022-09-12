include Angstrom
open Utils

let digit = function '0' .. '9' -> true | _ -> false
let vowel = function 'a' | 'e' | 'i' | 'o' | 'u' -> true | _ -> false
let ascii = function 'a' .. 'z' | 'A' .. 'Z' -> true | _ -> false

let integer = take_while1 digit >>| int_of_string
let str = take_while1 ascii
let per_line p = sep_by (char '\n') p <* char '\n'

let parse_with parser =
  parse_string ~consume:Consume.All parser %> (function
    | Ok s -> s
    | Error e -> failwith e)
