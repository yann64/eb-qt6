' Idiomatic layer: PainterWidget - the one custom-paint widget in this
' package. See native/shim_painterwidget.h's own top comment: the
' `painter` handle a paint callback receives is only valid for the
' duration of that one call - see painter.bas's own top comment.

#include once "widget.bas"
#include once "raw/qt6_painterwidget.bas"

TYPE PainterWidget EXTENDS QtWidget
END TYPE

FUNCTION NewPainterWidget() AS PainterWidget
    DIM w AS PainterWidget
    w.handle = eb_qt6_painterwidget_create()
    NewPainterWidget = w
END FUNCTION

''' Connects `handler` (a top-level `SUB YourName(userData AS ANY PTR,
''' painter AS ANY PTR)`) to fire on every repaint - draw using the
''' painter.bas functions, passing `painter` straight through, only
''' during this call (see this file's own top comment).
SUB PainterWidgetConnectPaint(BYVAL w AS PainterWidget, handler AS ANY PTR, userData AS ANY PTR)
    CALL eb_qt6_painterwidget_set_paint_callback(w.handle, handler, userData)
END SUB
