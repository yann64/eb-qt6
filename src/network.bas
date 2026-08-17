' Idiomatic layer: QNetworkAccessManager/QNetworkReply, a simple HTTP
' GET only (no POST/headers/auth - a real future extension point, not
' attempted here to keep this phase's scope bounded).
'
' Like QProcess (process.bas), this needs no GUI/keyboard/mouse
' interaction to verify at all - issue a real HTTP GET, wait for it,
' check the status code/body.

#include once "widget.bas"
#include once "common.bas"
#include once "raw/qt6_network.bas"

TYPE NetworkManager EXTENDS QtObject
END TYPE

''' `parent` - pass a real parent widget so Qt manages the manager's
''' lifetime automatically, same convention as NewQTimer/NewProcess.
FUNCTION NewNetworkManager(BYVAL parent AS QtWidget) AS NetworkManager
    DIM m AS NetworkManager
    m.handle = eb_qt6_network_manager_create(parent.handle)
    NewNetworkManager = m
END FUNCTION

''' A real QNetworkReply - the caller owns it and must eventually call
''' NetworkReplyDeleteLater on it (real Qt convention: never delete a
''' QNetworkReply directly from inside its own `finished` handler).
TYPE NetworkReply EXTENDS QtObject
END TYPE

''' Starts an async GET request immediately.
FUNCTION NetworkManagerGet(BYVAL m AS NetworkManager, url AS ZSTRING) AS NetworkReply
    DIM r AS NetworkReply
    r.handle = eb_qt6_network_get(m.handle, url)
    NetworkManagerGet = r
END FUNCTION

''' Blocks until the reply finishes or `timeoutMs` elapses (pass -1 to
''' wait indefinitely). Returns non-zero if the reply finished within
''' the timeout.
FUNCTION NetworkReplyWaitForFinished(BYVAL r AS NetworkReply, timeoutMs AS INTEGER) AS INTEGER
    NetworkReplyWaitForFinished = eb_qt6_network_reply_wait_for_finished(r.handle, timeoutMs)
END FUNCTION

''' Connects `handler` (a top-level `SUB YourName(userData AS ANY
''' PTR)`) to the reply's `finished` signal - fires once, success or
''' error alike.
SUB NetworkReplyConnectFinished(BYVAL r AS NetworkReply, handler AS ANY PTR, userData AS ANY PTR)
    CALL eb_qt6_network_reply_connect_finished(r.handle, handler, userData)
END SUB

''' Non-zero if the request failed at the network level (a non-2xx HTTP
''' status is NOT itself an error here - check NetworkReplyStatusCode
''' for that).
FUNCTION NetworkReplyHasError(BYVAL r AS NetworkReply) AS INTEGER
    NetworkReplyHasError = eb_qt6_network_reply_has_error(r.handle)
END FUNCTION

''' See ButtonGetText's own doc comment on the owned-allocation/
''' FreeQtString convention.
FUNCTION NetworkReplyErrorString(BYVAL r AS NetworkReply) AS ANY PTR
    NetworkReplyErrorString = eb_qt6_network_reply_error_string(r.handle)
END FUNCTION

''' The real HTTP status code (200, 404, ...), or 0 if unavailable (a
''' pure network-level failure before any response was received).
FUNCTION NetworkReplyStatusCode(BYVAL r AS NetworkReply) AS INTEGER
    NetworkReplyStatusCode = eb_qt6_network_reply_status_code(r.handle)
END FUNCTION

''' The full response body as UTF-8 text - not meaningful for binary
''' responses (images, etc.). See ButtonGetText's own doc comment on
''' the owned-allocation/FreeQtString convention.
FUNCTION NetworkReplyReadAll(BYVAL r AS NetworkReply) AS ANY PTR
    NetworkReplyReadAll = eb_qt6_network_reply_read_all(r.handle)
END FUNCTION

SUB NetworkReplyDeleteLater(BYVAL r AS NetworkReply)
    CALL eb_qt6_network_reply_delete_later(r.handle)
END SUB
