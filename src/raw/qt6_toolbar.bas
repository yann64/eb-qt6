' Raw FFI layer: QToolBar (`ebqt6shim`).

Extern "C" Lib "ebqt6shim"
    Declare Function eb_qt6_mainwindow_add_toolbar(ByVal window AS ANY PTR, ByVal title AS ZSTRING) AS ANY PTR
    Declare Function eb_qt6_toolbar_add_action(ByVal toolBar AS ANY PTR, ByVal text AS ZSTRING) AS ANY PTR
End Extern
