type ('a, 'b, 'handler) t

val eff
  :  ?dynamic_deps:bool
  -> ?deps:Deps.t
  -> ('a -> ('b, 'handler) Eff.t)
  -> ('a, 'b, 'handler) t

val lift
  :  ?dynamic_deps:bool
  -> ?deps:Deps.t
  -> ('a -> 'b)
  -> ('a, 'b, 'handler) t

val id : ('a, 'a, 'handler) t
val action : ('a, 'b, 'handler) t -> 'a -> ('b, 'handler) Eff.t
val deps : ('a, 'b, 'handler) t -> Deps.t
val has_dynamic_deps : ('a, 'b, 'handler) t -> bool
val set_dynamic_deps : bool -> ('a, 'b, 'handler) t -> ('a, 'b, 'handler) t
val with_dynamic_deps : ('a, 'b, 'handler) t -> ('a, 'b, 'handler) t
val no_dynamic_deps : ('a, 'b, 'handler) t -> ('a, 'b, 'handler) t

val on_dynamic_deps
  :  (bool -> bool)
  -> ('a, 'b, 'handler) t
  -> ('a, 'b, 'handler) t

val on_deps : (Deps.t -> Deps.t) -> ('a, 'b, 'handler) t -> ('a, 'b, 'handler) t

val dimap
  :  ('a -> 'b)
  -> ('c -> 'd)
  -> ('b, 'c, 'handler) t
  -> ('a, 'd, 'handler) t

val lmap : ('a -> 'b) -> ('b, 'c, 'handler) t -> ('a, 'c, 'handler) t
val rmap : ('a -> 'b) -> ('c, 'a, 'handler) t -> ('c, 'b, 'handler) t
