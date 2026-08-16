' Raw FFI layer: QCheckBox/QRadioButton (`ebqt6shim`) - both real
' QAbstractButton subclasses, sharing the exact same function family.

Extern "C" Lib "ebqt6shim"
    Declare Function eb_qt6_checkbox_create(ByVal text AS ZSTRING) AS ANY PTR
    Declare Function eb_qt6_radiobutton_create(ByVal text AS ZSTRING) AS ANY PTR
    Declare Sub eb_qt6_abstractbutton_set_checked(ByVal button AS ANY PTR, ByVal checked AS INTEGER)
    Declare Function eb_qt6_abstractbutton_is_checked(ByVal button AS ANY PTR) AS INTEGER
    Declare Sub eb_qt6_abstractbutton_connect_toggled(ByVal button AS ANY PTR, ByVal cb AS ANY PTR, ByVal userData AS ANY PTR)
    Declare Function eb_qt6_abstractbutton_get_text(ByVal button AS ANY PTR) AS ANY PTR
End Extern
