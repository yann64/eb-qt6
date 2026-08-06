' Raw FFI layer: QPushButton (`ebqt6shim`).

#include once "qt6_common.bas"

Extern "C" Lib "ebqt6shim"
    Declare Function eb_qt6_button_create(ByVal label AS ZSTRING) AS ANY PTR
    Declare Sub eb_qt6_button_set_text(ByVal button AS ANY PTR, ByVal label AS ZSTRING)
    Declare Function eb_qt6_button_get_text(ByVal button AS ANY PTR) AS ANY PTR
    Declare Sub eb_qt6_button_connect_clicked(ByVal button AS ANY PTR, ByVal cb AS ANY PTR, ByVal userData AS ANY PTR)
End Extern
