' Raw FFI layer: QStatusBar (`ebqt6shim`).

Extern "C" Lib "ebqt6shim"
    Declare Function eb_qt6_mainwindow_status_bar(ByVal window AS ANY PTR) AS ANY PTR
    Declare Sub eb_qt6_statusbar_show_message(ByVal statusBar AS ANY PTR, ByVal text AS ZSTRING, ByVal timeout AS INTEGER)
End Extern
