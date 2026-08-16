// eb-qt6 native shim - QComboBox.
#pragma once

#include "shim_common.h"

extern "C" {

void* eb_qt6_combobox_create();
void eb_qt6_combobox_add_item(void* combo, const char* text);
// Loads a named icon from the current desktop icon theme (e.g.
// "folder") and shows it alongside `text`. Matches
// eb_qt6_systemtrayicon_set_icon_from_theme's own theme-icon
// convention (shim_systemtrayicon.h).
void eb_qt6_combobox_add_item_with_icon_from_theme(void* combo, const char* text, const char* themeIconName);
// Caller frees the result via eb_qt6_free_string.
char* eb_qt6_combobox_current_text(void* combo);
int eb_qt6_combobox_current_index(void* combo);
void eb_qt6_combobox_set_current_index(void* combo, int index);
void eb_qt6_combobox_connect_current_index_changed(void* combo, EbQt6IntCallback cb, void* userData);

}
