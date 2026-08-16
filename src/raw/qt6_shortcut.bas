' Raw FFI layer: QShortcut (`ebqt6shim`).

#include once "qt6_common.bas"

Extern "C" Lib "ebqt6shim"
    Declare Function eb_qt6_shortcut_create(ByVal keySequence AS ZSTRING, ByVal parent AS ANY PTR) AS ANY PTR
    Declare Sub eb_qt6_shortcut_connect_activated(ByVal shortcut AS ANY PTR, ByVal cb AS ANY PTR, ByVal userData AS ANY PTR)
End Extern
