' Raw FFI layer: QTableWidget (`ebqt6shim`).

#include once "qt6_common.bas"

Extern "C" Lib "ebqt6shim"
    Declare Function eb_qt6_tablewidget_create() AS ANY PTR
    Declare Sub eb_qt6_tablewidget_set_row_count(ByVal table AS ANY PTR, ByVal rows AS INTEGER)
    Declare Sub eb_qt6_tablewidget_set_column_count(ByVal table AS ANY PTR, ByVal cols AS INTEGER)
    Declare Sub eb_qt6_tablewidget_set_item_text(ByVal table AS ANY PTR, ByVal row AS INTEGER, ByVal col AS INTEGER, ByVal text AS ZSTRING)
    Declare Function eb_qt6_tablewidget_item_text(ByVal table AS ANY PTR, ByVal row AS INTEGER, ByVal col AS INTEGER) AS ANY PTR
    Declare Sub eb_qt6_tablewidget_connect_cell_clicked(ByVal table AS ANY PTR, ByVal cb AS ANY PTR, ByVal userData AS ANY PTR)
End Extern
