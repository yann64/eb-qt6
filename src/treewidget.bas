' Idiomatic layer: QTreeWidget (simple item-based API, not the full
' model/view framework). Items are opaque handles owned by the tree (or
' a parent item) - no separate destroy function, the same "container
' now owns it" convention already documented elsewhere in this package.

#include once "widget.bas"
#include once "common.bas"
#include once "inputdialog.bas"
#include once "raw/qt6_treewidget.bas"

TYPE TreeWidget EXTENDS QtWidget
END TYPE

''' A real QTreeWidgetItem is a plain data object, not a QWidget.
TYPE TreeItem EXTENDS QtObject
END TYPE

FUNCTION NewTreeWidget() AS TreeWidget
    DIM t AS TreeWidget
    t.handle = eb_qt6_treewidget_create()
    NewTreeWidget = t
END FUNCTION

''' See this file's own top comment on ownership - a raw item handle
''' returned by a callback should be wrapped via this, not
''' re-constructed.
FUNCTION WrapTreeItem(h AS ANY PTR) AS TreeItem
    DIM item AS TreeItem
    item.handle = h
    WrapTreeItem = item
END FUNCTION

FUNCTION TreeWidgetAddTopLevelItem(BYVAL t AS TreeWidget, text AS ZSTRING) AS TreeItem
    TreeWidgetAddTopLevelItem = WrapTreeItem(eb_qt6_treewidget_add_top_level_item(t.handle, text))
END FUNCTION

FUNCTION TreeItemAddChild(BYVAL parentItem AS TreeItem, text AS ZSTRING) AS TreeItem
    TreeItemAddChild = WrapTreeItem(eb_qt6_treewidget_add_child_item(parentItem.handle, text))
END FUNCTION

''' See ButtonGetText's own doc comment on the owned-allocation/
''' FreeQtString convention.
FUNCTION TreeItemText(BYVAL item AS TreeItem) AS ANY PTR
    TreeItemText = eb_qt6_treeitem_text(item.handle)
END FUNCTION

''' The returned TreeItem's handle is a null ANY PTR if nothing is
''' selected.
FUNCTION TreeWidgetCurrentItem(BYVAL t AS TreeWidget) AS TreeItem
    TreeWidgetCurrentItem = WrapTreeItem(eb_qt6_treewidget_current_item(t.handle))
END FUNCTION

''' Connects `handler` (a top-level `SUB YourName(userData AS ANY PTR,
''' item AS ANY PTR)`) to the tree's `currentItemChanged` signal - `item`
''' is a raw handle, wrap it via WrapTreeItem before calling TreeItemText
''' or TreeItemAddChild on it.
SUB TreeWidgetConnectCurrentItemChanged(BYVAL t AS TreeWidget, handler AS ANY PTR, userData AS ANY PTR)
    CALL eb_qt6_treewidget_connect_current_item_changed(t.handle, handler, userData)
END SUB

''' Multi-column support - TreeWidgetAddTopLevelItem/TreeItemAddChild
''' above only ever set column 0's text; these fill in the rest.
SUB TreeWidgetSetColumnCount(BYVAL t AS TreeWidget, count AS INTEGER)
    CALL eb_qt6_treewidget_set_column_count(t.handle, count)
END SUB

''' `labels` is consumed and destroyed by this call - see StringList's
''' own doc comment (inputdialog.bas).
SUB TreeWidgetSetHeaderLabels(BYVAL t AS TreeWidget, BYVAL labels AS StringList)
    CALL eb_qt6_treewidget_set_header_labels(t.handle, labels.handle)
END SUB

SUB TreeItemSetText(BYVAL item AS TreeItem, column AS INTEGER, text AS ZSTRING)
    CALL eb_qt6_treeitem_set_text(item.handle, column, text)
END SUB

''' See ButtonGetText's own doc comment on the owned-allocation/
''' FreeQtString convention.
FUNCTION TreeItemTextAt(BYVAL item AS TreeItem, column AS INTEGER) AS ANY PTR
    TreeItemTextAt = eb_qt6_treeitem_text_at(item.handle, column)
END FUNCTION

''' Top-level item count only - not a recursive count of every
''' descendant item.
FUNCTION TreeWidgetTopLevelItemCount(BYVAL t AS TreeWidget) AS INTEGER
    TreeWidgetTopLevelItemCount = eb_qt6_treewidget_top_level_item_count(t.handle)
END FUNCTION

SUB TreeWidgetClear(BYVAL t AS TreeWidget)
    CALL eb_qt6_treewidget_clear(t.handle)
END SUB

SUB TreeWidgetExpandAll(BYVAL t AS TreeWidget)
    CALL eb_qt6_treewidget_expand_all(t.handle)
END SUB

SUB TreeWidgetCollapseAll(BYVAL t AS TreeWidget)
    CALL eb_qt6_treewidget_collapse_all(t.handle)
END SUB

SUB TreeItemSetExpanded(BYVAL item AS TreeItem, expanded AS INTEGER)
    CALL eb_qt6_treeitem_set_expanded(item.handle, expanded)
END SUB

''' Off by default in real Qt - clicking a column header does nothing
''' until this is turned on. When on, clicking a header sorts by that
''' column (ascending, then descending on a second click).
SUB TreeWidgetSetSortingEnabled(BYVAL t AS TreeWidget, enabled AS INTEGER)
    CALL eb_qt6_treewidget_set_sorting_enabled(t.handle, enabled)
END SUB
