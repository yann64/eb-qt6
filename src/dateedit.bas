' Idiomatic layer: QDateEdit/QTimeEdit. Dates/times are marshaled as
' separate int components (year/month/day, hour/min/sec) rather than a
' QDate/QTime wrapper TYPE - see this file's own shim header comment.

#include once "widget.bas"
#include once "raw/qt6_dateedit.bas"

TYPE DateEdit EXTENDS QtWidget
END TYPE

TYPE TimeEdit EXTENDS QtWidget
END TYPE

FUNCTION NewDateEdit() AS DateEdit
    DIM d AS DateEdit
    d.handle = eb_qt6_dateedit_create()
    NewDateEdit = d
END FUNCTION

SUB DateEditSetDate(BYVAL d AS DateEdit, year AS INTEGER, month AS INTEGER, day AS INTEGER)
    CALL eb_qt6_dateedit_set_date(d.handle, year, month, day)
END SUB

SUB DateEditGetDate(BYVAL d AS DateEdit, BYREF outYear AS INTEGER, BYREF outMonth AS INTEGER, BYREF outDay AS INTEGER)
    DIM y AS INTEGER
    DIM m AS INTEGER
    DIM dd AS INTEGER
    CALL eb_qt6_dateedit_get_date(d.handle, @y, @m, @dd)
    outYear = y
    outMonth = m
    outDay = dd
END SUB

FUNCTION NewTimeEdit() AS TimeEdit
    DIM t AS TimeEdit
    t.handle = eb_qt6_timeedit_create()
    NewTimeEdit = t
END FUNCTION

SUB TimeEditSetTime(BYVAL t AS TimeEdit, hour AS INTEGER, minute AS INTEGER, second AS INTEGER)
    CALL eb_qt6_timeedit_set_time(t.handle, hour, minute, second)
END SUB

SUB TimeEditGetTime(BYVAL t AS TimeEdit, BYREF outHour AS INTEGER, BYREF outMinute AS INTEGER, BYREF outSecond AS INTEGER)
    DIM h AS INTEGER
    DIM mi AS INTEGER
    DIM s AS INTEGER
    CALL eb_qt6_timeedit_get_time(t.handle, @h, @mi, @s)
    outHour = h
    outMinute = mi
    outSecond = s
END SUB
