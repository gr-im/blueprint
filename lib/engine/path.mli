module Fragment : sig
  type t = string

  val equal : t -> t -> bool
  val compare : t -> t -> int
end

type t

val rel : Fragment.t list -> t
val abs : Fragment.t list -> t
val root : t
val cwd : t
val equal : t -> t -> bool
val compare : t -> t -> int

module Set : Stdlib.Set.S with type elt = t
