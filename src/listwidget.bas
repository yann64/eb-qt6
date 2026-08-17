' Idiomatic layer: QListWidget (simple item-based API, not the full
' model/view framework).

#include once "widget.bas"
#include once "common.bas"
#include once "raw/qt6_listwidget.bas"

TYPE ListWidget EXTENDS QtWidget
END TYPE

FUNCTION NewListWidget() AS ListWidget
    DIM l AS ListWidget
    l.handle = eb_qt6_listwidget_create()
    NewListWidget = l
END FUNCTION

SUB ListWidgetAddItem(BYVAL l AS ListWidget, text AS ZSTRING)
    CALL eb_qt6_listwidget_add_item(l.handle, text)
END SUB

''' Loads a named icon from the current desktop icon theme (e.g.
''' "folder") and shows it alongside `text`.
SUB ListWidgetAddItemWithIconFromTheme(BYVAL l AS ListWidget, text AS ZSTRING, themeIconName AS ZSTRING)
    CALL eb_qt6_listwidget_add_item_with_icon_from_theme(l.handle, text, themeIconName)
END SUB

FUNCTION ListWidgetCurrentRow(BYVAL l AS ListWidget) AS INTEGER
    ListWidgetCurrentRow = eb_qt6_listwidget_current_row(l.handle)
END FUNCTION

SUB ListWidgetSetCurrentRow(BYVAL l AS ListWidget, row AS INTEGER)
    CALL eb_qt6_listwidget_set_current_row(l.handle, row)
END SUB

''' See ButtonGetText's own doc comment on the owned-allocation/
''' FreeQtString convention. Returns an empty string if no row is
''' selected.
FUNCTION ListWidgetCurrentText(BYVAL l AS ListWidget) AS ANY PTR
    ListWidgetCurrentText = eb_qt6_listwidget_current_text(l.handle)
END FUNCTION

''' Connects `handler` (a top-level `SUB YourName(userData AS ANY PTR,
''' row AS INTEGER)`) to the list's `currentRowChanged` signal.
SUB ListWidgetConnectCurrentRowChanged(BYVAL l AS ListWidget, handler AS ANY PTR, userData AS ANY PTR)
    CALL eb_qt6_listwidget_connect_current_row_changed(l.handle, handler, userData)
END SUB

FUNCTION ListWidgetCount(BYVAL l AS ListWidget) AS INTEGER
    ListWidgetCount = eb_qt6_listwidget_count(l.handle)
END FUNCTION

SUB ListWidgetClear(BYVAL l AS ListWidget)
    CALL eb_qt6_listwidget_clear(l.handle)
END SUB
