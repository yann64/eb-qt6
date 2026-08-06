' Raw FFI layer: QDockWidget (`ebqt6shim`).

Extern "C" Lib "ebqt6shim"
    Declare Function eb_qt6_dockwidget_create(ByVal title AS ZSTRING) AS ANY PTR
    Declare Sub eb_qt6_dockwidget_set_widget(ByVal dockWidget AS ANY PTR, ByVal widget AS ANY PTR)
    Declare Sub eb_qt6_mainwindow_add_dock_widget(ByVal window AS ANY PTR, ByVal area AS INTEGER, ByVal dockWidget AS ANY PTR)
End Extern
