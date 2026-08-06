' Raw FFI layer: QColorDialog (`ebqt6shim`).

Extern "C" Lib "ebqt6shim"
    Declare Function eb_qt6_colordialog_get_color(ByVal parent AS ANY PTR, ByVal title AS ZSTRING, ByVal initR AS UBYTE, ByVal initG AS UBYTE, ByVal initB AS UBYTE, ByVal outR AS ANY PTR, ByVal outG AS ANY PTR, ByVal outB AS ANY PTR) AS INTEGER
End Extern
