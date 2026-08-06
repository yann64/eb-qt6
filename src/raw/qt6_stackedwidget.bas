' Raw FFI layer: QStackedWidget (`ebqt6shim`).

#include once "qt6_common.bas"

Extern "C" Lib "ebqt6shim"
    Declare Function eb_qt6_stackedwidget_create() AS ANY PTR
    Declare Function eb_qt6_stackedwidget_add_widget(ByVal stack AS ANY PTR, ByVal page AS ANY PTR) AS INTEGER
    Declare Function eb_qt6_stackedwidget_current_index(ByVal stack AS ANY PTR) AS INTEGER
    Declare Sub eb_qt6_stackedwidget_set_current_index(ByVal stack AS ANY PTR, ByVal index AS INTEGER)
    Declare Sub eb_qt6_stackedwidget_connect_current_changed(ByVal stack AS ANY PTR, ByVal cb AS ANY PTR, ByVal userData AS ANY PTR)
End Extern
