' Raw FFI layer: QNetworkAccessManager/QNetworkReply (`ebqt6shim`).

#include once "qt6_common.bas"

Extern "C" Lib "ebqt6shim"
    Declare Function eb_qt6_network_manager_create(ByVal parent AS ANY PTR) AS ANY PTR
    Declare Function eb_qt6_network_get(ByVal manager AS ANY PTR, ByVal url AS ZSTRING) AS ANY PTR
    Declare Function eb_qt6_network_reply_wait_for_finished(ByVal reply AS ANY PTR, ByVal timeoutMs AS INTEGER) AS INTEGER
    Declare Sub eb_qt6_network_reply_connect_finished(ByVal reply AS ANY PTR, ByVal cb AS ANY PTR, ByVal userData AS ANY PTR)
    Declare Function eb_qt6_network_reply_has_error(ByVal reply AS ANY PTR) AS INTEGER
    Declare Function eb_qt6_network_reply_error_string(ByVal reply AS ANY PTR) AS ANY PTR
    Declare Function eb_qt6_network_reply_status_code(ByVal reply AS ANY PTR) AS INTEGER
    Declare Function eb_qt6_network_reply_read_all(ByVal reply AS ANY PTR) AS ANY PTR
    Declare Sub eb_qt6_network_reply_delete_later(ByVal reply AS ANY PTR)
End Extern
