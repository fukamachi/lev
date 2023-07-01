(in-package :cl-user)
(defpackage lev
  (:use :cl
        :lev.wrapper)
  (:export
   #:libev))
(in-package :lev)

(eval-when (:compile-toplevel :load-toplevel :execute)
  (pushnew :lev-ev-compat3 *features*)
  (pushnew :lev-ev-full *features*))

;;; to load libev from a custom location...

;; (ql:quickload :cffi)
;; (cffi:define-foreign-library lev::libev
;;   (t "path/to/libev.4.so"))
;; (cffi:use-foreign-library lev::libev)
(eval-when (:load-toplevel)
  (unless (cffi:foreign-library-loaded-p 'libev)
    (cffi:define-foreign-library libev
      (:darwin (:or "libev.4.dylib" "libev.dylib"))
      (:unix (:or "libev.4.so" "libev.so.4" "libev.so"))
      (t (:default "libev")))

    (cffi:use-foreign-library libev)))
