' Idiomatic layer: QLCDNumber. Only integer display is bound - the
' overwhelmingly common case.

#include once "widget.bas"
#include once "raw/qt6_lcdnumber.bas"

TYPE LCDNumber EXTENDS QtWidget
END TYPE

FUNCTION NewLCDNumber() AS LCDNumber
    DIM l AS LCDNumber
    l.handle = eb_qt6_lcdnumber_create()
    NewLCDNumber = l
END FUNCTION

SUB LCDNumberDisplay(BYVAL l AS LCDNumber, value AS INTEGER)
    CALL eb_qt6_lcdnumber_display(l.handle, value)
END SUB
