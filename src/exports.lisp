(in-package :lev)

(cl:export '#.(lispify "EV_MINPRI" 'constant))
(cl:export '#.(lispify "EV_MAXPRI" 'constant))
(cl:export '#.(lispify "EV_VERSION_MAJOR" 'constant))
(cl:export '#.(lispify "EV_VERSION_MINOR" 'constant))

(cl:export '#.(lispify "EV_UNDEF" 'enumvalue))
(cl:export '#.(lispify "EV_NONE" 'enumvalue))
(cl:export '#.(lispify "EV_READ" 'enumvalue))
(cl:export '#.(lispify "EV_WRITE" 'enumvalue))
(cl:export '#.(lispify "EV__IOFDSET" 'enumvalue))
(cl:export '#.(lispify "EV_IO" 'enumvalue))
(cl:export '#.(lispify "EV_TIMER" 'enumvalue))
#+lev-ev-compat3
(cl:export '#.(lispify "EV_TIMEOUT" 'enumvalue))
(cl:export '#.(lispify "EV_PERIODIC" 'enumvalue))
(cl:export '#.(lispify "EV_SIGNAL" 'enumvalue))
(cl:export '#.(lispify "EV_CHILD" 'enumvalue))
(cl:export '#.(lispify "EV_STAT" 'enumvalue))
(cl:export '#.(lispify "EV_IDLE" 'enumvalue))
(cl:export '#.(lispify "EV_PREPARE" 'enumvalue))
(cl:export '#.(lispify "EV_CHECK" 'enumvalue))
(cl:export '#.(lispify "EV_EMBED" 'enumvalue))
(cl:export '#.(lispify "EV_FORK" 'enumvalue))
(cl:export '#.(lispify "EV_CLEANUP" 'enumvalue))
(cl:export '#.(lispify "EV_ASYNC" 'enumvalue))
(cl:export '#.(lispify "EV_CUSTOM" 'enumvalue))
(cl:export '#.(lispify "EV_ERROR" 'enumvalue))

(cl:export '#.(lispify "ev_watcher" 'classname))

(cl:export '#.(lispify "ev_watcher_list" 'classname))

(cl:export '#.(lispify "ev_watcher_time" 'classname))

(cl:export '#.(lispify "ev_io" 'classname))

(cl:export '#.(lispify "ev_timer" 'classname))

(cl:export '#.(lispify "ev_periodic" 'classname))

(cl:export '#.(lispify "ev_signal" 'classname))

(cl:export '#.(lispify "ev_child" 'classname))

#+lev-ev-stat
(cl:export '#.(lispify "ev_stat" 'classname))

#+lev-ev-idle
(cl:export '#.(lispify "ev_idle" 'classname))

(cl:export '#.(lispify "ev_prepare" 'classname))

(cl:export '#.(lispify "ev_check" 'classname))

#+lev-ev-fork
(cl:export '#.(lispify "ev_fork" 'classname))

#+lev-ev-cleanup
(cl:export '#.(lispify "ev_cleanup" 'classname))

#+lev-ev-embed
(cl:export '#.(lispify "ev_embed" 'classname))

#+lev-ev-async
(cl:export '#.(lispify "ev_async" 'classname))

(cl:export '#.(lispify "ev_any_watcher" 'classname))
(cl:export '#.(lispify "EVFLAG_AUTO" 'enumvalue))
(cl:export '#.(lispify "EVFLAG_NOENV" 'enumvalue))
(cl:export '#.(lispify "EVFLAG_FORKCHECK" 'enumvalue))
(cl:export '#.(lispify "EVFLAG_NOINOTIFY" 'enumvalue))
#+lev-ev-compat3
(cl:export '#.(lispify "EVFLAG_NOSIGFD" 'enumvalue))
(cl:export '#.(lispify "EVFLAG_SIGNALFD" 'enumvalue))
(cl:export '#.(lispify "EVFLAG_NOSIGMASK" 'enumvalue))

(cl:export '#.(lispify "EVBACKEND_SELECT" 'enumvalue))
(cl:export '#.(lispify "EVBACKEND_POLL" 'enumvalue))
(cl:export '#.(lispify "EVBACKEND_EPOLL" 'enumvalue))
(cl:export '#.(lispify "EVBACKEND_KQUEUE" 'enumvalue))
(cl:export '#.(lispify "EVBACKEND_DEVPOLL" 'enumvalue))
(cl:export '#.(lispify "EVBACKEND_PORT" 'enumvalue))
(cl:export '#.(lispify "EVBACKEND_ALL" 'enumvalue))
(cl:export '#.(lispify "EVBACKEND_MASK" 'enumvalue))

(cl:export '#.(lispify "ev_version_major" 'function))
(cl:export '#.(lispify "ev_version_minor" 'function))

(cl:export '#.(lispify "ev_supported_backends" 'function))
(cl:export '#.(lispify "ev_recommended_backends" 'function))
(cl:export '#.(lispify "ev_embeddable_backends" 'function))

(cl:export '#.(lispify "ev_time" 'function))

(cl:export '#.(lispify "ev_sleep" 'function))

(cl:export '#.(lispify "ev_set_allocator" 'function))

(cl:export '#.(lispify "ev_set_syserr_cb" 'function))

(cl:export '#.(lispify "ev_default_loop" 'function))

(cl:export '#.(lispify "ev_default_loop_uc_" 'function))

(cl:export '#.(lispify "ev_is_default_loop" 'function))

(cl:export '#.(lispify "ev_loop_new" 'function))

(cl:export '#.(lispify "ev_now" 'function))

(cl:export '#.(lispify "ev_loop_destroy" 'function))

(cl:export '#.(lispify "ev_loop_fork" 'function))

(cl:export '#.(lispify "ev_backend" 'function))

(cl:export '#.(lispify "ev_now_update" 'function))

#+lev-ev-walk
(cl:export '#.(lispify "ev_walk" 'function))

(cl:export '#.(lispify "EVRUN_NOWAIT" 'enumvalue))
(cl:export '#.(lispify "EVRUN_ONCE" 'enumvalue))

(cl:export '#.(lispify "EVBREAK_CANCEL" 'enumvalue))
(cl:export '#.(lispify "EVBREAK_ONE" 'enumvalue))
(cl:export '#.(lispify "EVBREAK_ALL" 'enumvalue))

(cl:export '#.(lispify "ev_run" 'function))

(cl:export '#.(lispify "ev_break" 'function))

(cl:export '#.(lispify "ev_ref" 'function))
(cl:export '#.(lispify "ev_unref" 'function))

(cl:export '#.(lispify "ev_once" 'function))

(cl:export '#.(lispify "ev_iteration" 'function))
(cl:export '#.(lispify "ev_depth" 'function))
(cl:export '#.(lispify "ev_verify" 'function))

(cl:export '#.(lispify "ev_set_io_collect_interval" 'function))
(cl:export '#.(lispify "ev_set_timeout_collect_interval" 'function))

(cl:export '#.(lispify "ev_set_userdata" 'function))
(cl:export '#.(lispify "ev_userdata" 'function))
(cl:export '#.(lispify "ev_set_invoke_pending_cb" 'function))
(cl:export '#.(lispify "ev_set_loop_release_cb" 'function))

(cl:export '#.(lispify "ev_pending_count" 'function))
(cl:export '#.(lispify "ev_invoke_pending" 'function))

(cl:export '#.(lispify "ev_suspend" 'function))
(cl:export '#.(lispify "ev_resume" 'function))

(cl:export 'ev-init)

(cl:export 'ev-io-set)
(cl:export 'ev-timer-set)
(cl:export 'ev-periodic-set)
(cl:export 'ev-signal-set)
(cl:export 'ev-child-set)
(cl:export 'ev-stat-set)
(cl:export 'ev-idle-set)
(cl:export 'ev-prepare-set)
(cl:export 'ev-check-set)
(cl:export 'ev-embed-set)
(cl:export 'ev-fork-set)
(cl:export 'ev-cleanup-set)
(cl:export 'ev-async-set)

(cl:export 'ev-io-init)
(cl:export 'ev-timer-init)
(cl:export 'ev-periodic-init)
(cl:export 'ev-signal-init)
(cl:export 'ev-child-init)
(cl:export 'ev-stat-init)
(cl:export 'ev-idle-init)
(cl:export 'ev-prepare-init)
(cl:export 'ev-check-init)
(cl:export 'ev-embed-init)
(cl:export 'ev-fork-init)
(cl:export 'ev-cleanup-init)
(cl:export 'ev-async-init)

(cl:export 'ev-is-pending)
(cl:export 'ev-is-active)

(cl:export 'ev-cb)
(cl:export 'ev-set-cb)
(cl:export 'ev-priority)
(cl:export 'ev-set-priority)
(cl:export 'ev-periodic-at)

(cl:export '#.(lispify "ev_feed_event" 'function))
(cl:export '#.(lispify "ev_feed_fd_event" 'function))
(cl:export '#.(lispify "ev_feed_signal" 'function))
(cl:export '#.(lispify "ev_feed_signal_event" 'function))

(cl:export '#.(lispify "ev_invoke" 'function))
(cl:export '#.(lispify "ev_clear_pending" 'function))

(cl:export '#.(lispify "ev_io_start" 'function))
(cl:export '#.(lispify "ev_io_stop" 'function))

(cl:export '#.(lispify "ev_timer_start" 'function))
(cl:export '#.(lispify "ev_timer_stop" 'function))
(cl:export '#.(lispify "ev_timer_again" 'function))
(cl:export '#.(lispify "ev_timer_remaining" 'function))

#+lev-ev-periodic
(progn
  (cl:export '#.(lispify "ev_periodic_start" 'function))
  (cl:export '#.(lispify "ev_periodic_stop" 'function))
  (cl:export '#.(lispify "ev_periodic_again" 'function)))

#+lev-ev-signal
(progn
  (cl:export '#.(lispify "ev_signal_start" 'function))
  (cl:export '#.(lispify "ev_signal_stop" 'function)))

#+lev-ev-child
(progn
  (cl:export '#.(lispify "ev_child_start" 'function))
  (cl:export '#.(lispify "ev_child_stop" 'function)))

#+lev-ev-stat
(progn
  (cl:export '#.(lispify "ev_stat_start" 'function))
  (cl:export '#.(lispify "ev_stat_stop" 'function))
  (cl:export '#.(lispify "ev_stat_stat" 'function)))

#+lev-ev-idle
(progn
  (cl:export '#.(lispify "ev_idle_start" 'function))
  (cl:export '#.(lispify "ev_idle_stop" 'function)))

#+lev-ev-prepare
(progn
  (cl:export '#.(lispify "ev_prepare_start" 'function))
  (cl:export '#.(lispify "ev_prepare_stop" 'function)))

#+lev-ev-check
(progn
  (cl:export '#.(lispify "ev_check_start" 'function))
  (cl:export '#.(lispify "ev_check_stop" 'function)))

#+lev-ev-fork
(progn
  (cl:export '#.(lispify "ev_fork_start" 'function))
  (cl:export '#.(lispify "ev_fork_stop" 'function)))

#+lev-ev-cleanup
(progn
  (cl:export '#.(lispify "ev_cleanup_start" 'function))
  (cl:export '#.(lispify "ev_cleanup_stop" 'function)))

#+lev-ev-embed
(progn
  (cl:export '#.(lispify "ev_embed_start" 'function))
  (cl:export '#.(lispify "ev_embed_stop" 'function))
  (cl:export '#.(lispify "ev_embed_sweep" 'function)))

#+lev-ev-async
(progn
  (cl:export '#.(lispify "ev_async_start" 'function))
  (cl:export '#.(lispify "ev_async_stop" 'function))
  (cl:export '#.(lispify "ev_async_send" 'function)))

#+lev-ev-compat3
(progn
  (cl:export '#.(lispify "EVLOOP_NONBLOCK" 'constant))
  (cl:export '#.(lispify "EVLOOP_ONESHOT" 'constant))
  (cl:export '#.(lispify "EVUNLOOP_CANCEL" 'constant))
  (cl:export '#.(lispify "EVUNLOOP_ONE" 'constant))
  (cl:export '#.(lispify "EVUNLOOP_ALL" 'constant)))

(cl:export '#.(lispify "ev_loop" 'function))
(cl:export '#.(lispify "ev_unloop" 'function))

(cl:export '#.(lispify "ev_default_destroy" 'function))

(cl:export '#.(lispify "ev_default_fork" 'function))

(cl:export '#.(lispify "ev_loop_count" 'function))

(cl:export '#.(lispify "ev_loop_depth" 'function))

(cl:export '#.(lispify "ev_loop_verify" 'function))
