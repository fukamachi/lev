(cl:eval-when (:load-toplevel :execute)
   (asdf:operate 'asdf:load-op 'cffi-grovel))

 (asdf:defsystem lev-config
   :author "Eitaro Fukamachi"
   :license "BSD 2-Clause"
   :version "0.1.0"
   :description "Configure libev to be used by lev."
   :serial t
   :components ((:file "config")))
