(in-package :lev)

#+lev-ev-full
(eval-when (:compile-toplevel :load-toplevel :execute)
  (pushnew :lev-ev-periodic *features*)
  (pushnew :lev-ev-stat *features*)
  (pushnew :lev-ev-prepare *features*)
  (pushnew :lev-ev-check *features*)
  (pushnew :lev-ev-idle *features*)
  (pushnew :lev-ev-fork *features*)
  (pushnew :lev-ev-cleanup *features*)
  #-windows
  (pushnew :lev-ev-child *features*)
  (pushnew :lev-ev-async *features*)
  (pushnew :lev-ev-embed *features*)
  (pushnew :lev-ev-signal *features*)
  #+lev-not-yet
  (pushnew :lev-ev-walk *features*))

(defconstant #.(lispify "EV_MINPRI" 'constant) -2)
(defconstant #.(lispify "EV_MAXPRI" 'constant) +2)

(defconstant #.(lispify "EV_VERSION_MAJOR" 'constant) 4)
(defconstant #.(lispify "EV_VERSION_MINOR" 'constant) 15)

(defanonenum
  (#.(lispify "EV_UNDEF" 'enumvalue) #xFFFFFFFF)    ;; guaranteed to be invalid
  (#.(lispify "EV_NONE" 'enumvalue) #x00)           ;; no events
  (#.(lispify "EV_READ" 'enumvalue) #x01)           ;; ev_io detected read will not block
  (#.(lispify "EV_WRITE" 'enumvalue) #x02)          ;; ev_io detected write will not block
  (#.(lispify "EV__IOFDSET" 'enumvalue) #x80)       ;; internal use only
  (#.(lispify "EV_TIMER" 'enumvalue) #x00000100)    ;; timer timed out
  #+ev-compat3
  (#.(lispify "EV_TIMEOUT" 'enumvalue) EV_TIMER)    ;; pre 4.0 API compatibility
  (#.(lispify "EV_PERIODIC" 'enumvalue) #x00000200) ;; periodic timer timed out
  (#.(lispify "EV_SIGNAL" 'enumvalue) #x00000400)   ;; signal was received
  (#.(lispify "EV_CHILD" 'enumvalue) #x00000800)    ;; child/pid has status change
  (#.(lispify "EV_STAT" 'enumvalue) #x00001000)     ;; stat data changed
  (#.(lispify "EV_IDLE" 'enumvalue) #x00002000)     ;; event loop is idling
  (#.(lispify "EV_PREPARE" 'enumvalue) #x00004000)  ;; event loop about to poll
  (#.(lispify "EV_CHECK" 'enumvalue) #x00008000)    ;; event loop finished poll
  (#.(lispify "EV_EMBED" 'enumvalue) #x00010000)    ;; embedded event loop needs sweep
  (#.(lispify "EV_FORK" 'enumvalue) #x00020000)     ;; event loop resumed in child
  (#.(lispify "EV_CLEANUP" 'enumvalue) #x00040000)  ;; event loop resumed in child
  (#.(lispify "EV_ASYNC" 'enumvalue) #x00080000)    ;; async intra-loop signal
  (#.(lispify "EV_CUSTOM" 'enumvalue) #x01000000)   ;; for use by user code
  (#.(lispify "EV_ERROR" 'enumvalue) #x80000000))   ;; sent when an error occurs

;; alias for type-detection
(defconstant #.(lispify "EV_IO" 'enumvalue) #.(lispify "EV_READ" 'enumvalue))

(eval-when (:compile-toplevel :load-toplevel)
  ;; shared by all watchers
  (defparameter *ev-watcher-slots*
    '((#.(lispify "active" 'slotname) :int)   ;; private
      (#.(lispify "pending" 'slotname) :int)  ;; private
      (#.(lispify "priority" 'slotname) :int) ;; private
      (#.(lispify "data" 'slotname) :pointer) ;; rw
      (#.(lispify "cb" 'slotname) :pointer)))
  (defparameter *ev-watcher-list-slots*
    `(,@*ev-watcher-slots*
      ;; private
      (#.(lispify "next" 'slotname) :pointer)))
  (defparameter *ev-watcher-time-slots*
    `(,@*ev-watcher-slots*
      ;; private
      (#.(lispify "at" 'slotname) :double))))

#.`(cffi:defcstruct #.(lispify "ev_watcher" 'classname)
     ,@*ev-watcher-slots*)

#.`(cffi:defcstruct #.(lispify "ev_watcher_list" 'classname)
     ,@*ev-watcher-list-slots*)

#.`(cffi:defcstruct #.(lispify "ev_watcher_time" 'classname)
     ,@*ev-watcher-time-slots*)

;; invoked when fd is either EV_READable or EV_WRITEable
;; revent EV_READ, EV_WRITE
#.`(cffi:defcstruct #.(lispify "ev_io" 'classname)
     ,@*ev-watcher-list-slots*
     (#.(lispify "fd" 'slotname) :int)      ;; ro
     (#.(lispify "events" 'slotname) :int)) ;; ro

;; invoked after a specific time, repeatable (based on monotonic clock)
;; revent EV_TIMEOUT
#.`(cffi:defcstruct #.(lispify "ev_timer" 'classname)
     ,@*ev-watcher-time-slots*
     (#.(lispify "repeat" 'slotname) :double)) ;; rw

;; invoked at some specific time, possibly repeating at regular intervals (based on UTC)
;; revent EV_PERIODIC
#.`(cffi:defcstruct #.(lispify "ev_periodic" 'classname)
     ,@*ev-watcher-time-slots*
     (#.(lispify "offset" 'slotname) :double)          ;; rw
     (#.(lispify "interval" 'slotname) :double)        ;; rw
     (#.(lispify "reschedule_cb" 'slotname) :pointer)) ;; rw

;; invoked when the given signal has been received
;; revent EV_SIGNAL
#.`(cffi:defcstruct #.(lispify "ev_signal" 'classname)
     ,@*ev-watcher-list-slots*
     (#.(lispify "signum" 'slotname) :int)) ;; ro

;; invoked when sigchld is received and waitpid indicates the given pid
;; revent EV_CHILD
#.`(cffi:defcstruct #.(lispify "ev_child" 'classname)
     ,@*ev-watcher-list-slots*
     (#.(lispify "flags" 'slotname) :int)    ;; private
     (#.(lispify "pid" 'slotname) :int)      ;; ro
     (#.(lispify "rpid" 'slotname) :int)     ;; rw, holds the received pid
     (#.(lispify "rstatus" 'slotname) :int)) ;; rw, holds the exit status, use the macros from sys/wait.h

;; invoked each time the stat data changes for a given path
;; revent EV_STAT
#+lev-ev-stat
#.`(cffi:defcstruct #.(lispify "ev_stat" 'classname)
     ,@*ev-watcher-list-slots*
     (#.(lispify "timer" 'slotname) (:struct #.(lispify "ev_timer" 'classname))) ;; private
     (#.(lispify "interval" 'slotname) :double) ;; ro
     (#.(lispify "path" 'slotname) :string)     ;; ro
     (#.(lispify "prev" 'slotname) :pointer)    ;; ro
     (#.(lispify "attr" 'slotname) :pointer)    ;; ro

     ;; wd for inotify, fd for kqueue
     (#.(lispify "wd" 'slotname) :int))

;; invoked when the nothing else needs to be done, keeps the process from blocking
;; revent EV_IDLE
#+lev-ev-idle
#.`(cffi:defcstruct #.(lispify "ev_idle" 'classname)
     ,@*ev-watcher-slots*)

;; invoked for each run of the mainloop, just before the blocking call
;; you can still change events in any way you like
;; revent EV_PREPARE
#.`(cffi:defcstruct #.(lispify "ev_prepare" 'classname)
     ,@*ev-watcher-slots*)

;; invoked for each run of the mainloop, just after the blocking call
;; revent EV_CHECK
#.`(cffi:defcstruct #.(lispify "ev_check" 'classname)
     ,@*ev-watcher-slots*)

#+lev-ev-fork
;; the callback gets invoked before check in the child process when a fork was detected
;; revent EV_FORK
#.`(cffi:defcstruct #.(lispify "ev_fork" 'classname)
     ,@*ev-watcher-slots*)

#+lev-ev-cleanup
;; is invoked just before the loop gets destroyed
;; revent EV_CLEANUP
#.`(cffi:defcstruct #.(lispify "ev_cleanup" 'classname)
     ,@*ev-watcher-slots*)

#+lev-ev-embed
;; used to embed an event loop inside another
;; the callback gets invoked when the event loop has handled events, and can be 0
#.`(cffi:defcstruct #.(lispify "ev_embed" 'classname)
     ,@*ev-watcher-slots*

     (#.(lispify "other" 'slotname) :pointer)                  ;; ro
     (#.(lispify "io" 'slotname) (:struct #.(lispify "ev_io" 'classname))) ;; private
     (#.(lispify "prepare" 'slotname) (:struct #.(lispify "ev_prepare" 'classname))) ;; private
     (#.(lispify "check" 'slotname) (:struct #.(lispify "ev_check" 'classname))) ;; unused
     (#.(lispify "timer" 'slotname) (:struct #.(lispify "ev_timer" 'classname))) ;; unused
     (#.(lispify "periodic" 'slotname) (:struct #.(lispify "ev_periodic" 'classname))) ;; unused
     (#.(lispify "idle" 'slotname) (:struct #.(lispify "ev_idle" 'classname))) ;; unused
     (#.(lispify "fork" 'slotname) (:struct #.(lispify "ev_fork" 'classname))) ;; private
     #+lev-ev-cleanup
     (#.(lispify "cleanup" 'slotname) (:struct #.(lispify "ev_cleanup" 'classname)))) ;; unused

#+lev-ev-async
;; invoked when somebody calls ev_async_send on the watcher
;; revent EV_ASYNC
#.`(cffi:defcstruct #.(lispify "ev_async" 'classname)
     ,@*ev-watcher-slots*
     (#.(lispify "sent" 'slotname) :pointer)) ;; private

;; the presence of this union forces similar struct layout
#.`(cffi:defcunion #.(lispify "ev_any_watcher" 'classname)
     (#.(lispify "w" 'slotname) (:struct #.(lispify "ev_watcher" 'classname)))
     (#.(lispify "wl" 'slotname) (:struct #.(lispify "ev_watcher_list" 'classname)))
     (#.(lispify "io" 'slotname) (:struct #.(lispify "ev_io" 'classname)))
     (#.(lispify "timer" 'slotname) (:struct #.(lispify "ev_timer" 'classname)))
     (#.(lispify "periodic" 'slotname) (:struct #.(lispify "ev_periodic" 'classname)))
     (#.(lispify "signal" 'slotname) (:struct #.(lispify "ev_signal" 'classname)))
     (#.(lispify "child" 'slotname) (:struct #.(lispify "ev_child" 'classname)))
     #+lev-ev-stat
     (#.(lispify "stat" 'slotname) (:struct #.(lispify "ev_stat" 'classname)))
     #+lev-ev-idle
     (#.(lispify "idle" 'slotname) (:struct #.(lispify "ev_idle" 'classname)))
     (#.(lispify "prepare" 'slotname) (:struct #.(lispify "ev_prepare" 'classname)))
     (#.(lispify "check" 'slotname) (:struct #.(lispify "ev_check" 'classname)))
     #+lev-ev-fork
     (#.(lispify "fork" 'slotname) (:struct #.(lispify "ev_fork" 'classname)))
     #+lev-ev-cleanup
     (#.(lispify "cleanup" 'slotname) (:struct #.(lispify "ev_cleanup" 'classname)))
     #+lev-ev-embed
     (#.(lispify "embed" 'slotname) (:struct #.(lispify "ev_embed" 'classname)))
     #+lev-ev-async
     (#.(lispify "async" 'slotname) (:struct #.(lispify "ev_async" 'classname))))

;; flag bits for ev_default_loop and ev_loop_new
(defanonenum
  ;; the default
  (#.(lispify "EVFLAG_AUTO" 'enumvalue) #x00000000)       ;; not quite a mask
  ;; flag bits
  (#.(lispify "EVFLAG_NOENV" 'enumvalue) #x01000000)      ;; do NOT consult environment
  (#.(lispify "EVFLAG_FORKCHECK" 'enumvalue) #x02000000)  ;; check for a fork in each iteration
  ;; debugging/feature disable
  (#.(lispify "EVFLAG_NOINOTIFY" 'enumvalue) #x00100000)  ;; do not attempt to use inotify
  #+ev-compat3
  (#.(lispify "EVFLAG_NOSIGFD" 'enumvalue) 0)             ;; compatibility to pre-3.9
  (#.(lispify "EVFLAG_SIGNALFD" 'enumvalue) #x00200000)   ;; attempt to use signalfd
  (#.(lispify "EVFLAG_NOSIGMASK" 'enumvalue) #x00400000)) ;; avoid modifying the signal mask

;; method bits to be ored together
(defanonenum
  (#.(lispify "EVBACKEND_SELECT" 'enumvalue) #x00000001)  ;; about anywhere
  (#.(lispify "EVBACKEND_POLL" 'enumvalue) #x00000002)    ;; !win
  (#.(lispify "EVBACKEND_EPOLL" 'enumvalue) #x00000004)   ;; linux
  (#.(lispify "EVBACKEND_KQUEUE" 'enumvalue) #x00000008)  ;; bsd
  (#.(lispify "EVBACKEND_DEVPOLL" 'enumvalue) #x00000010) ;; solaris 8, NYI
  (#.(lispify "EVBACKEND_PORT" 'enumvalue) #x00000020)    ;; solaris 10
  (#.(lispify "EVBACKEND_ALL" 'enumvalue) #x0000003F)     ;; all known backends
  (#.(lispify "EVBACKEND_MASK" 'enumvalue) #x0000FFFF))   ;; all future backends

(cffi:defcfun ("ev_version_major" #.(lispify "ev_version_major" 'function)) :int)
(cffi:defcfun ("ev_version_minor" #.(lispify "ev_version_minor" 'function)) :int)

(cffi:defcfun ("ev_supported_backends" #.(lispify "ev_supported_backends" 'function)) :unsigned-int)
(cffi:defcfun ("ev_recommended_backends" #.(lispify "ev_recommended_backends" 'function)) :unsigned-int)
(cffi:defcfun ("ev_embeddable_backends" #.(lispify "ev_embeddable_backends" 'function)) :unsigned-int)

(cffi:defcfun ("ev_time" #.(lispify "ev_time" 'function)) :double)
;; sleep for a while
(cffi:defcfun ("ev_sleep" #.(lispify "ev_sleep" 'function)) :void
  (delay :double))

;; Sets the allocation function to use, works like realloc.
;; It is used to allocate and free memory.
;; If it returns zero when memory needs to be allocated, the library might abort
;; or take some potentially destructive action.
;; The default is your system realloc function.
(cffi:defcfun ("ev_set_allocator" #.(lispify "ev_set_allocator" 'function)) :void
  (cb :pointer))

;; set the callback function to call on a
;; retryable syscall error
;; (such as failed select, poll, epoll_wait)
(cffi:defcfun ("ev_set_syserr_cb" #.(lispify "ev_set_syserr_cb" 'function)) :void
  (cb :pointer))

;; the default loop is the only one that handles signals and child watchers
;; you can call this as often as you like
(cffi:defcfun ("ev_default_loop" #.(lispify "ev_default_loop" 'function)) :pointer
  (flags :unsigned-int))

(cffi:defcfun ("ev_default_loop_uc_" #.(lispify "ev_default_loop_uc_" 'function)) :pointer)

(cffi:defcfun ("ev_is_default_loop" #.(lispify "ev_is_default_loop" 'function)) :int
  (loop :pointer))

;; create and destroy alternative loops that don't handle signals
(cffi:defcfun ("ev_loop_new" #.(lispify "ev_loop_new" 'function)) :pointer
  (flags :unsigned-int))

(cffi:defcfun ("ev_now" #.(lispify "ev_now" 'function)) :double
  (loop :pointer))

;; destroy event loops, also works for the default loop
(cffi:defcfun ("ev_loop_destroy" #.(lispify "ev_loop_destroy" 'function)) :void
  (loop :pointer))

;; this needs to be called after fork, to duplicate the loop
;; when you want to re-use it in the child
;; you can call it in either the parent or the child
;; you can actually call it at any time, anywhere :)
(cffi:defcfun ("ev_loop_fork" #.(lispify "ev_loop_fork" 'function)) :void
  (loop :pointer))

;; backend in use by loop
(cffi:defcfun ("ev_backend" #.(lispify "ev_backend" 'function)) :unsigned-int
  (loop :pointer))

;; update event loop time
(cffi:defcfun ("ev_now_update" #.(lispify "ev_now_update" 'function)) :void
  (loop :pointer))

#+lev-ev-walk
;; walk (almost) all watchers in the loop of a given type, invoking the
;; callback on every such watcher. The callback might stop the watcher,
;; but do nothing else with the loop
(cffi:defcfun ("ev_walk" #.(lispify "ev_walk" 'function)) :void
  (types :int)
  (cb :pointer))

;; ev_run flags values
(defanonenum
  (#.(lispify "EVRUN_NOWAIT" 'enumvalue) 1) ;; do not block/wait
  (#.(lispify "EVRUN_ONCE" 'enumvalue) 2))  ;; block *once* only

;; ev_break how values
(defanonenum
  (#.(lispify "EVBREAK_CANCEL" 'enumvalue) 0) ;; undo unloop
  (#.(lispify "EVBREAK_ONE" 'enumvalue) 1)    ;; unloop once
  (#.(lispify "EVBREAK_ALL" 'enumvalue) 2))   ;; unloop all loops

(cffi:defcfun ("ev_run" #.(lispify "ev_run" 'function)) :int
  (loop :pointer)
  (flags :int))

;; break out of the loop
(cffi:defcfun ("ev_break" #.(lispify "ev_break" 'function)) :void
  (loop :pointer)
  (how :int))

;; ref/unref can be used to add or remove a refcount on the mainloop. every watcher
;; keeps one reference. if you have a long-running watcher you never unregister that
;; should not keep ev_loop from running, unref() after starting, and ref() before stopping.
(cffi:defcfun ("ev_ref" #.(lispify "ev_ref" 'function)) :void
  (loop :pointer))
(cffi:defcfun ("ev_unref" #.(lispify "ev_unref" 'function)) :void
  (loop :pointer))

;; convenience function, wait for a single event, without registering an event watcher
;; if timeout is < 0, do wait indefinitely
(cffi:defcfun ("ev_once" #.(lispify "ev_once" 'function)) :void
  (loop :pointer)
  (fd :int)
  (events :int)
  (timeout :double)
  (cb :pointer)
  (arg :pointer))

;; number of loop iterations
(cffi:defcfun ("ev_iteration" #.(lispify "ev_iteration" 'function)) :unsigned-int
  (loop :pointer))
;; #ev_loop enters - #ev_loop leaves
(cffi:defcfun ("ev_depth" #.(lispify "ev_depth" 'function)) :unsigned-int
  (loop :pointer))
;; about if loop data corrupted
(cffi:defcfun ("ev_verify" #.(lispify "ev_verify" 'function)) :void
  (loop :pointer))

;; sleep at least this time, default 0
(cffi:defcfun ("ev_set_io_collect_interval" #.(lispify "ev_set_io_collect_interval" 'function)) :void
  (loop :pointer)
  (interval :double))
;; sleep at least this time, default 0
(cffi:defcfun ("ev_set_timeout_collect_interval" #.(lispify "ev_set_timeout_collect_interval" 'function)) :void
  (loop :pointer)
  (interval :double))

;; advanced stuff for threading etc. support, see docs
(cffi:defcfun ("ev_set_userdata" #.(lispify "ev_set_userdata" 'function)) :void
  (loop :pointer)
  (data :pointer))
(cffi:defcfun ("ev_userdata" #.(lispify "ev_userdata" 'function)) :pointer
  (loop :pointer))
(cffi:defcfun ("ev_set_invoke_pending_cb" #.(lispify "ev_set_invoke_pending_cb" 'function)) :void
  (loop :pointer)
  (invoke_pending_cb :pointer))
(cffi:defcfun ("ev_set_loop_release_cb" #.(lispify "ev_set_loop_release_cb" 'function)) :void
  (loop :pointer)
  (release :pointer)
  (acquire :pointer))

;; number of pending events, if any
(cffi:defcfun ("ev_pending_count" #.(lispify "ev_pending_count" 'function)) :unsigned-int
  (loop :pointer))
;; invoke all pending watchers
(cffi:defcfun ("ev_invoke_pending" #.(lispify "ev_invoke_pending" 'function)) :void
  (loop :pointer))

;; stop/start the timer handling.
(cffi:defcfun ("ev_suspend" #.(lispify "ev_suspend" 'function)) :void
  (loop :pointer))
(cffi:defcfun ("ev_resume" #.(lispify "ev_resume" 'function)) :void
  (loop :pointer))

(defun ev-init (ev cb_)
  (cffi:with-foreign-slots ((active priority cb) ev (:struct ev-io))
    (setf active 0
          priority 0
          cb (cffi:get-callback cb_))))

(defun ev-io-set (ev fd_ events_)
  (cffi:with-foreign-slots ((fd events) ev (:struct ev-io))
    (setf fd fd_
          events (logxor events_ ev--iofdset))))

(defun ev-timer-set (ev after_ repeat_)
  (cffi:with-foreign-slots ((at repeat) ev (:struct ev-timer))
    (setf at after_
          repeat repeat_)))

(defun ev-periodic-set (ev offset_ interval_ reschedule-cb_)
  (cffi:with-foreign-slots ((offset interval reschedule-cb) ev (:struct ev-periodic))
    (setf offset offset_
          interval interval_
          reschedule-cb reschedule-cb_)))

(defun ev-signal-set (ev signum)
  (setf (cffi:foreign-slot-value ev '(:struct ev-signal) 'signum) signum))

(defun ev-child-set (ev pid_ trace_)
  (cffi:with-foreign-slots ((pid flags) ev (:struct ev-child))
    (setf pid pid_
          flags (if trace_ 1 0))))

(defun ev-stat-set (ev path_ interval_)
  (cffi:with-foreign-slots ((path interval wd) ev (:struct ev-stat))
    (setf path path_
          interval interval_
          wd -2)))

;; nop, yes, this is a serious in-joke
(defun ev-idle-set (ev) (declare (ignore ev)))
;; nop, yes, this is a serious in-joke
(defun ev-prepare-set (ev) (declare (ignore ev)))
;; nop, yes, this is a serious in-joke
(defun ev-check-set (ev) (declare (ignore ev)))

(defun ev-embed-set (ev other_)
  (setf (cffi:foreign-slot-value ev '(:struct ev-embed) 'other) other_))

;; nop, yes, this is a serious in-joke
(defun ev-fork-set (ev) (declare (ignore ev)))
;; nop, yes, this is a serious in-joke
(defun ev-cleanup-set (ev) (declare (ignore ev)))
;; nop, yes, this is a serious in-joke
(defun ev-async-set (ev) (declare (ignore ev)))

(defun ev-io-init (ev cb fd events)
  (ev-init ev cb)
  (ev-io-set ev fd events))

(defun ev-timer-init (ev cb after repeat)
  (ev-init ev cb)
  (ev-timer-set ev after repeat))

(defun ev-periodic-init (ev cb offset interval reschedule-cb)
  (ev-init ev cb)
  (ev-periodic-set ev offset interval reschedule-cb))

(defun ev-signal-init (ev cb signum)
  (ev-init ev cb)
  (ev-signal-set ev signum))

(defun ev-child-init (ev cb pid trace)
  (ev-init ev cb)
  (ev-child-set ev pid trace))

(defun ev-stat-init (ev cb path interval)
  (ev-init ev cb)
  (ev-stat-set ev path interval))

(defun ev-idle-init (ev cb)
  (ev-init ev cb)
  (ev-idle-set ev))

(defun ev-prepare-init (ev cb)
  (ev-init ev cb)
  (ev-prepare-set ev))

(defun ev-check-init (ev cb)
  (ev-init ev cb)
  (ev-check-set ev))

(defun ev-embed-init (ev cb other)
  (ev-init ev cb)
  (ev-embed-set ev other))

(defun ev-fork-init (ev cb)
  (ev-init ev cb)
  (ev-fork-set ev))

(defun ev-cleanup-init (ev cb)
  (ev-init ev cb)
  (ev-cleanup-set ev))

(defun ev-async-init (ev cb)
  (ev-init ev cb)
  (ev-async-set ev))

(defun ev-is-pending (ev)
  (cffi:foreign-slot-value ev '(:struct ev-watcher) 'pending))

(defun ev-is-active (ev)
  (cffi:foreign-slot-value ev '(:struct ev-watcher) 'active))

(defun ev-cb (ev)
  (cffi:foreign-slot-value ev '(:struct ev-watcher) 'cb))
(defun (setf ev-cb) (cb ev)
  (setf (cffi:foreign-slot-value ev '(:struct ev-watcher) 'cb) cb))

(defun ev-set-cb (ev cb)
  (setf (ev-cb ev) cb))

#.(if (= ev-minpri ev-maxpri)
      `(progn
         (defun ev-priority (ev)
           ,ev-minpri)
         (defun (setf ev-priority) (priority ev)
           (declare (ignore ev))
           priority)
         (defun ev-set-priority (ev priority)
           (setf (ev-priority ev) priority)))
      `(progn
         (defun ev-priority (ev)
           (cffi:foreign-slot-value ev '(:struct ev-watcher) 'priority))
         (defun (setf ev-priority) (priority ev)
           (setf (cffi:foreign-slot-value ev '(:struct ev-watcher) 'priority) priority))
         (defun ev-set-priority (ev priority)
           (setf (ev-priority ev) priority))))

(defun ev-periodic-at (ev)
  (cffi:foreign-slot-value ev '(:struct ev-watcher-time) 'at))

(cffi:defcfun ("ev_feed_event" #.(lispify "ev_feed_event" 'function)) :void
  (loop :pointer)
  (w :pointer)
  (revents :int))

(cffi:defcfun ("ev_feed_fd_event" #.(lispify "ev_feed_fd_event" 'function)) :void
  (loop :pointer)
  (fd :int)
  (revents :int))

(cffi:defcfun ("ev_feed_signal" #.(lispify "ev_feed_signal" 'function)) :void
  (signum :int))

(cffi:defcfun ("ev_feed_signal_event" #.(lispify "ev_feed_signal_event" 'function)) :void
  (loop :pointer)
  (signum :int))

(cffi:defcfun ("ev_invoke" #.(lispify "ev_invoke" 'function)) :void
  (loop :pointer)
  (w :pointer)
  (revents :int))

(cffi:defcfun ("ev_clear_pending" #.(lispify "ev_clear_pending" 'function)) :int
  (loop :pointer)
  (w :pointer))

(cffi:defcfun ("ev_io_start" #.(lispify "ev_io_start" 'function)) :void
  (loop :pointer)
  (w :pointer))
(cffi:defcfun ("ev_io_stop" #.(lispify "ev_io_stop" 'function)) :void
  (loop :pointer)
  (w :pointer))

(cffi:defcfun ("ev_timer_start" #.(lispify "ev_timer_start" 'function)) :void
  (loop :pointer)
  (w :pointer))
(cffi:defcfun ("ev_timer_stop" #.(lispify "ev_timer_stop" 'function)) :void
  (loop :pointer)
  (w :pointer))
;; stops if active and no repeat, restarts if active and repeating, starts if inactive and repeating
(cffi:defcfun ("ev_timer_again" #.(lispify "ev_timer_again" 'function)) :void
  (loop :pointer)
  (w :pointer))
;; return remaining time
(cffi:defcfun ("ev_timer_remaining" #.(lispify "ev_timer_remaining" 'function)) :double
  (loop :pointer)
  (w :pointer))

#+lev-ev-periodic
(progn
  (cffi:defcfun ("ev_periodic_start" #.(lispify "ev_periodic_start" 'function)) :void
    (loop :pointer)
    (w :pointer))
  (cffi:defcfun ("ev_periodic_stop" #.(lispify "ev_periodic_stop" 'function)) :void
    (loop :pointer)
    (w :pointer))
  (cffi:defcfun ("ev_periodic_again" #.(lispify "ev_periodic_again" 'function)) :void
    (loop :pointer)
    (w :pointer)))

#+lev-ev-signal
(progn
  ;; only supported in the default loop
  (cffi:defcfun ("ev_signal_start" #.(lispify "ev_signal_start" 'function)) :void
    (loop :pointer)
    (w :pointer))
  (cffi:defcfun ("ev_signal_stop" #.(lispify "ev_signal_stop" 'function)) :void
    (loop :pointer)
    (w :pointer)))

#+lev-ev-child
(progn
  ;; only supported in the default loop
  (cffi:defcfun ("ev_child_start" #.(lispify "ev_child_start" 'function)) :void
    (loop :pointer)
    (w :pointer))
  (cffi:defcfun ("ev_child_stop" #.(lispify "ev_child_stop" 'function)) :void
    (loop :pointer)
    (w :pointer)))

#+lev-ev-stat
(progn
  (cffi:defcfun ("ev_stat_start" #.(lispify "ev_stat_start" 'function)) :void
    (loop :pointer)
    (w :pointer))
  (cffi:defcfun ("ev_stat_stop" #.(lispify "ev_stat_stop" 'function)) :void
    (loop :pointer)
    (w :pointer))
  (cffi:defcfun ("ev_stat_stat" #.(lispify "ev_stat_stat" 'function)) :void
    (loop :pointer)
    (w :pointer)))

#+lev-ev-idle
(progn
  (cffi:defcfun ("ev_idle_start" #.(lispify "ev_idle_start" 'function)) :void
    (loop :pointer)
    (w :pointer))
  (cffi:defcfun ("ev_idle_stop" #.(lispify "ev_idle_stop" 'function)) :void
    (loop :pointer)
    (w :pointer)))

#+lev-ev-prepare
(progn
  (cffi:defcfun ("ev_prepare_start" #.(lispify "ev_prepare_start" 'function)) :void
    (loop :pointer)
    (w :pointer))
  (cffi:defcfun ("ev_prepare_stop" #.(lispify "ev_prepare_stop" 'function)) :void
    (loop :pointer)
    (w :pointer)))

#+lev-ev-check
(progn
  (cffi:defcfun ("ev_check_start" #.(lispify "ev_check_start" 'function)) :void
    (loop :pointer)
    (w :pointer))
  (cffi:defcfun ("ev_check_stop" #.(lispify "ev_check_stop" 'function)) :void
    (loop :pointer)
    (w :pointer)))

#+lev-ev-fork
(progn
  (cffi:defcfun ("ev_fork_start" #.(lispify "ev_fork_start" 'function)) :void
    (loop :pointer)
    (w :pointer))
  (cffi:defcfun ("ev_fork_stop" #.(lispify "ev_fork_stop" 'function)) :void
    (loop :pointer)
    (w :pointer)))

#+lev-ev-cleanup
(progn
  (cffi:defcfun ("ev_cleanup_start" #.(lispify "ev_cleanup_start" 'function)) :void
    (loop :pointer)
    (w :pointer))
  (cffi:defcfun ("ev_cleanup_stop" #.(lispify "ev_cleanup_stop" 'function)) :void
    (loop :pointer)
    (w :pointer)))

#+lev-ev-embed
(progn
  ;; only supported when loop to be embedded is in fact embeddable
  (cffi:defcfun ("ev_embed_start" #.(lispify "ev_embed_start" 'function)) :void
    (loop :pointer)
    (w :pointer))
  (cffi:defcfun ("ev_embed_stop" #.(lispify "ev_embed_stop" 'function)) :void
    (loop :pointer)
    (w :pointer))
  (cffi:defcfun ("ev_embed_sweep" #.(lispify "ev_embed_sweep" 'function)) :void
    (loop :pointer)
    (w :pointer)))

#+lev-ev-async
(progn
  (cffi:defcfun ("ev_async_start" #.(lispify "ev_async_start" 'function)) :void
    (loop :pointer)
    (w :pointer))
  (cffi:defcfun ("ev_async_stop" #.(lispify "ev_async_stop" 'function)) :void
    (loop :pointer)
    (w :pointer))
  (cffi:defcfun ("ev_async_send" #.(lispify "ev_async_send" 'function)) :void
    (loop :pointer)
    (w :pointer)))

#+lev-ev-compat3
(progn
  (defconstant #.(lispify "EVLOOP_NONBLOCK" 'contant) #.(lispify "EVRUN_NOWAIT" 'contant))
  (defconstant #.(lispify "EVLOOP_ONESHOT" 'constant) #.(lispify "EVRUN_ONCE" 'constant))
  (defconstant #.(lispify "EVUNLOOP_CANCEL" 'constant) #.(lispify "EVBREAK_CANCEL" 'constant))
  (defconstant #.(lispify "EVUNLOOP_ONE" 'constant) #.(lispify "EVBREAK_ONE" 'constant))
  (defconstant #.(lispify "EVUNLOOP_ALL" 'constant) #.(lispify "EVBREAK_ALL" 'constant)))

(cffi:defcfun ("ev_loop" #.(lispify "ev_loop" 'function)) :void
  (loop :pointer)
  (flags :int))

(cffi:defcfun ("ev_unloop" #.(lispify "ev_unloop" 'function)) :void
  (loop :pointer)
  (how :int))

(cffi:defcfun ("ev_default_destroy" #.(lispify "ev_default_destroy" 'function)) :void)

(cffi:defcfun ("ev_default_fork" #.(lispify "ev_default_fork" 'function)) :void)

(cffi:defcfun ("ev_loop_count" #.(lispify "ev_loop_count" 'function)) :unsigned-int
  (loop :pointer))

(cffi:defcfun ("ev_loop_depth" #.(lispify "ev_loop_depth" 'function)) :unsigned-int
  (loop :pointer))

(cffi:defcfun ("ev_loop_verify" #.(lispify "ev_loop_verify" 'function)) :void
  (loop :pointer))
