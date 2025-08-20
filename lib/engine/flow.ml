type ('a, 'b, 'handler) t =
  { action : 'a -> ('b, 'handler) Eff.t
  ; deps : Deps.t
  ; dynamic_deps : bool
  }

let eff ?(dynamic_deps = true) ?(deps = Deps.empty) action =
  { action; dynamic_deps; deps }
;;

let lift ?(dynamic_deps = false) ?deps f =
  eff ~dynamic_deps ?deps (fun x -> Eff.return (f x))
;;

let id = { action = Eff.return; deps = Deps.empty; dynamic_deps = false }
let action { action; _ } = action
let deps { deps; _ } = deps
let has_dynamic_deps { dynamic_deps; _ } = dynamic_deps
let on_dynamic_deps f flow = { flow with dynamic_deps = f flow.dynamic_deps }
let on_deps f flow = { flow with deps = f flow.deps }

let set_dynamic_deps dynamic_deps flow =
  on_dynamic_deps (fun _ -> dynamic_deps) flow
;;

let with_dynamic_deps flow = set_dynamic_deps true flow
let no_dynamic_deps flow = set_dynamic_deps false flow

let dimap f g flow =
  { flow with action = (fun x -> Eff.map g (action flow (f x))) }
;;

let lmap f flow = dimap f (fun x -> x) flow
let rmap f flow = dimap (fun x -> x) f flow
