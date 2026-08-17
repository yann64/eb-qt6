// eb-qt6 native shim - QTreeWidget (simple item-based API, not the full
// model/view framework). Items are exposed as opaque handles - the tree
// (or a parent item) owns them, no separate destroy function.
#pragma once

#include "shim_common.h"

extern "C" {

void* eb_qt6_treewidget_create();
// Returns the new item's handle. The tree now owns it.
void* eb_qt6_treewidget_add_top_level_item(void* tree, const char* text);
// Returns the new item's handle. `parentItem` now owns it.
void* eb_qt6_treewidget_add_child_item(void* parentItem, const char* text);
// Caller frees the result via eb_qt6_free_string.
char* eb_qt6_treeitem_text(void* item);
// May return a null ANY PTR if nothing is selected.
void* eb_qt6_treewidget_current_item(void* tree);
void eb_qt6_treewidget_connect_current_item_changed(void* tree, EbQt6PtrCallback cb, void* userData);

// Multi-column support - eb_qt6_treewidget_add_top_level_item/
// add_child_item above only ever set column 0's text (via the
// QTreeWidgetItem constructor); these fill in the rest.
void eb_qt6_treewidget_set_column_count(void* tree, int count);
// Consumes and destroys `labels` (a StringList handle, see
// shim_inputdialog.h's own eb_qt6_stringlist_create) - matches
// eb_qt6_inputdialog_get_item's own consume-and-destroy convention for
// the same StringList type.
void eb_qt6_treewidget_set_header_labels(void* tree, void* labels);
void eb_qt6_treeitem_set_text(void* item, int column, const char* text);
// Caller frees the result via eb_qt6_free_string.
char* eb_qt6_treeitem_text_at(void* item, int column);

}
