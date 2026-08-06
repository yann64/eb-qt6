' Idiomatic layer: QDial.

#include once "widget.bas"
#include once "raw/qt6_dial.bas"

TYPE Dial EXTENDS QtWidget
END TYPE

FUNCTION NewDial() AS Dial
    DIM d AS Dial
    d.handle = eb_qt6_dial_create()
    NewDial = d
END FUNCTION

SUB DialSetRange(BYVAL d AS Dial, min AS INTEGER, max AS INTEGER)
    CALL eb_qt6_dial_set_range(d.handle, min, max)
END SUB

FUNCTION DialValue(BYVAL d AS Dial) AS INTEGER
    DialValue = eb_qt6_dial_value(d.handle)
END FUNCTION

SUB DialSetValue(BYVAL d AS Dial, value AS INTEGER)
    CALL eb_qt6_dial_set_value(d.handle, value)
END SUB

''' Connects `handler` (a top-level `SUB YourName(userData AS ANY PTR,
''' value AS INTEGER)`) to the dial's `valueChanged` signal.
SUB DialConnectValueChanged(BYVAL d AS Dial, handler AS ANY PTR, userData AS ANY PTR)
    CALL eb_qt6_dial_connect_value_changed(d.handle, handler, userData)
END SUB
