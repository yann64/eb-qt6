' Raw FFI layer: QDial (`ebqt6shim`).

#include once "qt6_common.bas"

Extern "C" Lib "ebqt6shim"
    Declare Function eb_qt6_dial_create() AS ANY PTR
    Declare Sub eb_qt6_dial_set_range(ByVal dial AS ANY PTR, ByVal min AS INTEGER, ByVal max AS INTEGER)
    Declare Function eb_qt6_dial_value(ByVal dial AS ANY PTR) AS INTEGER
    Declare Sub eb_qt6_dial_set_value(ByVal dial AS ANY PTR, ByVal value AS INTEGER)
    Declare Sub eb_qt6_dial_connect_value_changed(ByVal dial AS ANY PTR, ByVal cb AS ANY PTR, ByVal userData AS ANY PTR)
End Extern
