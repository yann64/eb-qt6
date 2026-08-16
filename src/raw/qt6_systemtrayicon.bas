' Raw FFI layer: QSystemTrayIcon (`ebqt6shim`).

#include once "qt6_common.bas"

Extern "C" Lib "ebqt6shim"
    Declare Function eb_qt6_systemtrayicon_create() AS ANY PTR
    Declare Sub eb_qt6_systemtrayicon_set_icon_from_theme(ByVal tray AS ANY PTR, ByVal themeIconName AS ZSTRING)
    Declare Sub eb_qt6_systemtrayicon_set_tooltip(ByVal tray AS ANY PTR, ByVal text AS ZSTRING)
    Declare Sub eb_qt6_systemtrayicon_set_context_menu(ByVal tray AS ANY PTR, ByVal menu AS ANY PTR)
    Declare Sub eb_qt6_systemtrayicon_show(ByVal tray AS ANY PTR)
    Declare Sub eb_qt6_systemtrayicon_hide(ByVal tray AS ANY PTR)
    Declare Sub eb_qt6_systemtrayicon_connect_activated(ByVal tray AS ANY PTR, ByVal cb AS ANY PTR, ByVal userData AS ANY PTR)
End Extern
