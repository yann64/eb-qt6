' Idiomatic layer: QCalendarWidget. Dates are marshaled as separate int
' components, matching dateedit.bas's own convention.

#include once "widget.bas"
#include once "raw/qt6_calendarwidget.bas"

TYPE CalendarWidget EXTENDS QtWidget
END TYPE

FUNCTION NewCalendarWidget() AS CalendarWidget
    DIM c AS CalendarWidget
    c.handle = eb_qt6_calendarwidget_create()
    NewCalendarWidget = c
END FUNCTION

SUB CalendarWidgetGetSelectedDate(BYVAL c AS CalendarWidget, BYREF outYear AS INTEGER, BYREF outMonth AS INTEGER, BYREF outDay AS INTEGER)
    DIM y AS INTEGER
    DIM m AS INTEGER
    DIM d AS INTEGER
    CALL eb_qt6_calendarwidget_get_selected_date(c.handle, @y, @m, @d)
    outYear = y
    outMonth = m
    outDay = d
END SUB

''' Connects `handler` (a top-level `SUB YourName(userData AS ANY PTR,
''' year AS INTEGER, month AS INTEGER, day AS INTEGER)`) to the
''' calendar's `selectionChanged` signal - real Qt's own version of this
''' signal takes no parameters, so the shim reads selectedDate() itself
''' when it fires and forwards the three components here instead.
SUB CalendarWidgetConnectSelectionChanged(BYVAL c AS CalendarWidget, handler AS ANY PTR, userData AS ANY PTR)
    CALL eb_qt6_calendarwidget_connect_selection_changed(c.handle, handler, userData)
END SUB
