' Raw FFI layer: QGroupBox (`ebqt6shim`).

#include once "qt6_common.bas"

Extern "C" Lib "ebqt6shim"
    Declare Function eb_qt6_groupbox_create(ByVal title AS ZSTRING) AS ANY PTR
    Declare Sub eb_qt6_groupbox_set_checkable(ByVal groupBox AS ANY PTR, ByVal checkable AS INTEGER)
    Declare Function eb_qt6_groupbox_is_checked(ByVal groupBox AS ANY PTR) AS INTEGER
    Declare Sub eb_qt6_groupbox_set_checked(ByVal groupBox AS ANY PTR, ByVal checked AS INTEGER)
    Declare Sub eb_qt6_groupbox_connect_toggled(ByVal groupBox AS ANY PTR, ByVal cb AS ANY PTR, ByVal userData AS ANY PTR)
End Extern
