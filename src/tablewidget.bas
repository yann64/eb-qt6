' Idiomatic layer: QTableWidget (simple item-based API, not the full
' model/view framework).

#include once "widget.bas"
#include once "common.bas"
#include once "inputdialog.bas"
#include once "raw/qt6_tablewidget.bas"

TYPE TableWidget EXTENDS QtWidget
END TYPE

FUNCTION NewTableWidget() AS TableWidget
    DIM t AS TableWidget
    t.handle = eb_qt6_tablewidget_create()
    NewTableWidget = t
END FUNCTION

SUB TableWidgetSetRowCount(BYVAL t AS TableWidget, rows AS INTEGER)
    CALL eb_qt6_tablewidget_set_row_count(t.handle, rows)
END SUB

SUB TableWidgetSetColumnCount(BYVAL t AS TableWidget, cols AS INTEGER)
    CALL eb_qt6_tablewidget_set_column_count(t.handle, cols)
END SUB

''' Creates the cell's item on first use if none exists yet.
SUB TableWidgetSetItemText(BYVAL t AS TableWidget, row AS INTEGER, col AS INTEGER, text AS ZSTRING)
    CALL eb_qt6_tablewidget_set_item_text(t.handle, row, col, text)
END SUB

''' See ButtonGetText's own doc comment on the owned-allocation/
''' FreeQtString convention. Returns an empty string if the cell has no
''' item yet.
FUNCTION TableWidgetItemText(BYVAL t AS TableWidget, row AS INTEGER, col AS INTEGER) AS ANY PTR
    TableWidgetItemText = eb_qt6_tablewidget_item_text(t.handle, row, col)
END FUNCTION

''' Connects `handler` (a top-level `SUB YourName(userData AS ANY PTR,
''' row AS INTEGER, col AS INTEGER)`) to the table's `cellClicked`
''' signal.
SUB TableWidgetConnectCellClicked(BYVAL t AS TableWidget, handler AS ANY PTR, userData AS ANY PTR)
    CALL eb_qt6_tablewidget_connect_cell_clicked(t.handle, handler, userData)
END SUB

FUNCTION TableWidgetRowCount(BYVAL t AS TableWidget) AS INTEGER
    TableWidgetRowCount = eb_qt6_tablewidget_row_count(t.handle)
END FUNCTION

FUNCTION TableWidgetColumnCount(BYVAL t AS TableWidget) AS INTEGER
    TableWidgetColumnCount = eb_qt6_tablewidget_column_count(t.handle)
END FUNCTION

''' `labels` is consumed and destroyed by this call - see StringList's
''' own doc comment (inputdialog.bas).
SUB TableWidgetSetHorizontalHeaderLabels(BYVAL t AS TableWidget, BYVAL labels AS StringList)
    CALL eb_qt6_tablewidget_set_horizontal_header_labels(t.handle, labels.handle)
END SUB

''' Removes row `row` entirely, shifting later rows up.
SUB TableWidgetRemoveRow(BYVAL t AS TableWidget, row AS INTEGER)
    CALL eb_qt6_tablewidget_remove_row(t.handle, row)
END SUB

FUNCTION TableWidgetCurrentRow(BYVAL t AS TableWidget) AS INTEGER
    TableWidgetCurrentRow = eb_qt6_tablewidget_current_row(t.handle)
END FUNCTION

FUNCTION TableWidgetCurrentColumn(BYVAL t AS TableWidget) AS INTEGER
    TableWidgetCurrentColumn = eb_qt6_tablewidget_current_column(t.handle)
END FUNCTION
