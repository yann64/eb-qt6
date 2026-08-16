' Idiomatic layer: QTimer. A plain QObject, like ButtonGroup
' (buttongroup.bas) - needs a real parent widget at construction so Qt
' manages its lifetime, or it would leak silently if never parented or
' destroyed.
'
' Named QTimer, not Timer - eBasic's own stdlib already defines a
' top-level `Timer()` function (seconds elapsed, see the Date/Time
' Library reference) and identifiers are case-insensitive, so a bare
' `TYPE Timer` collides with it.

#include once "widget.bas"
#include once "raw/qt6_timer.bas"

TYPE QTimer EXTENDS QtObject
END TYPE

''' `parent` - pass a real parent widget so Qt manages the timer's
''' lifetime automatically (a plain `DIM x AS QtWidget` handle of 0
''' would leak, see this file's own top comment).
FUNCTION NewQTimer(BYVAL parent AS QtWidget) AS QTimer
    DIM t AS QTimer
    t.handle = eb_qt6_timer_create(parent.handle)
    NewQTimer = t
END FUNCTION

SUB QTimerSetInterval(BYVAL t AS QTimer, milliseconds AS INTEGER)
    CALL eb_qt6_timer_set_interval(t.handle, milliseconds)
END SUB

''' If set, the timer fires `timeout` once, then stops - matching real
''' QTimer::setSingleShot semantics.
SUB QTimerSetSingleShot(BYVAL t AS QTimer, singleShot AS INTEGER)
    CALL eb_qt6_timer_set_single_shot(t.handle, singleShot)
END SUB

''' Starts (or restarts) the timer using its currently-set interval.
SUB QTimerStart(BYVAL t AS QTimer)
    CALL eb_qt6_timer_start(t.handle)
END SUB

SUB QTimerStop(BYVAL t AS QTimer)
    CALL eb_qt6_timer_stop(t.handle)
END SUB

FUNCTION QTimerIsActive(BYVAL t AS QTimer) AS INTEGER
    QTimerIsActive = eb_qt6_timer_is_active(t.handle)
END FUNCTION

''' Connects `handler` (a top-level `SUB YourName(userData AS ANY
''' PTR)`) to the timer's `timeout` signal.
SUB QTimerConnectTimeout(BYVAL t AS QTimer, handler AS ANY PTR, userData AS ANY PTR)
    CALL eb_qt6_timer_connect_timeout(t.handle, handler, userData)
END SUB
