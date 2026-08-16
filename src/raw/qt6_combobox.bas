' Raw FFI layer: QComboBox (`ebqt6shim`).

#include once "qt6_common.bas"

Extern "C" Lib "ebqt6shim"
    Declare Function eb_qt6_combobox_create() AS ANY PTR
    Declare Sub eb_qt6_combobox_add_item(ByVal combo AS ANY PTR, ByVal text AS ZSTRING)
    Declare Sub eb_qt6_combobox_add_item_with_icon_from_theme(ByVal combo AS ANY PTR, ByVal text AS ZSTRING, ByVal themeIconName AS ZSTRING)
    Declare Function eb_qt6_combobox_current_text(ByVal combo AS ANY PTR) AS ANY PTR
    Declare Function eb_qt6_combobox_current_index(ByVal combo AS ANY PTR) AS INTEGER
    Declare Sub eb_qt6_combobox_set_current_index(ByVal combo AS ANY PTR, ByVal index AS INTEGER)
    Declare Sub eb_qt6_combobox_connect_current_index_changed(ByVal combo AS ANY PTR, ByVal cb AS ANY PTR, ByVal userData AS ANY PTR)
End Extern
