(in-package :cl-user)

 (defpackage :lev-config
   (:use :common-lisp)
   (:export #:load-from-custom-path
            #:libev))

 (in-package :lev-config)

 (defmacro load-from-custom-path (path)
   "Define the path where libev is to be found:
     (ql:quickload :lev-config)
     (lev-config:load-from-custom-path \"/opt/local/lib/libev.so\")
     (ql:quickload :lev)"
   `(progn
      (cffi:define-foreign-library libev (t ,path))
      (cffi:use-foreign-library libev)))
