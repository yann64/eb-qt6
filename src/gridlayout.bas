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

''' Like GridLayoutAddWidget, but also sets the widget's alignment
''' within its cell (Qt::Alignment bitmask, see label.bas's QtAlign*
''' constants - pass 0 to fill the cell, real Qt's own default).
SUB GridLayoutAddWidgetEx(BYVAL layout AS GridLayout, BYVAL widget AS QtWidget, row AS INTEGER, col AS INTEGER, rowSpan AS INTEGER, colSpan AS INTEGER, alignment AS INTEGER)
    CALL eb_qt6_gridlayout_add_widget_align(layout.handle, widget.handle, row, col, rowSpan, colSpan, alignment)
END SUB

''' Per-column/row relative growth weight - real, independent of which
''' widget(s) occupy that column/row.
SUB GridLayoutSetRowStretch(BYVAL layout AS GridLayout, row AS INTEGER, stretch AS INTEGER)
    CALL eb_qt6_gridlayout_set_row_stretch(layout.handle, row, stretch)
END SUB

SUB GridLayoutSetColumnStretch(BYVAL layout AS GridLayout, column AS INTEGER, stretch AS INTEGER)
    CALL eb_qt6_gridlayout_set_column_stretch(layout.handle, column, stretch)
END SUB
