' Idiomatic layer: QScrollArea.

#include once "widget.bas"
#include once "raw/qt6_scrollarea.bas"

TYPE ScrollArea EXTENDS QtWidget
END TYPE

FUNCTION NewScrollArea() AS ScrollArea
    DIM s AS ScrollArea
    s.handle = eb_qt6_scrollarea_create()
    NewScrollArea = s
END FUNCTION

''' The scroll area now owns `widget` - see widget.bas's own top comment
''' on the "container now owns it" convention.
SUB ScrollAreaSetWidget(BYVAL s AS ScrollArea, BYVAL widget AS QtWidget)
    CALL eb_qt6_scrollarea_set_widget(s.handle, widget.handle)
END SUB

''' Real Qt defaults this to off, which often looks wrong (the widget
''' stays at its own size instead of filling the viewport) - most
''' callers want to pass non-zero here.
SUB ScrollAreaSetWidgetResizable(BYVAL s AS ScrollArea, resizable AS INTEGER)
    CALL eb_qt6_scrollarea_set_widget_resizable(s.handle, resizable)
END SUB
