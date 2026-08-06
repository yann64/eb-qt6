' Raw FFI layer: QWidget/QMainWindow and the two stock box layouts
' (`ebqt6shim`).

Extern "C" Lib "ebqt6shim"
    Declare Function eb_qt6_widget_create() AS ANY PTR
    Declare Sub eb_qt6_widget_show(ByVal widget AS ANY PTR)
    Declare Sub eb_qt6_widget_resize(ByVal widget AS ANY PTR, ByVal width AS INTEGER, ByVal height AS INTEGER)
    Declare Sub eb_qt6_widget_set_window_title(ByVal widget AS ANY PTR, ByVal title AS ZSTRING)
    Declare Sub eb_qt6_widget_destroy(ByVal widget AS ANY PTR)

    Declare Function eb_qt6_mainwindow_create() AS ANY PTR
    Declare Sub eb_qt6_mainwindow_set_central_widget(ByVal window AS ANY PTR, ByVal widget AS ANY PTR)

    Declare Function eb_qt6_vboxlayout_create() AS ANY PTR
    Declare Function eb_qt6_hboxlayout_create() AS ANY PTR
    Declare Sub eb_qt6_boxlayout_add_widget(ByVal layout AS ANY PTR, ByVal widget AS ANY PTR)
    Declare Sub eb_qt6_widget_set_layout(ByVal widget AS ANY PTR, ByVal layout AS ANY PTR)
End Extern
