' Idiomatic layer: QSpinBox.

#include once "widget.bas"
#include once "raw/qt6_spinbox.bas"

TYPE SpinBox EXTENDS QtWidget
END TYPE

FUNCTION NewSpinBox() AS SpinBox
    DIM s AS SpinBox
    s.handle = eb_qt6_spinbox_create()
    NewSpinBox = s
END FUNCTION

SUB SpinBoxSetRange(BYVAL s AS SpinBox, min AS INTEGER, max AS INTEGER)
    CALL eb_qt6_spinbox_set_range(s.handle, min, max)
END SUB

FUNCTION SpinBoxValue(BYVAL s AS SpinBox) AS INTEGER
    SpinBoxValue = eb_qt6_spinbox_value(s.handle)
END FUNCTION

SUB SpinBoxSetValue(BYVAL s AS SpinBox, value AS INTEGER)
    CALL eb_qt6_spinbox_set_value(s.handle, value)
END SUB

''' Connects `handler` (a top-level `SUB YourName(userData AS ANY PTR,
''' value AS INTEGER)`) to the box's `valueChanged` signal.
SUB SpinBoxConnectValueChanged(BYVAL s AS SpinBox, handler AS ANY PTR, userData AS ANY PTR)
    CALL eb_qt6_spinbox_connect_value_changed(s.handle, handler, userData)
END SUB

''' Text shown after the number (e.g. " %", " px") - display only,
''' never part of SpinBoxValue's own integer value.
SUB SpinBoxSetSuffix(BYVAL s AS SpinBox, suffix AS ZSTRING)
    CALL eb_qt6_spinbox_set_suffix(s.handle, suffix)
END SUB

''' Text shown before the number (e.g. "$") - same display-only rule
''' as SpinBoxSetSuffix.
SUB SpinBoxSetPrefix(BYVAL s AS SpinBox, prefix AS ZSTRING)
    CALL eb_qt6_spinbox_set_prefix(s.handle, prefix)
END SUB

''' How much the value changes per up/down arrow click or scroll tick -
''' Qt's own default is 1.
SUB SpinBoxSetSingleStep(BYVAL s AS SpinBox, stepAmount AS INTEGER)
    CALL eb_qt6_spinbox_set_single_step(s.handle, stepAmount)
END SUB
