' Raw FFI layer: QDialog, QMessageBox, QFileDialog (`ebqt6shim`).

#include once "qt6_common.bas"

Extern "C" Lib "ebqt6shim"
    Declare Function eb_qt6_dialog_create() AS ANY PTR
    Declare Function eb_qt6_dialog_exec(ByVal dialog AS ANY PTR) AS INTEGER
    Declare Sub eb_qt6_dialog_accept(ByVal dialog AS ANY PTR)
    Declare Sub eb_qt6_dialog_reject(ByVal dialog AS ANY PTR)
    Declare Sub eb_qt6_dialog_connect_finished(ByVal dialog AS ANY PTR, ByVal cb AS ANY PTR, ByVal userData AS ANY PTR)

    Declare Sub eb_qt6_messagebox_information(ByVal parent AS ANY PTR, ByVal title AS ZSTRING, ByVal text AS ZSTRING)
    Declare Sub eb_qt6_messagebox_warning(ByVal parent AS ANY PTR, ByVal title AS ZSTRING, ByVal text AS ZSTRING)
    Declare Sub eb_qt6_messagebox_critical(ByVal parent AS ANY PTR, ByVal title AS ZSTRING, ByVal text AS ZSTRING)
    Declare Function eb_qt6_messagebox_question(ByVal parent AS ANY PTR, ByVal title AS ZSTRING, ByVal text AS ZSTRING) AS INTEGER

    Declare Function eb_qt6_filedialog_get_open_file_name(ByVal parent AS ANY PTR, ByVal caption AS ZSTRING, ByVal dir AS ZSTRING, ByVal filter AS ZSTRING) AS ANY PTR
    Declare Function eb_qt6_filedialog_get_save_file_name(ByVal parent AS ANY PTR, ByVal caption AS ZSTRING, ByVal dir AS ZSTRING, ByVal filter AS ZSTRING) AS ANY PTR
End Extern
