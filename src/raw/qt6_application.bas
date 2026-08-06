' Raw FFI layer: QApplication lifecycle (`ebqt6shim`).

Extern "C" Lib "ebqt6shim"
    Declare Function eb_qt6_application_create(ByVal appName AS ZSTRING) AS ANY PTR
    Declare Function eb_qt6_application_exec(ByVal app AS ANY PTR) AS INTEGER
    Declare Sub eb_qt6_application_quit(ByVal app AS ANY PTR)
End Extern
