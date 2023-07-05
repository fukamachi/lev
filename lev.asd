#|
  This file is a part of lev project.
  Copyright (c) 2014 Eitaro Fukamachi (e.arrows@gmail.com)
|#

#|
  Author: Eitaro Fukamachi (e.arrows@gmail.com)
|#

(in-package :cl-user)
(defpackage lev-asd
  (:use :cl :asdf))
(in-package :lev-asd)

(defsystem lev
  :version "0.1.0"
  :author "Eitaro Fukamachi"
  :license "BSD 2-Clause"
  :depends-on (:cffi :lev-config)
  :components ((:module "src"
                :components
                ((:file "lev" :depends-on ("wrapper"))
                 (:file "bindings" :depends-on ("lev"))
                 (:file "exports" :depends-on ("bindings"))
                 (:file "wrapper"))))
  :description "libev bindings for Common Lisp"
  :long-description
  #.(with-open-file (stream (merge-pathnames
                             #p"README.md"
                             (or *load-pathname* *compile-file-pathname*))
                            :if-does-not-exist nil
                            :direction :input)
      (when stream
        (let ((seq (make-array (file-length stream)
                               :element-type 'character
                               :fill-pointer t)))
          (setf (fill-pointer seq) (read-sequence seq stream))
          seq)))
  :in-order-to ((test-op (test-op lev-test))))
