// eb-qt6 native shim - QListWidget (simple item-based API, not the full
// model/view framework).
#pragma once

#include "shim_common.h"

extern "C" {

void* eb_qt6_listwidget_create();
void eb_qt6_listwidget_add_item(void* list, const char* text);
// Loads a named icon from the current desktop icon theme (e.g.
// "folder") and shows it alongside `text`.
void eb_qt6_listwidget_add_item_with_icon_from_theme(void* list, const char* text, const char* themeIconName);
int eb_qt6_listwidget_current_row(void* list);
void eb_qt6_listwidget_set_current_row(void* list, int row);
// Caller frees the result via eb_qt6_free_string. Empty string if no
// row is selected.
char* eb_qt6_listwidget_current_text(void* list);
void eb_qt6_listwidget_connect_current_row_changed(void* list, EbQt6IntCallback cb, void* userData);
int eb_qt6_listwidget_count(void* list);
void eb_qt6_listwidget_clear(void* list);
// Removes just the one item at `row`, unlike eb_qt6_listwidget_clear's
// remove-everything - real QListWidget::takeItem returns ownership of
// the removed QListWidgetItem* to the caller, so this deletes it
// immediately rather than leaking it (no eBasic-visible handle for a
// removed item exists to hand back anyway).
void eb_qt6_listwidget_remove_row(void* list, int row);
// `mode` matches real QAbstractItemView::SelectionMode values:
// 0=NoSelection, 1=SingleSelection (the default), 2=MultiSelection
// (click toggles each row independently), 3=ExtendedSelection
// (Ctrl/Shift-click, the usual desktop-app feel), 4=ContiguousSelection.
void eb_qt6_listwidget_set_selection_mode(void* list, int mode);
int eb_qt6_listwidget_selected_count(void* list);
// Row number of the `index`-th selected item (0-based, in whatever
// order Qt's own selectedItems() returns them - not necessarily
// visual/ascending order). Returns -1 if `index` is out of range.
int eb_qt6_listwidget_selected_row_at(void* list, int index);

}
