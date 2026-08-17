// eb-qt6 native shim - QProcess. A plain QObject, like QTimer/
// QButtonGroup (see shim_timer.h's own top comment) - needs a real
// parent at construction so Qt manages its lifetime, or it would leak
// silently if never parented.
//
// Unlike every other feature in this package so far, QProcess needs no
// GUI/keyboard/mouse interaction to verify at all - run a real command,
// wait for it to finish, and check its exit code/output. The most
// reliably testable feature in this package's whole history.
#pragma once

#include "shim_common.h"

extern "C" {

// `parent` may be a null ANY PTR, but passing a real parent widget is
// strongly recommended - see this file's own top comment.
void* eb_qt6_process_create(void* parent);
// Splits `command` the same way a shell would (quoting-aware) and
// starts it - real QProcess::startCommand, not a raw exec of a single
// program with no argument parsing.
void eb_qt6_process_start(void* process, const char* command);
// Blocks until the process finishes or `timeoutMs` elapses (pass -1 to
// wait indefinitely, matching real QProcess::waitForFinished's own
// convention). Returns non-zero if the process finished within the
// timeout, zero if it timed out or was never started.
int eb_qt6_process_wait_for_finished(void* process, int timeoutMs);
int eb_qt6_process_exit_code(void* process);
// Caller frees the result via eb_qt6_free_string.
char* eb_qt6_process_read_all_standard_output(void* process);
char* eb_qt6_process_read_all_standard_error(void* process);
// QProcess::finished(int exitCode, QProcess::ExitStatus exitStatus) -
// exitStatus is 0=NormalExit, 1=CrashExit, matching the real enum.
void eb_qt6_process_connect_finished(void* process, EbQt6TwoIntCallback cb, void* userData);

}
