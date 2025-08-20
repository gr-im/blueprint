module Elt = struct
  type t = File of Path.t

  let compare a b =
    match a, b with
    | File a, File b -> Path.compare a b
  ;;
end

include Stdlib.Set.Make (Elt)

let from_path path = Elt.File path
let single_path path = path |> from_path |> singleton
