// eb-qt6 native shim - QComboBox.
#pragma once

#include "shim_common.h"

extern "C" {

void* eb_qt6_combobox_create();
void eb_qt6_combobox_add_item(void* combo, const char* text);
// Caller frees the result via eb_qt6_free_string.
char* eb_qt6_combobox_current_text(void* combo);
int eb_qt6_combobox_current_index(void* combo);
void eb_qt6_combobox_set_current_index(void* combo, int index);
void eb_qt6_combobox_connect_current_index_changed(void* combo, EbQt6IntCallback cb, void* userData);

}
