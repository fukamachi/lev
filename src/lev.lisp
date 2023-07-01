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
    (:darwin (:or "libev.4.dylib" "libev.dylib"))
    (:unix (:or "libev.4.so" "libev.so.4" "libev.so"))
    (t (:default "libev")))

  (unless (cffi:foreign-library-loaded-p 'libev)
    (cffi:use-foreign-library libev)))
