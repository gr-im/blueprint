(lang dune 3.19)
(name blueprint)
(version dev)
(generate_opam_files)
(executables_implicit_empty_intf)

(source (github gr-im/blueprint))
(license GPL-3.0-or-later)
(authors "gr-im <grimfw@gmail.com>")
(maintainers
  "gr-im <grimfw@gmail.com>"
  "The XHTMLBoy <xhtmlboi@gmail.com>"
  "xvw <xaviervdw@gmail.com>"
  "msp <spanwmick@gmail.com>")

(package
 (name blueprint)
 (synopsis "Experiences around build-systems based on YOCaml")
 (description "Some experience mostly used for blog post illustration")
 (depends
  (ocaml (>= 5.3.0))

  ;; Test depedencies
  (ppx_expect :with-test)

  ;; Dev dependencies
  (utop :with-dev-setup)
  (ocamlformat :with-dev-setup)
  (ocp-indent :with-dev-setup)
  (merlin :with-dev-setup)
  (ocaml-lsp-server :with-dev-setup)))
