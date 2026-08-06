' Raw FFI layer: QLCDNumber (`ebqt6shim`).

Extern "C" Lib "ebqt6shim"
    Declare Function eb_qt6_lcdnumber_create() AS ANY PTR
    Declare Sub eb_qt6_lcdnumber_display(ByVal lcd AS ANY PTR, ByVal value AS INTEGER)
End Extern
