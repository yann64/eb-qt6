' Idiomatic layer: QTreeWidget (simple item-based API, not the full
' model/view framework). Items are opaque handles owned by the tree (or
' a parent item) - no separate destroy function, the same "container
' now owns it" convention already documented elsewhere in this package.

#include once "widget.bas"
#include once "common.bas"
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
