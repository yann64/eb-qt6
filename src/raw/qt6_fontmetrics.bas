' Raw FFI layer: QFontMetrics, stateless text-measurement queries
' (`ebqt6shim`).

Extern "C" Lib "ebqt6shim"
    Declare Function eb_qt6_font_metrics_text_width(ByVal family AS ZSTRING, ByVal pointSize AS INTEGER, ByVal bold AS INTEGER, ByVal italic AS INTEGER, ByVal text AS ZSTRING) AS INTEGER
    Declare Function eb_qt6_font_metrics_height(ByVal family AS ZSTRING, ByVal pointSize AS INTEGER, ByVal bold AS INTEGER, ByVal italic AS INTEGER) AS INTEGER
End Extern
