' Idiomatic layer: QGridLayout. Apply it to a widget via WidgetSetLayout
' (widget.bas) exactly like BoxLayout - both are real QLayout
' subclasses under the hood.

#include once "widget.bas"
#include once "raw/qt6_gridlayout.bas"

TYPE GridLayout EXTENDS QtObject
END TYPE

FUNCTION NewGridLayout() AS GridLayout
    DIM l AS GridLayout
    l.handle = eb_qt6_gridlayout_create()
    NewGridLayout = l
END FUNCTION

''' Places `widget` at (row, col), spanning `rowSpan` rows and
''' `colSpan` columns (pass 1 for both if it occupies a single cell).
''' The layout now owns `widget` - see widget.bas's own top comment on
''' the "container now owns it" convention.
SUB GridLayoutAddWidget(BYVAL layout AS GridLayout, BYVAL widget AS QtWidget, row AS INTEGER, col AS INTEGER, rowSpan AS INTEGER, colSpan AS INTEGER)
    CALL eb_qt6_gridlayout_add_widget(layout.handle, widget.handle, row, col, rowSpan, colSpan)
END SUB
