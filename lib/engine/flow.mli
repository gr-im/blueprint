type ('a, 'b, 'handler) t

val make
  :  ?dynamic_deps:bool
  -> ?deps:Deps.t
  -> ('a -> ('b, 'handler) Eff.t)
  -> ('a, 'b, 'handler) t

val action : ('a, 'b, 'handler) t -> 'a -> ('b, 'handler) Eff.t
val deps : ('a, 'b, 'handler) t -> Deps.t
val has_dynamic_deps : ('a, 'b, 'handler) t -> bool
val set_dynamic_deps : bool -> ('a, 'b, 'handler) t -> ('a, 'b, 'handler) t
val with_dynamic_deps : ('a, 'b, 'handler) t -> ('a, 'b, 'handler) t
val no_dynamic_deps : ('a, 'b, 'handler) t -> ('a, 'b, 'handler) t
