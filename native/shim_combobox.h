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

// Lets the user type free-form text into the box, not just pick from
// the existing item list - real QComboBox::setEditable. Typed text
// that isn't Return-committed doesn't change currentIndex/currentText
// on its own; use eb_qt6_combobox_connect_edit_text_changed to observe
// it live, or eb_qt6_combobox_set_edit_text to set it programmatically.
void eb_qt6_combobox_set_editable(void* combo, int editable);
void eb_qt6_combobox_set_edit_text(void* combo, const char* text);
// Fires on every keystroke while editable - `text` is BORROWED, same
// convention as eb_qt6_lineedit_connect_text_changed's own parameter.
void eb_qt6_combobox_connect_edit_text_changed(void* combo, EbQt6StringCallback cb, void* userData);

}
