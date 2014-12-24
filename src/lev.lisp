(in-package :cl-user)
(defpackage lev
  (:use :cl
        :lev.wrapper))
(in-package :lev)

(eval-when (:compile-toplevel :load-toplevel :execute)
  (pushnew :lev-ev-compat3 *features*)
  (pushnew :lev-ev-full *features*))

(eval-when (:load-toplevel)
  (cffi:define-foreign-library libev
    (:unix (:or "libev.4.dylib" "libev.4.so" "libev.dylib" "libev.so"))
    (t (:default "libev")))

  (unless (cffi:foreign-library-loaded-p 'libev)
    (cffi:use-foreign-library libev)))
