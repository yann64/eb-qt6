' Raw FFI layer: QScrollArea (`ebqt6shim`).

Extern "C" Lib "ebqt6shim"
    Declare Function eb_qt6_scrollarea_create() AS ANY PTR
    Declare Sub eb_qt6_scrollarea_set_widget(ByVal scrollArea AS ANY PTR, ByVal widget AS ANY PTR)
    Declare Sub eb_qt6_scrollarea_set_widget_resizable(ByVal scrollArea AS ANY PTR, ByVal resizable AS INTEGER)
    Declare Sub eb_qt6_scrollarea_set_horizontal_scrollbar_policy(ByVal scrollArea AS ANY PTR, ByVal policy AS INTEGER)
    Declare Sub eb_qt6_scrollarea_set_vertical_scrollbar_policy(ByVal scrollArea AS ANY PTR, ByVal policy AS INTEGER)
End Extern
