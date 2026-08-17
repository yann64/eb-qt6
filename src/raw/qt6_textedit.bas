' Raw FFI layer: QTextEdit (`ebqt6shim`).

#include once "qt6_common.bas"

Extern "C" Lib "ebqt6shim"
    Declare Function eb_qt6_textedit_create() AS ANY PTR
    Declare Sub eb_qt6_textedit_set_text(ByVal textEdit AS ANY PTR, ByVal text AS ZSTRING)
    Declare Function eb_qt6_textedit_get_text(ByVal textEdit AS ANY PTR) AS ANY PTR
    Declare Sub eb_qt6_textedit_set_html(ByVal textEdit AS ANY PTR, ByVal html AS ZSTRING)
    Declare Function eb_qt6_textedit_get_html(ByVal textEdit AS ANY PTR) AS ANY PTR
    Declare Sub eb_qt6_textedit_connect_text_changed(ByVal textEdit AS ANY PTR, ByVal cb AS ANY PTR, ByVal userData AS ANY PTR)
    Declare Function eb_qt6_textedit_document(ByVal textEdit AS ANY PTR) AS ANY PTR
    Declare Sub eb_qt6_textedit_clear(ByVal textEdit AS ANY PTR)
    Declare Sub eb_qt6_textedit_undo(ByVal textEdit AS ANY PTR)
    Declare Sub eb_qt6_textedit_redo(ByVal textEdit AS ANY PTR)
    Declare Sub eb_qt6_textedit_set_read_only(ByVal textEdit AS ANY PTR, ByVal readOnly AS INTEGER)
End Extern
