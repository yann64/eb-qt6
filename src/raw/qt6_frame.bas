' Raw FFI layer: QFrame (`ebqt6shim`).

Extern "C" Lib "ebqt6shim"
    Declare Function eb_qt6_frame_create() AS ANY PTR
    Declare Sub eb_qt6_frame_set_frame_style(ByVal frame AS ANY PTR, ByVal shape AS INTEGER, ByVal shadow AS INTEGER)
End Extern
