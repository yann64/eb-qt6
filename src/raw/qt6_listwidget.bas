' Raw FFI layer: QListWidget (`ebqt6shim`).

#include once "qt6_common.bas"

Extern "C" Lib "ebqt6shim"
    Declare Function eb_qt6_listwidget_create() AS ANY PTR
    Declare Sub eb_qt6_listwidget_add_item(ByVal list AS ANY PTR, ByVal text AS ZSTRING)
    Declare Function eb_qt6_listwidget_current_row(ByVal list AS ANY PTR) AS INTEGER
    Declare Sub eb_qt6_listwidget_set_current_row(ByVal list AS ANY PTR, ByVal row AS INTEGER)
    Declare Function eb_qt6_listwidget_current_text(ByVal list AS ANY PTR) AS ANY PTR
    Declare Sub eb_qt6_listwidget_connect_current_row_changed(ByVal list AS ANY PTR, ByVal cb AS ANY PTR, ByVal userData AS ANY PTR)
End Extern
