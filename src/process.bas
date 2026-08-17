' Idiomatic layer: QProcess. A plain QObject, like QTimer (timer.bas) -
' needs a real parent widget at construction so Qt manages its lifetime
' automatically, or it would leak silently if never parented.
'
' Unlike every other feature in this package, QProcess needs no GUI/
' keyboard/mouse interaction to verify at all - run a real command, wait
' for it to finish, and check its exit code/output. The most reliably
' testable feature in this package's whole history.

#include once "widget.bas"
#include once "raw/qt6_process.bas"

TYPE Process EXTENDS QtObject
END TYPE

''' `parent` - pass a real parent widget so Qt manages the process
''' object's lifetime automatically, same convention as NewQTimer.
FUNCTION NewProcess(BYVAL parent AS QtWidget) AS Process
    DIM p AS Process
    p.handle = eb_qt6_process_create(parent.handle)
    NewProcess = p
END FUNCTION

''' Splits `command` the same way a shell would (quoting-aware) and
''' starts it - not a raw exec of a single program with no argument
''' parsing.
SUB ProcessStart(BYVAL p AS Process, command AS ZSTRING)
    CALL eb_qt6_process_start(p.handle, command)
END SUB

''' Blocks until the process finishes or `timeoutMs` elapses (pass -1
''' to wait indefinitely). Returns non-zero if the process finished
''' within the timeout, zero if it timed out or was never started.
FUNCTION ProcessWaitForFinished(BYVAL p AS Process, timeoutMs AS INTEGER) AS INTEGER
    ProcessWaitForFinished = eb_qt6_process_wait_for_finished(p.handle, timeoutMs)
END FUNCTION

FUNCTION ProcessExitCode(BYVAL p AS Process) AS INTEGER
    ProcessExitCode = eb_qt6_process_exit_code(p.handle)
END FUNCTION

''' See ButtonGetText's own doc comment on the owned-allocation/
''' FreeQtString convention.
FUNCTION ProcessReadAllStandardOutput(BYVAL p AS Process) AS ANY PTR
    ProcessReadAllStandardOutput = eb_qt6_process_read_all_standard_output(p.handle)
END FUNCTION

FUNCTION ProcessReadAllStandardError(BYVAL p AS Process) AS ANY PTR
    ProcessReadAllStandardError = eb_qt6_process_read_all_standard_error(p.handle)
END FUNCTION

CONST QtProcessNormalExit = 0
CONST QtProcessCrashExit = 1

''' Connects `handler` (a top-level `SUB YourName(userData AS ANY PTR,
''' exitCode AS INTEGER, exitStatus AS INTEGER)`) to the process's
''' `finished` signal - `exitStatus` is one of the QtProcessXxxExit
''' constants above.
SUB ProcessConnectFinished(BYVAL p AS Process, handler AS ANY PTR, userData AS ANY PTR)
    CALL eb_qt6_process_connect_finished(p.handle, handler, userData)
END SUB
