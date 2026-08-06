// eb-qt6 native shim - QListWidget (simple item-based API, not the full
// model/view framework).
#pragma once

#include "shim_common.h"

extern "C" {

void* eb_qt6_listwidget_create();
void eb_qt6_listwidget_add_item(void* list, const char* text);
int eb_qt6_listwidget_current_row(void* list);
void eb_qt6_listwidget_set_current_row(void* list, int row);
// Caller frees the result via eb_qt6_free_string. Empty string if no
// row is selected.
char* eb_qt6_listwidget_current_text(void* list);
void eb_qt6_listwidget_connect_current_row_changed(void* list, EbQt6IntCallback cb, void* userData);

}
