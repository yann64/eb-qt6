' Idiomatic layer: QStackedWidget.
'
' Like TabWidget (tabwidget.bas), adding the first page makes it
' current, so StackedWidgetAddWidget can fire currentChanged(0)
' SYNCHRONOUSLY, during the call itself - construct anything a
' connected handler touches before adding any pages, not after.

#include once "widget.bas"
#include once "raw/qt6_stackedwidget.bas"

TYPE StackedWidget EXTENDS QtWidget
END TYPE

FUNCTION NewStackedWidget() AS StackedWidget
    DIM s AS StackedWidget
    s.handle = eb_qt6_stackedwidget_create()
    NewStackedWidget = s
END FUNCTION

''' Adds `page` as a new page, returning its index. The stack now owns
''' `page` - see widget.bas's own top comment on the "container now owns
''' it" convention.
FUNCTION StackedWidgetAddWidget(BYVAL s AS StackedWidget, BYVAL page AS QtWidget) AS INTEGER
    StackedWidgetAddWidget = eb_qt6_stackedwidget_add_widget(s.handle, page.handle)
END FUNCTION

FUNCTION StackedWidgetCurrentIndex(BYVAL s AS StackedWidget) AS INTEGER
    StackedWidgetCurrentIndex = eb_qt6_stackedwidget_current_index(s.handle)
END FUNCTION

SUB StackedWidgetSetCurrentIndex(BYVAL s AS StackedWidget, index AS INTEGER)
    CALL eb_qt6_stackedwidget_set_current_index(s.handle, index)
END SUB

''' Connects `handler` (a top-level `SUB YourName(userData AS ANY PTR,
''' index AS INTEGER)`) to the stack's `currentChanged` signal.
SUB StackedWidgetConnectCurrentChanged(BYVAL s AS StackedWidget, handler AS ANY PTR, userData AS ANY PTR)
    CALL eb_qt6_stackedwidget_connect_current_changed(s.handle, handler, userData)
END SUB
