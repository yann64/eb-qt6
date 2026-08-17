// eb-qt6 native shim - QNetworkAccessManager/QNetworkReply, a simple
// HTTP GET only (no POST/headers/auth yet - a real future extension
// point, not attempted here to keep this phase's scope bounded).
//
// Like QProcess (shim_process.h), this needs no GUI/keyboard/mouse
// interaction to verify at all - issue a real HTTP GET, wait for it,
// check the status code/body. eb_qt6_network_reply_wait_for_finished
// spins a local QEventLoop until the reply's own `finished` signal
// fires (the standard Qt idiom for a "synchronous-looking" async
// request) so callers don't need to wire up a callback just to block.
#pragma once

#include "shim_common.h"

extern "C" {

// `parent` may be a null ANY PTR, but passing a real parent widget is
// strongly recommended - see shim_timer.h's own top comment on this
// package's standard plain-QObject-needs-a-real-parent convention.
void* eb_qt6_network_manager_create(void* parent);
// Starts an async GET request immediately; returns the QNetworkReply*
// handle. The manager itself owns nothing further here - the caller
// owns the returned reply and must eventually call
// eb_qt6_network_reply_delete_later on it (real Qt convention: never
// delete a QNetworkReply directly from inside its own `finished`
// handler, use deleteLater the same way eb_qt6_widget_destroy already
// does for QWidget).
void* eb_qt6_network_get(void* manager, const char* url);
// Blocks until the reply finishes or `timeoutMs` elapses (pass -1 to
// wait indefinitely, matching eb_qt6_process_wait_for_finished's own
// convention). Returns non-zero if the reply finished within the
// timeout.
int eb_qt6_network_reply_wait_for_finished(void* reply, int timeoutMs);
// Fires once the reply finishes, success or error alike - real
// QNetworkReply::finished.
void eb_qt6_network_reply_connect_finished(void* reply, EbQt6VoidCallback cb, void* userData);
// Non-zero if the request failed (network error, non-2xx is NOT
// itself an error here - check eb_qt6_network_reply_status_code for
// that) - real QNetworkReply::error() != QNetworkReply::NoError.
int eb_qt6_network_reply_has_error(void* reply);
// Caller frees the result via eb_qt6_free_string.
char* eb_qt6_network_reply_error_string(void* reply);
// The real HTTP status code (200, 404, ...), or 0 if unavailable (a
// pure network-level failure before any response was received).
int eb_qt6_network_reply_status_code(void* reply);
// The full response body as UTF-8 text. Caller frees the result via
// eb_qt6_free_string. Not meaningful for binary responses (images,
// etc.) - text/JSON/HTML only, matching this phase's bounded scope.
char* eb_qt6_network_reply_read_all(void* reply);
void eb_qt6_network_reply_delete_later(void* reply);

}
