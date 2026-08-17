' Raw FFI layer: QToolButton, standalone (`ebqt6shim`).

#include once "qt6_common.bas"

Extern "C" Lib "ebqt6shim"
    Declare Function eb_qt6_toolbutton_create() AS ANY PTR
    Declare Sub eb_qt6_toolbutton_set_text(ByVal button AS ANY PTR, ByVal text AS ZSTRING)
    Declare Sub eb_qt6_toolbutton_connect_clicked(ByVal button AS ANY PTR, ByVal cb AS ANY PTR, ByVal userData AS ANY PTR)
    Declare Sub eb_qt6_toolbutton_set_menu(ByVal button AS ANY PTR, ByVal menu AS ANY PTR)
    Declare Sub eb_qt6_toolbutton_set_popup_mode(ByVal button AS ANY PTR, ByVal mode AS INTEGER)
End Extern
