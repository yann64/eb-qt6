' Raw FFI layer: QSlider (`ebqt6shim`).

#include once "qt6_common.bas"

Extern "C" Lib "ebqt6shim"
    Declare Function eb_qt6_slider_create(ByVal orientation AS INTEGER) AS ANY PTR
    Declare Sub eb_qt6_slider_set_range(ByVal slider AS ANY PTR, ByVal min AS INTEGER, ByVal max AS INTEGER)
    Declare Function eb_qt6_slider_value(ByVal slider AS ANY PTR) AS INTEGER
    Declare Sub eb_qt6_slider_set_value(ByVal slider AS ANY PTR, ByVal value AS INTEGER)
    Declare Sub eb_qt6_slider_connect_value_changed(ByVal slider AS ANY PTR, ByVal cb AS ANY PTR, ByVal userData AS ANY PTR)
End Extern
