' Raw FFI layer: QTimer (`ebqt6shim`).

#include once "qt6_common.bas"

Extern "C" Lib "ebqt6shim"
    Declare Function eb_qt6_timer_create(ByVal parent AS ANY PTR) AS ANY PTR
    Declare Sub eb_qt6_timer_set_interval(ByVal timer AS ANY PTR, ByVal milliseconds AS INTEGER)
    Declare Sub eb_qt6_timer_set_single_shot(ByVal timer AS ANY PTR, ByVal singleShot AS INTEGER)
    Declare Sub eb_qt6_timer_start(ByVal timer AS ANY PTR)
    Declare Sub eb_qt6_timer_stop(ByVal timer AS ANY PTR)
    Declare Function eb_qt6_timer_is_active(ByVal timer AS ANY PTR) AS INTEGER
    Declare Sub eb_qt6_timer_connect_timeout(ByVal timer AS ANY PTR, ByVal cb AS ANY PTR, ByVal userData AS ANY PTR)
End Extern
