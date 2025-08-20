(** Implement a Reader Monad as described in the following article:
    {:https://gr-im.github.io/a/dependency-injection.html}. *)

(** A program that can produce effects described by the object
    ['handler] and returns a value of type ['a] will have the type
    [('a, 'handler) t]. *)
type ('a, 'handler) t

val handle : handler:'handler -> ('a -> ('b, 'handler) t) -> 'a -> 'b
val perform : ('handler -> 'a) -> ('a, 'handler) t
val return : 'a -> ('a, 'handler) t
val map : ('a -> 'b) -> ('a, 'handler) t -> ('b, 'handler) t
val ap : ('a -> 'b, 'handler) t -> ('a, 'handler) t -> ('b, 'handler) t
val zip : ('a, 'handler) t -> ('b, 'handler) t -> ('a * 'b, 'handler) t
val bind : ('a, 'handler) t -> ('a -> ('b, 'handler) t) -> ('b, 'handler) t

module Infix : sig
  val ( <$> ) : ('a -> 'b) -> ('a, 'handler) t -> ('b, 'handler) t
  val ( <*> ) : ('a -> 'b, 'handler) t -> ('a, 'handler) t -> ('b, 'handler) t
  val ( >>= ) : ('a, 'handler) t -> ('a -> ('b, 'handler) t) -> ('b, 'handler) t
  val ( =<< ) : ('a -> ('b, 'handler) t) -> ('a, 'handler) t -> ('b, 'handler) t
  val ( >|= ) : ('a, 'handler) t -> ('a -> 'b) -> ('b, 'handler) t
end

module Syntax : sig
  val ( let+ ) : ('a, 'handler) t -> ('a -> 'b) -> ('b, 'handler) t
  val ( and+ ) : ('a, 'handler) t -> ('b, 'handler) t -> ('a * 'b, 'handler) t

  val ( let* )
    :  ('a, 'handler) t
    -> ('a -> ('b, 'handler) t)
    -> ('b, 'handler) t

  val ( let*! )
    :  ('handler -> 'a)
    -> ('a -> ('b, 'handler) t)
    -> ('b, 'handler) t

  val ( let+! ) : ('handler -> 'a) -> ('a -> 'b) -> ('b, 'handler) t
end

include module type of Infix
include module type of Syntax
