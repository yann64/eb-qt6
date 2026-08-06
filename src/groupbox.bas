' Idiomatic layer: QGroupBox. A real QWidget subclass, so
' WidgetSetLayout (widget.bas) already works to compose its contents.

#include once "widget.bas"
#include once "raw/qt6_groupbox.bas"

TYPE GroupBox EXTENDS QtWidget
END TYPE

FUNCTION NewGroupBox(title AS ZSTRING) AS GroupBox
    DIM g AS GroupBox
    g.handle = eb_qt6_groupbox_create(title)
    NewGroupBox = g
END FUNCTION
