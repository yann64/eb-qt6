' Raw FFI layer: QLineEdit (`ebqt6shim`).

#include once "qt6_common.bas"

Extern "C" Lib "ebqt6shim"
    Declare Function eb_qt6_lineedit_create(ByVal text AS ZSTRING) AS ANY PTR
    Declare Sub eb_qt6_lineedit_set_text(ByVal lineEdit AS ANY PTR, ByVal text AS ZSTRING)
    Declare Function eb_qt6_lineedit_get_text(ByVal lineEdit AS ANY PTR) AS ANY PTR
    Declare Sub eb_qt6_lineedit_connect_return_pressed(ByVal lineEdit AS ANY PTR, ByVal cb AS ANY PTR, ByVal userData AS ANY PTR)
    Declare Sub eb_qt6_lineedit_connect_text_changed(ByVal lineEdit AS ANY PTR, ByVal cb AS ANY PTR, ByVal userData AS ANY PTR)
End Extern
