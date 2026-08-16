' Raw FFI layer: QActionGroup (`ebqt6shim`).

#include once "qt6_common.bas"

Extern "C" Lib "ebqt6shim"
    Declare Function eb_qt6_actiongroup_create(ByVal parent AS ANY PTR) AS ANY PTR
    Declare Sub eb_qt6_actiongroup_add_action(ByVal group AS ANY PTR, ByVal action AS ANY PTR)
    Declare Sub eb_qt6_actiongroup_connect_triggered(ByVal group AS ANY PTR, ByVal cb AS ANY PTR, ByVal userData AS ANY PTR)
End Extern
