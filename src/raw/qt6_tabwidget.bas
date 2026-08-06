' Raw FFI layer: QTabWidget (`ebqt6shim`).

#include once "qt6_common.bas"

Extern "C" Lib "ebqt6shim"
    Declare Function eb_qt6_tabwidget_create() AS ANY PTR
    Declare Function eb_qt6_tabwidget_add_tab(ByVal tabWidget AS ANY PTR, ByVal page AS ANY PTR, ByVal title AS ZSTRING) AS INTEGER
    Declare Function eb_qt6_tabwidget_current_index(ByVal tabWidget AS ANY PTR) AS INTEGER
    Declare Sub eb_qt6_tabwidget_set_current_index(ByVal tabWidget AS ANY PTR, ByVal index AS INTEGER)
    Declare Sub eb_qt6_tabwidget_connect_current_changed(ByVal tabWidget AS ANY PTR, ByVal cb AS ANY PTR, ByVal userData AS ANY PTR)
End Extern
