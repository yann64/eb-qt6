' Raw FFI layer: QFontDialog (`ebqt6shim`).

#include once "qt6_common.bas"

Extern "C" Lib "ebqt6shim"
    Declare Function eb_qt6_fontdialog_get_font(ByVal parent AS ANY PTR, ByVal outPointSize AS ANY PTR, ByVal outValid AS ANY PTR) AS ANY PTR
End Extern
