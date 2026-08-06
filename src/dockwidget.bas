' Idiomatic layer: QDockWidget. A real QWidget subclass, so WidgetShow/
' WidgetResize/WidgetSetWindowTitle/WidgetDestroy (widget.bas) already
' work on its handle.

#include once "widget.bas"
#include once "raw/qt6_dockwidget.bas"

''' Matches real Qt::DockWidgetArea values - pass directly to
''' MainWindowAddDockWidget.
CONST QtLeftDockWidgetArea = 1
CONST QtRightDockWidgetArea = 2
CONST QtTopDockWidgetArea = 4
CONST QtBottomDockWidgetArea = 8

TYPE DockWidget EXTENDS QtWidget
END TYPE

FUNCTION NewDockWidget(title AS ZSTRING) AS DockWidget
    DIM d AS DockWidget
    d.handle = eb_qt6_dockwidget_create(title)
    NewDockWidget = d
END FUNCTION

''' The dock widget now owns `widget` - see widget.bas's own top comment
''' on the "container now owns it" convention.
SUB DockWidgetSetWidget(BYVAL d AS DockWidget, BYVAL widget AS QtWidget)
    CALL eb_qt6_dockwidget_set_widget(d.handle, widget.handle)
END SUB

''' Docks `d` at `area` (QtLeftDockWidgetArea/QtRightDockWidgetArea/
''' QtTopDockWidgetArea/QtBottomDockWidgetArea) - the window now owns
''' it.
SUB MainWindowAddDockWidget(BYVAL win AS MainWindow, area AS INTEGER, BYVAL d AS DockWidget)
    CALL eb_qt6_mainwindow_add_dock_widget(win.handle, area, d.handle)
END SUB
