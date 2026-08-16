' Raw FFI layer: QFormLayout (`ebqt6shim`).

Extern "C" Lib "ebqt6shim"
    Declare Function eb_qt6_formlayout_create() AS ANY PTR
    Declare Sub eb_qt6_formlayout_add_row(ByVal layout AS ANY PTR, ByVal labelText AS ZSTRING, ByVal widget AS ANY PTR)
End Extern
