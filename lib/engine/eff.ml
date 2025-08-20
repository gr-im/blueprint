type ('a, 'handler) t = 'handler -> 'a

module Identity = struct
  let map f = f
  let return x = x
  let ap f = f
  let bind x f = f x
end

let handle ~handler program initiale_value = (program initiale_value) handler
let perform program = program
let return x _ = Identity.return x
let map f handler x = (Identity.map f) (handler x)
let ap handler_a handler_b x = Identity.ap (handler_a x) (handler_b x)
let zip a b = ap (ap (return (fun a b -> a, b)) a) b
let bind handler f x = Identity.bind (handler x) (fun a -> (f a) x)

module Infix = struct
  let ( <$> ) = map
  let ( <*> ) = ap
  let ( >>= ) = bind
  let ( =<< ) f x = bind x f
  let ( >|= ) x f = map f x
end

module Syntax = struct
  let ( let+ ) x f = map f x
  let ( and+ ) = zip
  let ( let* ) = bind
  let ( let*! ) x f = bind (perform x) f
  let ( let+! ) x f = map f (perform x)
end

include Infix
include Syntax
