' Raw FFI layer: QProgressBar (`ebqt6shim`).

Extern "C" Lib "ebqt6shim"
    Declare Function eb_qt6_progressbar_create() AS ANY PTR
    Declare Sub eb_qt6_progressbar_set_range(ByVal bar AS ANY PTR, ByVal min AS INTEGER, ByVal max AS INTEGER)
    Declare Function eb_qt6_progressbar_value(ByVal bar AS ANY PTR) AS INTEGER
    Declare Sub eb_qt6_progressbar_set_value(ByVal bar AS ANY PTR, ByVal value AS INTEGER)
End Extern
