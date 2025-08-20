open Blueprint_engine

class type logger = object
  method log : level:string -> string -> unit
end

class type console = object
  method print_line : string -> unit
  method read_line : unit -> string
end

let log ~level message (handler : #logger) = handler#log ~level message
let print_line message (handler : #console) = handler#print_line message
let read_line () (handler : #console) = handler#read_line ()

class tape =
  object
    val tape : (string * string * string option) list ref = ref []

    method push ?arg ~handler operation =
      tape := (handler, operation, arg) :: !tape

    method get_tape = List.rev !tape
  end

class test_logger (tape : #tape) =
  let handler = "logger" in
  object
    method log ~level message =
      let arg = Format.asprintf "[%s] %s" level message in
      tape#push ~handler "log" ~arg
  end

class test_console (tape : #tape) =
  let handler = "console" in
  object
    method print_line arg = tape#push ~handler "print_line" ~arg

    method read_line () =
      let arg = "Grim" in
      let () = tape#push ~handler "read_line" ~arg in
      arg
  end

let dump_tape (obj : #tape) =
  List.iter
    (fun (handler, operation, arg) ->
       arg
       |> Format.asprintf
            "[%s.%s] (%a)"
            handler
            operation
            Format.(pp_print_option pp_print_string)
       |> print_endline)
    obj#get_tape
;;

let%expect_test "a simple logger with one operation" =
  let program () = Eff.perform @@ log ~level:"debug" "Hello World!"
  and tape = new tape in
  let () =
    Eff.handle
      ~handler:
        object
          inherit test_logger tape
        end
      program
      ()
  in
  dump_tape tape;
  [%expect {| [logger.log] ([debug] Hello World!) |}]
;;

let%expect_test "a simple logger with multiple operation" =
  let program () =
    let open Eff in
    let*! () = log ~level:"debug" "Hello World!" in
    let*! () = log ~level:"app" "Hello Pierre!" in
    let+! () = log ~level:"info" "End of the program" in
    ()
  and tape = new tape in
  let () =
    Eff.handle
      ~handler:
        object
          inherit test_logger tape
        end
      program
      ()
  in
  dump_tape tape;
  [%expect
    {|
    [logger.log] ([debug] Hello World!)
    [logger.log] ([app] Hello Pierre!)
    [logger.log] ([info] End of the program)
    |}]
;;

let%expect_test "teletype example" =
  let program () =
    let open Eff in
    let*! () = log ~level:"debug" "Start teletype example" in
    let*! () = print_line "Hello, World!" in
    let*! () = print_line "What is your name?" in
    let*! name = read_line () in
    let*! () = print_line ("Hello " ^ name ^ "!") in
    let+! () = log ~level:"warning" "End teletype example" in
    ()
  and tape = new tape in
  let () =
    Eff.handle
      ~handler:
        object
          inherit test_logger tape
          inherit test_console tape
        end
      program
      ()
  in
  dump_tape tape;
  [%expect
    {|
    [logger.log] ([debug] Start teletype example)
    [console.print_line] (Hello, World!)
    [console.print_line] (What is your name?)
    [console.read_line] (Grim)
    [console.print_line] (Hello Grim!)
    [logger.log] ([warning] End teletype example)
    |}]
;;
