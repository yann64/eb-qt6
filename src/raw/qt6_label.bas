' Raw FFI layer: QLabel (`ebqt6shim`).

#include once "qt6_common.bas"

Extern "C" Lib "ebqt6shim"
    Declare Function eb_qt6_label_create(ByVal text AS ZSTRING) AS ANY PTR
    Declare Sub eb_qt6_label_set_text(ByVal label AS ANY PTR, ByVal text AS ZSTRING)
    Declare Function eb_qt6_label_get_text(ByVal label AS ANY PTR) AS ANY PTR
End Extern
