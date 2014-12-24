# LEV

LEV is [libev](http://software.schmorp.de/pkg/libev.html) bindings for Common Lisp.

## Usage

```common-lisp
(ql:quickload :lev)

(cffi:defcallback stdin-cb :void ((evloop :pointer) (io :pointer) (revents :int))
  (declare (ignore revents))
  (format t "stdin ready~%")
  (lev:ev-io-stop evloop io))

(cffi:defcallback timeout-cb :void ((evloop :pointer) (timer :pointer) (revents :int))
  (declare (ignore timer revents))
  (format t "timeout~%")
  (lev:ev-break evloop lev:EVBREAK-ONE))

(let ((evloop (lev:ev-default-loop 0))
      (stdin-watcher (cffi:foreign-alloc '(:struct lev:ev-io)))
      (timeout-watcher (cffi:foreign-alloc '(:struct lev:ev-timer))))
  (unwind-protect
      (progn
        ;; initialize an io watcher, then start it
        ;; this one will watch for stdin to become readable
        (lev:ev-io-init stdin-watcher 'stdin-cb 0 lev:EV-READ)
        (lev:ev-io-start evloop stdin-watcher)

        ;; initialize a timer watcher, then start it
        ;; simple non-repeating 5.5 second timeout
        (lev:ev-timer-init timeout-watcher 'timeout-cb 5.5d0 0d0)
        (lev:ev-timer-start evloop timeout-watcher)

        (format t "running~%")
        (lev:ev-run evloop 0))
    (cffi:foreign-free stdin-watcher)
    (cffi:foreign-free timeout-watcher)))
```

## Why not cl-ev?

We already have [cl-ev](https://github.com/sbryant/cl-ev) for libev bindings, however I found there's some problems in it.

* Wrapping with CLOS. It's bad for performance, obviously
* Incomplete API
* The author is inactive in Common Lisp world anymore

## See Also

* [libev's documentation](http://pod.tst.eu/http://cvs.schmorp.de/libev/ev.pod)

## Author

* Eitaro Fukamachi (e.arrows@gmail.com)

## Copyright

Copyright (c) 2014 Eitaro Fukamachi (e.arrows@gmail.com)

## License

Licensed under the BSD 2-Clause License.
