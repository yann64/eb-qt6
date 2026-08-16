' Raw FFI layer: drag-and-drop (`ebqt6shim`).

#include once "qt6_common.bas"

Extern "C" Lib "ebqt6shim"
    Declare Sub eb_qt6_widget_enable_drag_source(ByVal widget AS ANY PTR, ByVal dragText AS ZSTRING)
    Declare Sub eb_qt6_widget_enable_drop_target(ByVal widget AS ANY PTR, ByVal cb AS ANY PTR, ByVal userData AS ANY PTR)
End Extern
