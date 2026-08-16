' Raw FFI layer: icons for buttons/actions/windows (`ebqt6shim`).

Extern "C" Lib "ebqt6shim"
    Declare Sub eb_qt6_button_set_icon_from_theme(ByVal button AS ANY PTR, ByVal themeIconName AS ZSTRING)
    Declare Sub eb_qt6_button_set_icon_from_file(ByVal button AS ANY PTR, ByVal path AS ZSTRING)

    Declare Sub eb_qt6_action_set_icon_from_theme(ByVal action AS ANY PTR, ByVal themeIconName AS ZSTRING)
    Declare Sub eb_qt6_action_set_icon_from_file(ByVal action AS ANY PTR, ByVal path AS ZSTRING)

    Declare Sub eb_qt6_widget_set_window_icon_from_theme(ByVal widget AS ANY PTR, ByVal themeIconName AS ZSTRING)
    Declare Sub eb_qt6_widget_set_window_icon_from_file(ByVal widget AS ANY PTR, ByVal path AS ZSTRING)
End Extern
