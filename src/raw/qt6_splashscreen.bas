' Raw FFI layer: QSplashScreen (`ebqt6shim`).

Extern "C" Lib "ebqt6shim"
    Declare Function eb_qt6_splashscreen_create_from_file(ByVal path AS ZSTRING) AS ANY PTR
    Declare Sub eb_qt6_splashscreen_show(ByVal splash AS ANY PTR)
    Declare Sub eb_qt6_splashscreen_finish(ByVal splash AS ANY PTR, ByVal mainWindow AS ANY PTR)
    Declare Sub eb_qt6_splashscreen_show_message(ByVal splash AS ANY PTR, ByVal message AS ZSTRING)
End Extern
