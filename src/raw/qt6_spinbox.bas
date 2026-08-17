' Raw FFI layer: QSpinBox (`ebqt6shim`).

#include once "qt6_common.bas"

Extern "C" Lib "ebqt6shim"
    Declare Function eb_qt6_spinbox_create() AS ANY PTR
    Declare Sub eb_qt6_spinbox_set_range(ByVal spinBox AS ANY PTR, ByVal min AS INTEGER, ByVal max AS INTEGER)
    Declare Function eb_qt6_spinbox_value(ByVal spinBox AS ANY PTR) AS INTEGER
    Declare Sub eb_qt6_spinbox_set_value(ByVal spinBox AS ANY PTR, ByVal value AS INTEGER)
    Declare Sub eb_qt6_spinbox_connect_value_changed(ByVal spinBox AS ANY PTR, ByVal cb AS ANY PTR, ByVal userData AS ANY PTR)
    Declare Sub eb_qt6_spinbox_set_suffix(ByVal spinBox AS ANY PTR, ByVal suffix AS ZSTRING)
    Declare Sub eb_qt6_spinbox_set_prefix(ByVal spinBox AS ANY PTR, ByVal prefix AS ZSTRING)
    Declare Sub eb_qt6_spinbox_set_single_step(ByVal spinBox AS ANY PTR, ByVal stepAmount AS INTEGER)
End Extern
