' Raw FFI layer: QToolTip, shown programmatically (`ebqt6shim`).

Extern "C" Lib "ebqt6shim"
    Declare Sub eb_qt6_tooltip_show_text(ByVal x AS INTEGER, ByVal y AS INTEGER, ByVal text AS ZSTRING)
    Declare Sub eb_qt6_tooltip_hide()
End Extern
