' Idiomatic layer: QTabWidget.

#include once "widget.bas"
#include once "raw/qt6_tabwidget.bas"

TYPE TabWidget EXTENDS QtWidget
END TYPE

FUNCTION NewTabWidget() AS TabWidget
    DIM t AS TabWidget
    t.handle = eb_qt6_tabwidget_create()
    NewTabWidget = t
END FUNCTION

''' Adds `page` as a new tab titled `title`, returning its index. The
''' tab widget now owns `page` - see this file's own shim header comment
''' on the "container now owns it" convention.
FUNCTION TabWidgetAddTab(BYVAL t AS TabWidget, BYVAL page AS QtWidget, title AS ZSTRING) AS INTEGER
    TabWidgetAddTab = eb_qt6_tabwidget_add_tab(t.handle, page.handle, title)
END FUNCTION

FUNCTION TabWidgetCurrentIndex(BYVAL t AS TabWidget) AS INTEGER
    TabWidgetCurrentIndex = eb_qt6_tabwidget_current_index(t.handle)
END FUNCTION

SUB TabWidgetSetCurrentIndex(BYVAL t AS TabWidget, index AS INTEGER)
    CALL eb_qt6_tabwidget_set_current_index(t.handle, index)
END SUB

''' Connects `handler` (a top-level `SUB YourName(userData AS ANY PTR,
''' index AS INTEGER)`) to the widget's `currentChanged` signal.
SUB TabWidgetConnectCurrentChanged(BYVAL t AS TabWidget, handler AS ANY PTR, userData AS ANY PTR)
    CALL eb_qt6_tabwidget_connect_current_changed(t.handle, handler, userData)
END SUB
