' Raw FFI layer: QSettings (`ebqt6shim`).

Extern "C" Lib "ebqt6shim"
    Declare Function eb_qt6_settings_create(ByVal organization AS ZSTRING, ByVal application AS ZSTRING, ByVal parent AS ANY PTR) AS ANY PTR
    Declare Sub eb_qt6_settings_set_string(ByVal settings AS ANY PTR, ByVal key AS ZSTRING, ByVal value AS ZSTRING)
    Declare Function eb_qt6_settings_get_string(ByVal settings AS ANY PTR, ByVal key AS ZSTRING, ByVal defaultValue AS ZSTRING) AS ANY PTR
    Declare Sub eb_qt6_settings_set_int(ByVal settings AS ANY PTR, ByVal key AS ZSTRING, ByVal value AS INTEGER)
    Declare Function eb_qt6_settings_get_int(ByVal settings AS ANY PTR, ByVal key AS ZSTRING, ByVal defaultValue AS INTEGER) AS INTEGER
    Declare Sub eb_qt6_settings_sync(ByVal settings AS ANY PTR)
End Extern
