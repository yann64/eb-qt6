' Raw FFI layer: QProcess (`ebqt6shim`).

#include once "qt6_common.bas"

Extern "C" Lib "ebqt6shim"
    Declare Function eb_qt6_process_create(ByVal parent AS ANY PTR) AS ANY PTR
    Declare Sub eb_qt6_process_start(ByVal process AS ANY PTR, ByVal command AS ZSTRING)
    Declare Function eb_qt6_process_wait_for_finished(ByVal process AS ANY PTR, ByVal timeoutMs AS INTEGER) AS INTEGER
    Declare Function eb_qt6_process_exit_code(ByVal process AS ANY PTR) AS INTEGER
    Declare Function eb_qt6_process_read_all_standard_output(ByVal process AS ANY PTR) AS ANY PTR
    Declare Function eb_qt6_process_read_all_standard_error(ByVal process AS ANY PTR) AS ANY PTR
    Declare Sub eb_qt6_process_connect_finished(ByVal process AS ANY PTR, ByVal cb AS ANY PTR, ByVal userData AS ANY PTR)
End Extern
