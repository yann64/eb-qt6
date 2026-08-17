' Raw FFI layer: QLineEdit (`ebqt6shim`).

#include once "qt6_common.bas"

Extern "C" Lib "ebqt6shim"
    Declare Function eb_qt6_lineedit_create(ByVal text AS ZSTRING) AS ANY PTR
    Declare Sub eb_qt6_lineedit_set_text(ByVal lineEdit AS ANY PTR, ByVal text AS ZSTRING)
    Declare Function eb_qt6_lineedit_get_text(ByVal lineEdit AS ANY PTR) AS ANY PTR
    Declare Sub eb_qt6_lineedit_connect_return_pressed(ByVal lineEdit AS ANY PTR, ByVal cb AS ANY PTR, ByVal userData AS ANY PTR)
    Declare Sub eb_qt6_lineedit_connect_text_changed(ByVal lineEdit AS ANY PTR, ByVal cb AS ANY PTR, ByVal userData AS ANY PTR)
    Declare Sub eb_qt6_lineedit_set_int_validator(ByVal lineEdit AS ANY PTR, ByVal bottom AS INTEGER, ByVal top AS INTEGER)
    Declare Sub eb_qt6_lineedit_set_double_validator(ByVal lineEdit AS ANY PTR, ByVal bottom AS DOUBLE, ByVal top AS DOUBLE, ByVal decimals AS INTEGER)
    Declare Sub eb_qt6_lineedit_set_echo_mode(ByVal lineEdit AS ANY PTR, ByVal mode AS INTEGER)
    Declare Sub eb_qt6_lineedit_set_regex_validator(ByVal lineEdit AS ANY PTR, ByVal pattern AS ZSTRING)
    Declare Sub eb_qt6_lineedit_set_placeholder_text(ByVal lineEdit AS ANY PTR, ByVal text AS ZSTRING)
    Declare Sub eb_qt6_lineedit_set_max_length(ByVal lineEdit AS ANY PTR, ByVal maxLength AS INTEGER)
    Declare Sub eb_qt6_lineedit_select_all(ByVal lineEdit AS ANY PTR)
    Declare Sub eb_qt6_lineedit_clear(ByVal lineEdit AS ANY PTR)
End Extern
