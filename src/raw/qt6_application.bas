' Raw FFI layer: QApplication lifecycle (`ebqt6shim`).

Extern "C" Lib "ebqt6shim"
    Declare Function eb_qt6_application_create(ByVal appName AS ZSTRING) AS ANY PTR
    Declare Function eb_qt6_application_exec(ByVal app AS ANY PTR) AS INTEGER
    Declare Sub eb_qt6_application_quit(ByVal app AS ANY PTR)
    Declare Function eb_qt6_primary_screen_width() AS INTEGER
    Declare Function eb_qt6_primary_screen_height() AS INTEGER
    Declare Sub eb_qt6_application_set_quit_on_last_window_closed(ByVal app AS ANY PTR, ByVal quit AS INTEGER)
    Declare Sub eb_qt6_application_connect_about_to_quit(ByVal app AS ANY PTR, ByVal cb AS ANY PTR, ByVal userData AS ANY PTR)
End Extern
