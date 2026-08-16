' Raw FFI layer: QGridLayout (`ebqt6shim`).

Extern "C" Lib "ebqt6shim"
    Declare Function eb_qt6_gridlayout_create() AS ANY PTR
    Declare Sub eb_qt6_gridlayout_add_widget(ByVal layout AS ANY PTR, ByVal widget AS ANY PTR, ByVal row AS INTEGER, ByVal col AS INTEGER, ByVal rowSpan AS INTEGER, ByVal colSpan AS INTEGER)
End Extern
