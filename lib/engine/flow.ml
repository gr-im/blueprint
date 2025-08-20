type ('a, 'b, 'handler) t =
  { action : 'a -> ('b, 'handler) Eff.t
  ; deps : Deps.t
  ; dynamic_deps : bool
  }

let make ?(dynamic_deps = true) ?(deps = Deps.empty) action =
  { action; dynamic_deps; deps }
;;

let action { action; _ } = action
let deps { deps; _ } = deps
let has_dynamic_deps { dynamic_deps; _ } = dynamic_deps
let set_dynamic_deps dynamic_deps flow = { flow with dynamic_deps }
let with_dynamic_deps flow = set_dynamic_deps true flow
let no_dynamic_deps flow = set_dynamic_deps false flow
