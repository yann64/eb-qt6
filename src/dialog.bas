' Idiomatic layer: QDialog, QMessageBox, QFileDialog.
'
' QDialog is a real QWidget subclass, so WidgetShow/WidgetResize/
' WidgetSetWindowTitle/WidgetSetLayout/WidgetDestroy (widget.bas) all
' already work on a Dialog's handle - only Exec/Accept/Reject/
' ConnectFinished are new here.
'
' Every `parent` parameter below is a plain QtWidget - pass an
' unassigned `DIM x AS QtWidget` (zero-initialized handle) for "no
' parent window".

#include once "widget.bas"
#include once "common.bas"
#include once "raw/qt6_dialog.bas"

TYPE Dialog EXTENDS QtWidget
END TYPE

FUNCTION NewDialog() AS Dialog
    DIM d AS Dialog
    d.handle = eb_qt6_dialog_create()
    NewDialog = d
END FUNCTION

''' Blocks (a real Qt modal event loop) until the dialog is closed via
''' Accept/Reject or the OS close button. Returns non-zero (Accepted)
''' or zero (Rejected).
FUNCTION DialogExec(BYVAL d AS Dialog) AS INTEGER
    DialogExec = eb_qt6_dialog_exec(d.handle)
END FUNCTION

SUB DialogAccept(BYVAL d AS Dialog)
    CALL eb_qt6_dialog_accept(d.handle)
END SUB

SUB DialogReject(BYVAL d AS Dialog)
    CALL eb_qt6_dialog_reject(d.handle)
END SUB

''' Connects `handler` (a top-level `SUB YourName(userData AS ANY PTR,
''' accepted AS INTEGER)`) to the dialog's `finished` signal - `accepted`
''' is the same non-zero/zero Accepted/Rejected code DialogExec returns.
SUB DialogConnectFinished(BYVAL d AS Dialog, handler AS ANY PTR, userData AS ANY PTR)
    CALL eb_qt6_dialog_connect_finished(d.handle, handler, userData)
END SUB

SUB MessageBoxInformation(BYVAL parent AS QtWidget, title AS ZSTRING, text AS ZSTRING)
    CALL eb_qt6_messagebox_information(parent.handle, title, text)
END SUB

SUB MessageBoxWarning(BYVAL parent AS QtWidget, title AS ZSTRING, text AS ZSTRING)
    CALL eb_qt6_messagebox_warning(parent.handle, title, text)
END SUB

''' Returns non-zero if the user clicked Yes, zero for No.
FUNCTION MessageBoxQuestion(BYVAL parent AS QtWidget, title AS ZSTRING, text AS ZSTRING) AS INTEGER
    MessageBoxQuestion = eb_qt6_messagebox_question(parent.handle, title, text)
END FUNCTION

''' See ButtonGetText's own doc comment on the owned-allocation/
''' FreeQtString convention. Returns an empty string if the user
''' cancelled.
FUNCTION FileDialogGetOpenFileName(BYVAL parent AS QtWidget, caption AS ZSTRING, dir AS ZSTRING, filter AS ZSTRING) AS ANY PTR
    FileDialogGetOpenFileName = eb_qt6_filedialog_get_open_file_name(parent.handle, caption, dir, filter)
END FUNCTION

''' See FileDialogGetOpenFileName's own doc comment.
FUNCTION FileDialogGetSaveFileName(BYVAL parent AS QtWidget, caption AS ZSTRING, dir AS ZSTRING, filter AS ZSTRING) AS ANY PTR
    FileDialogGetSaveFileName = eb_qt6_filedialog_get_save_file_name(parent.handle, caption, dir, filter)
END FUNCTION
