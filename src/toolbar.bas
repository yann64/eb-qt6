' Idiomatic layer: QToolBar. A MainWindow creates and owns its own tool
' bars - there is no NewToolBar; use MainWindowAddToolBar instead, the
' same convention MainWindowMenuBar (menu.bas) already uses. Actions
' added here reuse the same Action TYPE menu.bas defines - wire them up
' with ActionConnectTriggered exactly as a menu action.

#include once "widget.bas"
#include once "menu.bas"
#include once "raw/qt6_toolbar.bas"

TYPE ToolBar EXTENDS QtWidget
END TYPE

''' Creates a new tool bar owned by the window.
FUNCTION MainWindowAddToolBar(BYVAL win AS MainWindow, title AS ZSTRING) AS ToolBar
    DIM t AS ToolBar
    t.handle = eb_qt6_mainwindow_add_toolbar(win.handle, title)
    MainWindowAddToolBar = t
END FUNCTION

''' Creates a new action on the tool bar - owned by the tool bar, see
''' this file's own top comment. Connect it with ActionConnectTriggered.
FUNCTION ToolBarAddAction(BYVAL t AS ToolBar, text AS ZSTRING) AS Action
    DIM a AS Action
    a.handle = eb_qt6_toolbar_add_action(t.handle, text)
    ToolBarAddAction = a
END FUNCTION
