' Idiomatic layer: QScrollBar, used standalone (distinct from
' ScrollArea's own internal scroll bars, scrollarea.bas). Mirrors
' Slider's own function shape (slider.bas) - both are real
' QAbstractSlider subclasses. QtHorizontal/QtVertical (common.bas)
' apply here too.

#include once "widget.bas"
#include once "common.bas"
#include once "raw/qt6_scrollbar.bas"

TYPE ScrollBar EXTENDS QtWidget
END TYPE

FUNCTION NewScrollBar(orientation AS INTEGER) AS ScrollBar
    DIM s AS ScrollBar
    s.handle = eb_qt6_scrollbar_create(orientation)
    NewScrollBar = s
END FUNCTION

SUB ScrollBarSetRange(BYVAL s AS ScrollBar, min AS INTEGER, max AS INTEGER)
    CALL eb_qt6_scrollbar_set_range(s.handle, min, max)
END SUB

FUNCTION ScrollBarValue(BYVAL s AS ScrollBar) AS INTEGER
    ScrollBarValue = eb_qt6_scrollbar_value(s.handle)
END FUNCTION

SUB ScrollBarSetValue(BYVAL s AS ScrollBar, value AS INTEGER)
    CALL eb_qt6_scrollbar_set_value(s.handle, value)
END SUB

''' Connects `handler` (a top-level `SUB YourName(userData AS ANY PTR,
''' value AS INTEGER)`) to the scroll bar's `valueChanged` signal.
SUB ScrollBarConnectValueChanged(BYVAL s AS ScrollBar, handler AS ANY PTR, userData AS ANY PTR)
    CALL eb_qt6_scrollbar_connect_value_changed(s.handle, handler, userData)
END SUB
