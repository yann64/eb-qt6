' Raw FFI layer: ShimWidget - the one custom-paint widget in this
' package (`ebqt6shim`).

Extern "C" Lib "ebqt6shim"
    Declare Function eb_qt6_painterwidget_create() AS ANY PTR
    Declare Sub eb_qt6_painterwidget_set_paint_callback(ByVal widget AS ANY PTR, ByVal cb AS ANY PTR, ByVal userData AS ANY PTR)
End Extern
