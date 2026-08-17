' Raw FFI layer: QTreeWidget (`ebqt6shim`).

#include once "qt6_common.bas"

Extern "C" Lib "ebqt6shim"
    Declare Function eb_qt6_treewidget_create() AS ANY PTR
    Declare Function eb_qt6_treewidget_add_top_level_item(ByVal tree AS ANY PTR, ByVal text AS ZSTRING) AS ANY PTR
    Declare Function eb_qt6_treewidget_add_child_item(ByVal parentItem AS ANY PTR, ByVal text AS ZSTRING) AS ANY PTR
    Declare Function eb_qt6_treeitem_text(ByVal item AS ANY PTR) AS ANY PTR
    Declare Function eb_qt6_treewidget_current_item(ByVal tree AS ANY PTR) AS ANY PTR
    Declare Sub eb_qt6_treewidget_connect_current_item_changed(ByVal tree AS ANY PTR, ByVal cb AS ANY PTR, ByVal userData AS ANY PTR)
    Declare Sub eb_qt6_treewidget_set_column_count(ByVal tree AS ANY PTR, ByVal count AS INTEGER)
    Declare Sub eb_qt6_treewidget_set_header_labels(ByVal tree AS ANY PTR, ByVal labels AS ANY PTR)
    Declare Sub eb_qt6_treeitem_set_text(ByVal item AS ANY PTR, ByVal column AS INTEGER, ByVal text AS ZSTRING)
    Declare Function eb_qt6_treeitem_text_at(ByVal item AS ANY PTR, ByVal column AS INTEGER) AS ANY PTR
End Extern
