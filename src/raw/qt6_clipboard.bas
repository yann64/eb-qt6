' Raw FFI layer: QClipboard (`ebqt6shim`).

Extern "C" Lib "ebqt6shim"
    Declare Function eb_qt6_application_clipboard(ByVal app AS ANY PTR) AS ANY PTR
    Declare Sub eb_qt6_clipboard_set_text(ByVal clipboard AS ANY PTR, ByVal text AS ZSTRING)
    Declare Function eb_qt6_clipboard_get_text(ByVal clipboard AS ANY PTR) AS ANY PTR
    Declare Sub eb_qt6_clipboard_set_pixmap(ByVal clipboard AS ANY PTR, ByVal pixmap AS ANY PTR)
    Declare Function eb_qt6_clipboard_get_pixmap(ByVal clipboard AS ANY PTR) AS ANY PTR
End Extern
