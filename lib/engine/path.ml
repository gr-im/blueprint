module Fragment = struct
  type t = string

  let equal = String.equal
  let compare = String.compare
end

type t =
  | Rel of Fragment.t list
  | Abs of Fragment.t list

let rel xs = Rel xs
let abs xs = Abs xs
let root = abs []
let cwd = rel []

let equal a b =
  match a, b with
  | Abs _, Rel _ | Rel _, Abs _ -> false
  | Abs a, Abs b | Rel a, Rel b -> List.equal Fragment.equal a b
;;

let compare a b =
  match a, b with
  | Abs _, Rel _ -> -1
  | Rel _, Abs _ -> 1
  | Abs a, Abs b | Rel a, Rel b -> List.compare Fragment.compare a b
;;

module Set = Stdlib.Set.Make (struct
    type nonrec t = t

    let compare = compare
  end)
