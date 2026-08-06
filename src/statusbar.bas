' Idiomatic layer: QStatusBar. A MainWindow always manages its own
' status bar (auto-created on first access, matching real Qt idiom) -
' there is no NewStatusBar; use MainWindowStatusBar instead, the same
' convention MainWindowMenuBar (menu.bas) already uses.

#include once "widget.bas"
#include once "raw/qt6_statusbar.bas"

TYPE StatusBar EXTENDS QtWidget
END TYPE

''' Returns the window's own status bar (auto-created by Qt the first
''' time this is called, matching real QMainWindow::statusBar()
''' semantics).
FUNCTION MainWindowStatusBar(BYVAL win AS MainWindow) AS StatusBar
    DIM s AS StatusBar
    s.handle = eb_qt6_mainwindow_status_bar(win.handle)
    MainWindowStatusBar = s
END FUNCTION

''' `timeout` is milliseconds the message stays visible before clearing;
''' 0 means "until replaced" (real Qt default).
SUB StatusBarShowMessage(BYVAL s AS StatusBar, text AS ZSTRING, timeout AS INTEGER)
    CALL eb_qt6_statusbar_show_message(s.handle, text, timeout)
END SUB
